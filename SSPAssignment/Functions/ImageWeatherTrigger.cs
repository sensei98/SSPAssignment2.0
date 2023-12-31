using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Azure;
using Azure.Storage.Blobs;
using System.Collections.Generic;

namespace SSPAssignment.Functions
{
    public static class ImageWeatherTrigger
    {
        [FunctionName("ImageWeatherTrigger")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req, [Queue("imagequeue", Connection = "AzureWebJobsStorage")] IAsyncCollector<string> queue,
             ILogger log)
        {
            try
            {
                
                string jobId = Guid.NewGuid().ToString();
                await queue.AddAsync($"Processing Images with id {jobId}");
                string link = "https://sspassignment641496.azurewebsites.net/api/GetFinalImageList?";

                var response = new
                {
                    JobId = jobId,
                    Message = $"Image processing job with id {jobId} queue running. Check storage blob",
                    Endpoint = $"Click {link} here to go to the endpoint to list the editedimages."
                };

                return new OkObjectResult(response);
            }
            catch(Exception ex)
            {
                log.LogError(ex, "An error occurred while processing the request.");
                return new ObjectResult("Internal server error") { StatusCode = 500 };
            }
           
        }

    }
}
