using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class XAxis:Axis
    {
        private string tick_height;
        private XAxisLabels labels;
        private bool offset;
        public void SetRange(double min, double max)
        {
            base.Max = max;
            base.Min = min;
        }
        [JsonProperty("offset")]
        public bool Offset
        {
            set { offset = value; }
            get { return offset; }
        }
        [JsonProperty("labels")]
        public   XAxisLabels Labels
        {
            get
            {
                if(this.labels==null)
                    this.labels = new XAxisLabels();
                return this.labels;
            }
            set { this.labels = value; }
        }
        [JsonProperty("tick-height")]
        public string TickHeight
        {
            get { return tick_height; }
            set { tick_height = value; }
        }
    }
}
