using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class XAxisLabels
    {
        private int? steps=1;
        private IList<AxisLabel> labels;
        private string colour;
        private string rotate;
        [JsonProperty("steps")]
        public int? Steps
        {
            get
            {
                if (this.steps == null)
                    return null;
                return this.steps.Value;
            }
            set { this.steps = value; }
        }
        [JsonProperty("labels")]
        public IList<AxisLabel> AxisLabelValues
        {
            get { return labels; }
            set { this.labels = value; }
        }
        [JsonIgnore]
        public IList<string> Values
        {
            set
            {
                if(labels==null)
                    labels=new List<AxisLabel>();
                foreach(string s in value)
                {
                    labels.Add(new AxisLabel(s));
                }
                //this.labels = value;
            }
        }
        [JsonProperty("colour")]
        public string Color
        {
            set { this.colour = value; }
            get { return this.colour; }
        }
        [JsonProperty("rotate")]
        public string Rotate
        {
            set { this.rotate = value; }
            get { return this.rotate; }
        }
        [JsonIgnore]
        public bool Vertical
        {
            set
            {
                if (value)
                    this.rotate = "vertical";
            }
        }
    }
}
