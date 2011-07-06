using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class HBarValue
    {
        private double left;
        private double right;
        public HBarValue(double left,double right)
        {
            this.Left = left;
            this.Right = right;
        }
        [JsonProperty("left")]
        public double Left
        {
            get { return left; }
            set { left = value; }
        }
        [JsonProperty("right")]
        public double Right
        {
            get { return right; }
            set { right = value; }
        }
    }
    public class HBar:Chart<HBarValue>
    {
        public HBar()
        {
            this.ChartType = "hbar";
        }
    }
}
