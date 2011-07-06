using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;

namespace OpenFlashChart
{
    public class ScatterValue
    {
        private double x;
        private double y;
        private int? dotsize;
        public ScatterValue(double x,double y,int dotsize)
        {
            this.x=x;
            this.y=y;
            if(dotsize>0)
                this.dotsize=dotsize;
        }
        [JsonProperty("x")]
        public double X
        {
            get{return x;}
            set{this.x=value;}
        }
         [JsonProperty("y")]
        public double Y
        {
            get{return y;}
            set{this.y=value;}
        }
         [JsonProperty("dot-size")]
        public int DotSize
        {
            get{
                if (dotsize == null)
                    return -1;

                return dotsize.Value;}
            set{this.dotsize=value;}
        }
    }
   public class Scatter:Chart<ScatterValue>
    {
       private int? dotsize;

       public Scatter(string color,int? dotsize)
       {
           this.ChartType = "scatter";
           this.Colour = color;
           this.dotsize = dotsize;
       }
       [JsonProperty("dot-size")]
       public int? DotSize
       {
           get { return this.dotsize.Value; }
           set { this.dotsize = value; }
       }
    }
}
