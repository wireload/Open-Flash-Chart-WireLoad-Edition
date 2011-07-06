using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class LineBase:Chart<Double>
    {
        private int width;
        private int dotsize;
        private int halosize;


        public LineBase()
        {
            this.ChartType = "line_dot";
          
           
        }
        [JsonProperty("width")]
        public virtual int Width
        {
            set { this.width = value; }
            get { return this.width; }
        }
     
        [JsonProperty("dot-size")]
        public virtual int DotSize
        {
            get { return dotsize; }
            set { dotsize = value; }
        }
        [JsonProperty("halo-size")]
        public virtual int HaloSize
        {
            get { return halosize; }
            set { halosize = value; }
        }
    }
}
