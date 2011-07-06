using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class PieValue
    {
        private double val;
        private string text;
        public PieValue(double val)
        {
            this.val = val;
        }
        public static implicit operator PieValue(double val)
        {
            return new PieValue(val,"");
        }
        public PieValue(double val, string text)
        {
            this.val = val;
            this.Text = text;
        }
        [JsonProperty("value")]
        public double Value
        {
            get { return val; }
            set { val = value; }
        }
        [JsonProperty("text")]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }
    }
    public class Pie : Chart<PieValue>
    {
        private int border;
        private IEnumerable<String> colours;
        private double alpha;
        private bool animate;
        private double start_angle;

        public Pie()
        {
            this.ChartType = "pie";
            this.border = 2;
            this.colours = new string[] { "#d01f3c", "#356aa0", "#C79810" };
            this.alpha = 0.6;
            this.animate = true;

        }
        [JsonProperty("colours")]
        public IEnumerable<string> Colours
        {
            get { return this.colours; }
            set
            {
                this.colours = value;
            }
        }
        [JsonProperty("border")]
        public int Border
        {
            get { return border; }
            set { border = value; }
        }
        [JsonProperty("alpha")]
        public double Alpha
        {
            get { return alpha; }
            set { alpha = value; }
        }
        [JsonProperty("animate")]
        public bool Animate
        {
            get { return animate; }
            set { animate = value; }
        }
        [JsonProperty("start-angle")]
        public double StartAngle
        {
            get { return start_angle; }
            set { start_angle = value; }
        }
    }
}
