using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace SSPAssignment.Models
{
    public class WeatherDataResult
    {
        public Guid id = Guid.NewGuid();
        public Actual actual { get; set; }  
    }
    public class Actual
    {
        [JsonPropertyName("stationmeasurements")] public List<StationMeasurements> stationmeasurements { get; set; }
    }
    public class StationMeasurements
    {
        [JsonPropertyName("stationname")] public string stationname { get; set; }
        [JsonPropertyName("temperature")] public double temperature { get; set; }
    }
}
