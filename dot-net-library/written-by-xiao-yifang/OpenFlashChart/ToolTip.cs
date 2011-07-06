using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;

namespace OpenFlashChart
{
    public class ToolTip
    {
        string text;
        public ToolTip(string text)
        {
            this.text = text;
        }
        [JsonProperty("text")]
        public String Text
        {
            get { return text; }
            set { text = value; }
        }
    }
}
