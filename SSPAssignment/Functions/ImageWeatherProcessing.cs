using System;
using Microsoft.Azure.WebJobs;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using System.Text.Json;
using System.Net.Http;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using System.IO;
using System.Linq;
using SSPAssignment.Models;
using Azure.Core;
using Microsoft.Azure.Documents;
using Microsoft.Azure.KeyVault.Core;
using static System.Reflection.Metadata.BlobBuilder;
using System.Data.Common;
using System.Diagnostics.Metrics;
using System.Reflection.Emit;
using System.Reflection.Metadata;
using Newtonsoft.Json;
using JsonSerializer = System.Text.Json.JsonSerializer;
using JsonException = System.Text.Json.JsonException;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace SSPAssignment.Functions
{
    public class ImageWeatherProcessing
    {
        private static readonly HttpClient httpClient = new HttpClient();

        [FunctionName("ImageWeatherProcessing")]

        public static async Task Run([QueueTrigger("imagequeue", Connection = "AzureWebJobsStorage")] string myQueueItem,
            [Queue("imageeditedqueue")] IAsyncCollector<string> secondQueueMessages, ILogger log)
        {
            Random rand = new Random();
            List<StationMeasurements> measurements = await GetWeatherData();
            StationMeasurements station = new StationMeasurements();

            try
            {
                // Obtain fresh images from Unsplash API
                var imageUrls = GetImagesUnsplashAPIAsync();

                // Initialize BlobServiceClient with your connection string
                var blobServiceClient = new BlobServiceClient(Environment.GetEnvironmentVariable("AzureWebJobsStorage"));

                // Create a container client to store the processed images
                var containerName = Environment.GetEnvironmentVariable("BlobContainerName");
                var containerClient = blobServiceClient.GetBlobContainerClient(containerName);


                foreach (var imageUrl in await imageUrls)
                {
                    if (measurements.Count > 0)
                    {
                        int randomIndex = rand.Next(0, measurements.Count);
                        StationMeasurements stationMeasurements = measurements[randomIndex];
                        measurements.RemoveAt(randomIndex);
                        station = stationMeasurements;
                    }

                    using (var httpClient = new HttpClient())
                    {
                        // Fetch the image bytes from the URL
                        var imageBytes = await httpClient.GetByteArrayAsync(imageUrl);

                        // Generate a unique image file name
                        var imageFileName = Guid.NewGuid().ToString() + ".png";

                        // Get a reference to the blob in the container
                        var blobClient = containerClient.GetBlobClient(imageFileName);

                        // Upload the image bytes to Blob Storage
                        using (var stream = new MemoryStream(imageBytes))
                        {
                            await blobClient.UploadAsync(stream, true);
                        }

                        var imagedetails = new WeatherNameAndImage
                        {
                            imageName = imageFileName,
                            stationMeasurements = station
                        };
                        string stationJson = JsonConvert.SerializeObject(imagedetails);



                        // Log a message indicating the image was saved to Blob Storage
                        log.LogInformation($"Image '{imageFileName}' saved to Blob Storage.");
                        await secondQueueMessages.AddAsync(stationJson);

                    }
                }
                
            }
            catch (Exception e)
            {
                // Log an error message for any exceptions that occur during image processing
                log.LogError(e, "An error occurred while processing images.");
            }
        }

        private static async Task<string[]> GetImagesUnsplashAPIAsync()
        {
            var unsplashAccessKey = Environment.GetEnvironmentVariable("SplashAccessKey");

            if (string.IsNullOrWhiteSpace(unsplashAccessKey))
            {
                throw new InvalidOperationException("Unsplash API access key is not configured.");
            }

            return await UnsplashJsonResponseAsync(unsplashAccessKey, 40); // +- 40 depending on return from weather data
        }

        private static async Task<string[]> UnsplashJsonResponseAsync(string accessKey, int count)
        {
            using (var httpClient = new HttpClient())
            {
                var unsplashApiUrl = $"https://api.unsplash.com/photos/random?client_id={accessKey}&count={count}";

                try
                {
                    var response = await httpClient.GetStringAsync(unsplashApiUrl);

                    var options = new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    };

                    var images = JsonSerializer.Deserialize<ImageData[]>(response, options);

                    if (images != null && images.Any())
                    {
                        return images.Select(image => image.urls.regular).ToArray();
                    }
                    else
                    {
                        throw new InvalidOperationException("No images were retrieved from Unsplash API.");
                    }
                }
                catch (HttpRequestException ex)
                {
                    // Handle HTTP request exceptions
                    throw new InvalidOperationException("Error while making the Unsplash API request.", ex);
                }
                catch (JsonException ex)
                {
                    // Handle JSON deserialization exceptions
                    throw new InvalidOperationException("Error while deserializing Unsplash API response.", ex);
                }
            }
        }
        private static async Task<List<StationMeasurements>> GetWeatherData()
        {
            string weatherDataUrl = "https://data.buienradar.nl/2.0/feed/json";
            HttpClient httpClient = new HttpClient();
            var response = await httpClient.GetAsync(weatherDataUrl);
            string content = await response.Content.ReadAsStringAsync();
            WeatherDataResult weatherData = JsonConvert.DeserializeObject<WeatherDataResult>(content);
            List<StationMeasurements> measurements = weatherData.actual.stationmeasurements;

            return measurements;
        }
    }
}
