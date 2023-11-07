using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using Newtonsoft.Json;
using Azure.Storage.Queues;
using Azure.Storage.Blobs;
using Azure.Data.Tables;
using System.Net.Http;
using SSPAssignment.Models;
using System.Net.Http.Json;
using System.Text;
using JsonException = Newtonsoft.Json.JsonException;
using System.Reflection.Metadata;

namespace SSPAssignment.Functions
{
    public static class ImageWeatherGenerator
    {

        [FunctionName("ImageWeatherGenerator")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequest req,
            ILogger log)
        {

            string weatherDataUrl = "https://data.buienradar.nl/2.0/feed/json";
            HttpClient httpClient = new HttpClient();
            var response = await httpClient.GetAsync(weatherDataUrl);
            string content = await response.Content.ReadAsStringAsync();
            WeatherDataResult weatherData = JsonConvert.DeserializeObject<WeatherDataResult>(content);
          
            
            

            return new OkObjectResult(new {weatherData});

        }


    }
}
