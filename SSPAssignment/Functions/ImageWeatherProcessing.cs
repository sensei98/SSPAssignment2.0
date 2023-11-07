using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;
using System.Threading.Tasks;

namespace SSPAssignment.Functions
{
    public class ImageWeatherProcessing
    {
        private readonly HttpClient httpClient;

        [FunctionName("ImageWeatherProcessing")]
        public void Run([QueueTrigger("imagequeue", Connection = "AzureWebJobsStorage")] string myQueueItem, ILogger log)
        {
            //GetWeatherData();
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
        }

        //generating weather data
        //private async Task<string> GetWeatherData()
        //{
        //    var response = await httpClient.GetAsync("https://data.buienradar.nl/2.0/feed/json");
        //    string content = await response.Content.ReadAsStringAsync();
        //    var data = JsonConvert.DeserializeObject<string>(content);
        //    Console.Write(data);

        //    return data;


        //    //var res = await httpClient.GetAsync($"https://www.thecolorapi.com/id?hex={hex}");
        //    //string content = await res.Content.ReadAsStringAsync();
        //    //Color color = JsonConvert.DeserializeObject<Color>(content);
        //    //return color.Name.Value;
        //}
        //Method for generating image 
    }
}
//}

//string jsonDataUrl = "https://data.buienradar.nl/2.0/feed/json";

//using (HttpClient httpClient = new HttpClient())
//{
//    HttpResponseMessage response = await httpClient.GetAsync(jsonDataUrl);

//    if (response.IsSuccessStatusCode)
//    {
//        string jsonContent = await response.Content.ReadAsStringAsync();
//        var data = JsonConvert.DeserializeObject<WeatherData>(jsonContent);

//        if (data != null)
//        {
//            // Enqueue the weather data object.
//            weatherDataQueue.Add(data);
//            log.LogInformation("Enqueued weather data for location: " + data.Location);
//        }
//        else
//        {
//            log.LogError("Failed to deserialize JSON data from the URL.");
//        }
//    }
//    else
//    {
//        log.LogError("Failed to retrieve data from the URL. Status code: " + response.StatusCode);
//    }
//}