using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Blobs;
using System.Collections.Generic;

namespace SSPAssignment.Functions
{
    public static class GetFinalImageList
    {
        [FunctionName("GetFinalImageList")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req, 
            ILogger log)
        {
            try
            {
                string storageConnectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage");
                
                string editedContainerImages = Environment.GetEnvironmentVariable("ContainerForEditedImages");

               
                BlobServiceClient blobServiceClient = new BlobServiceClient(storageConnectionString);
                BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(editedContainerImages);

                List<string> blobNames = new List<string>();

                await foreach (BlobItem blobItem in containerClient.GetBlobsAsync())
                {
                    blobNames.Add(containerClient.GetBlobClient(blobItem.Name).Uri.ToString());
                }

                var response = new
                {
                    count = blobNames.Count,
                    editedimages = blobNames
                };

                return new OkObjectResult(response);
            }
            catch (Exception ex)
            {
                log.LogError(ex, "An error occurred while listing blobs.");
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
           
        }
    }
}
