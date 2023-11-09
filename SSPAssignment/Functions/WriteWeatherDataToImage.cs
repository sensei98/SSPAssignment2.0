using System;
using Azure.Data.Tables;
using Azure.Storage.Queues;
using Microsoft.Azure.Storage.Blob;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage;
using Azure.Storage.Blobs;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using SSPAssignment.Models;
using System.Collections.Generic;
using System.Xml;
using SixLabors.ImageSharp.PixelFormats;
using System.Reflection.PortableExecutable;
using Microsoft.Identity.Client;
using Azure.Storage.Blobs.Models;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Formats.Png;
using SixLabors.ImageSharp;
using System.Net;

namespace SSPAssignment.Functions
{
    public class WriteWeatherDataToImage
    {
        [FunctionName("WriteWeatherDataToImage")]
        public async Task Run([QueueTrigger("imageeditedqueue", Connection = "AzureWebJobsStorage")] string jsondata, ILogger log)
        {

            WeatherNameAndImage weatherimagedata = JsonConvert.DeserializeObject<WeatherNameAndImage>(jsondata);
            string Connection = Environment.GetEnvironmentVariable("AzureWebJobsStorage");
            string containerName = Environment.GetEnvironmentVariable("BlobContainerName");
            string editedContainerImages = Environment.GetEnvironmentVariable("ContainerForEditedImages");


            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(Connection);

            Microsoft.WindowsAzure.Storage.Blob.CloudBlobClient cloudBlobClient = storageAccount.CreateCloudBlobClient();

            Microsoft.WindowsAzure.Storage.Blob.CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(containerName);

            Microsoft.WindowsAzure.Storage.Blob.CloudBlockBlob cloudBlockBlob = cloudBlobContainer.GetBlockBlobReference(weatherimagedata.imageName);

            MemoryStream ms = new MemoryStream();

            await cloudBlockBlob.DownloadToStreamAsync(ms);
            ms.Position = 0;


            BlobClient blobClient = new BlobClient(Connection, editedContainerImages, weatherimagedata.imageName);
            if (await blobClient.ExistsAsync())
            {
                await blobClient.DeleteAsync();
            }

            Stream imageStream = new MemoryStream();
            int x = 0;
            int y = 0;

            imageStream = ImageHelper.AddTextToImage(ms, (weatherimagedata.stationMeasurements.stationname + " " + weatherimagedata.stationMeasurements.temperature, (x, y), 100, "#FFC0CB"));
            await blobClient.UploadAsync(imageStream);
        }
    }
}           


