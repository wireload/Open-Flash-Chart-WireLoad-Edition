using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;

namespace OpenFlashChart
{
    public class AreaHollow:Chart<double >
    {
       
       
        private int width;
        private double dotsize;

      
      
        public AreaHollow()
        {
            this.ChartType = "area_hollow";
          
           
        }
        [JsonProperty("width")]
        public virtual int Width
        {
            set { this.width = value; }
            get { return this.width; }
        }
     
        [JsonProperty("dot-size")]
        public virtual double DotSize
        {
            get { return dotsize; }
            set { dotsize = value; }
        }
      
        
      
    }

    
}
