using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace SSPAssignment.Models
{
    public class ImageData
    {
        public string id { get; set; }
        public string description { get; set; }
        [JsonPropertyName("urls")] public Urls urls { get; set; }
        public class Urls
        {
            [JsonPropertyName("raw")] public string raw { get; set; }
            [JsonPropertyName("full")] public string full { get; set; }
            [JsonPropertyName("regular")] public string regular { get; set; }
            [JsonPropertyName("small")] public string small { get; set; }
            [JsonPropertyName("thumb")] public string thumb { get; set; }
        }
    }
}
