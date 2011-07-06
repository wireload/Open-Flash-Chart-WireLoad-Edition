using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Web.UI;

namespace OpenFlashChart
{
    [Designer(typeof(ChartControlDesigner)), Description("Chart control for open flash chart"), ToolboxData("<{0}:OpenFlashChartControl runat=\"server\" ></{0}:OpenFlashChartControl>")]
    public class OpenFlashChartControl : Control
    {
        private int width;
        private int height;
        private string externalSWFfile;
        private string externalSWFObjectFile;

       
        private string datafile;

        [DefaultValue(300)]
        [Category("Appearance")]
        [PersistenceMode(PersistenceMode.Attribute)]
        public int Width
        {
            get
            {
                width = 300;
                if (this.ViewState["width"] != null)
                {
                    width = Convert.ToInt32(this.ViewState["width"]);
                }
                return width;
            }
            set
            {
                this.ViewState["width"] = value;
                width = value;
            }
        }
        [DefaultValue(300)]
        [Category("Appearance")]
        [PersistenceMode(PersistenceMode.Attribute)]
        public int Height
        {
            get
            {
                height = 300;
                if (this.ViewState["height"] != null)
                {
                    height = Convert.ToInt32(this.ViewState["height"]);
                }
                return height;
            }
            set
            {
                this.ViewState["height"] = value;
                height = value;
            }
        }
        [Category("Appearance")]
        [PersistenceMode(PersistenceMode.Attribute)]
        public string ExternalSWFfile
        {
            get { return externalSWFfile; }
            set { externalSWFfile = value.Trim(); }
        }
        [Category("Appearance")]
        [PersistenceMode(PersistenceMode.Attribute)]
        public string ExternalSWFObjectFile
        {
            get { return externalSWFObjectFile; }
            set { externalSWFObjectFile = value.Trim(); }
        }
        
       
        public string DataFile
        {
            get { return datafile; }
            set { datafile = value; }
        }

        protected override void OnInit(EventArgs e)
        {
            const string key = "swfobject";
            string swfobjectfile = ExternalSWFObjectFile;
            if (string.IsNullOrEmpty(ExternalSWFObjectFile))
                swfobjectfile = Page.ClientScript.GetWebResourceUrl(this.GetType(), "OpenFlashChart.swfobject.js");
            
            if (!this.Page.ClientScript.IsClientScriptBlockRegistered(key))
            {
                this.Page.ClientScript.RegisterClientScriptBlock(this.Page.GetType(), key, "<script type=\"text/javascript\" src=\"" + swfobjectfile + "\"></script>");
            }
            base.OnInit(e);
        }
        public override void RenderControl(HtmlTextWriter writer)
        {
            StringBuilder builder = new StringBuilder();
            if (string.IsNullOrEmpty(ExternalSWFfile))
                ExternalSWFfile = Page.ClientScript.GetWebResourceUrl(this.GetType(), "OpenFlashChart.open-flash-chart.swf");
            builder.AppendFormat("<div id=\"{0}\">", this.ClientID);
            builder.AppendLine("</div>");
            builder.AppendLine("<script type=\"text/javascript\">");
            builder.AppendFormat("swfobject.embedSWF(\"{0}\", \"{1}\", \"{2}\", \"{3}\",\"9.0.0\", \"expressInstall.swf\",",
                ExternalSWFfile, this.ClientID, Width, Height);
            builder.Append("{\"data-file\":\"");
            builder.Append(DataFile);
            builder.Append("\"});");
            builder.AppendLine("</script>");
           
            writer.Write(builder.ToString());
            base.RenderControl(writer);
        }
    }
}
