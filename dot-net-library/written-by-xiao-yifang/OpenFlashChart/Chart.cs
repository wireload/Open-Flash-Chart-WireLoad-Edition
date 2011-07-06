using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public  class Chart<T> :ChartBase
    {
        private string type;
        private IList<T> values;
        private double fillalpha;
        private double fontsize;
        private string colour;
        private string text;
        public Chart()
        {
            this.values = new List<T>();
            Fillalpha = 0.35;
        }
        [JsonProperty("colour")]
        public virtual string Colour
        {
            set { this.colour = value; }
            get { return this.colour; }
        }
        
        public override double GetMaxValue()
        {
            if (values.Count == 0)
                return 0;
            double max = double.MinValue;
            Type valuetype = typeof(T);
            if (!valuetype.IsValueType)
                return 0;
            foreach (T d in values)
            {
                double temp = double.Parse(d.ToString());
                if (temp > max)
                    max = temp;
            }
            return max;
        }
        public override int GetValueCount()
        {
            return values.Count;
        }
        public override double GetMinValue()
        {
            if (values.Count == 0)
                return 0;
            double min = double.MaxValue;
            Type valuetype = typeof (T);
            if (!valuetype.IsValueType)
                return 0;
            foreach (T d in values)
            {
                double temp = double.Parse(d.ToString());
                if(temp<min)
                    min = temp;
            }
            return min;
        }
        [JsonProperty("values")]
        public virtual IList<T> Values
        {
            set
            {
               // foreach (T t in value)
               // {
               //     this.values.Add(t);
               // }
               this.values = value;
            }
            get { return this.values; }
        }
        public void AppendValue(T v)
        {
            this.values.Add(v);
        }
        [JsonProperty("font-size")]
        [System.ComponentModel.DefaultValue(12.0)]
        public double Fontsize
        {
            get { return fontsize; }
            set { fontsize = value; }
        }
        [JsonProperty("text")]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }
        [JsonProperty("fillalpha")]
        public double Fillalpha
        {
            get { return fillalpha; }
            set { fillalpha = value; }
        }

        public virtual void Set_Key(string text, double font_size)
        {
            this.Text = text;
            Fontsize = font_size;
        }
        [JsonProperty("type")]
        public string ChartType
        {
            get { return type; }
            set { type = value; }
        }
    }

   
}
