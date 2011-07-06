using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
   public class BarStackValue
   {
       private string colour;
       private double val;
       public BarStackValue(double val,string color)
       {
           this.Colour = color;
           this.Val = val;
       }
       [JsonProperty("colour")]
       public string Colour
       {
           get { return colour; }
           set { colour = value; }
       }
       [JsonProperty("val")]
       public double Val
       {
           get { return val; }
           set { val = value; }
       }
   }
    public class BarStack:Chart<BarStackValue>
    {
        public BarStack()
        {
            this.ChartType = "bar_stack";
        }
    }
}
