using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace SSPAssignment.Functions
{
    public class WriteWeatherDataToImage
    {
        [FunctionName("WriteWeatherDataToImage")]
        public void Run([QueueTrigger("imagequeue", Connection = "AzureWebJobsStorage")]string myQueueItem, ILogger log)
        {
            
        }
    }
}
