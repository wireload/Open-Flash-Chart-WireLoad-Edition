using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using OpenFlashChart;

public partial class datafile_Line : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        OpenFlashChart.OpenFlashChart chart = new OpenFlashChart.OpenFlashChart();
        List<double> data1 = new List<double>();
        List<double> data2 = new List<double>();
        List<double> data3 = new List<double>();
        for(double i=0;i<6.2;i+=0.2)
        {
            data1.Add(Math.Sin(i)*1.9+7);
            data2.Add(Math.Sin(i) * 1.9 + 10);
            data3.Add(Math.Sin(i) * 1.9 + 4);
        }

        OpenFlashChart.LineHollow line1 = new LineHollow();
        line1.Values = data1;
        line1.HaloSize = 0;
        line1.Width = 2;
        line1.DotSize = 5;

        OpenFlashChart.LineHollow line2 = new LineHollow();
        line2.Values = data2;
        line2.HaloSize = 1;
        line2.Width = 1;
        line2.DotSize = 4;

        OpenFlashChart.LineHollow line3 = new LineHollow();
        line3.Values = data3;
        line3.HaloSize = 1;
        line3.Width = 6;
        line3.DotSize = 4;

        chart.AddElement(line1);
        chart.AddElement(line2);
        chart.AddElement(line3);
        chart.Title = new Title("multi line");
        chart.Y_Axis.SetRange(0,15,5);

        Response.Clear();
        Response.CacheControl = "no-cache";
        Response.Write(chart.ToString());
        Response.End();
    }
}
