using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public  class BarGlassValue
    {
        public BarGlassValue(string top)
        {
            this.top = top;
        }

        private string top;
        private string colour;
        private string tooltip;
        [JsonProperty("top")]
        public string Top
        {
            get { return top; }
            set { top = value; }
        }
        [JsonProperty("colour")]
        public string Colour
        {
            get { return colour; }
            set { colour = value; }
        }
        [JsonProperty("tip")]
        public string Tooltip
        {
            get { return tooltip; }
            set { tooltip = value; }
        }
    }
    public class BarGlass : Chart<BarGlassValue>
    {
        public BarGlass()
        {
            this.ChartType = "bar_glass";
        }
    }
}
