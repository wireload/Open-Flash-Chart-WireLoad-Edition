using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using OpenFlashChart;
using BarSketch=OpenFlashChart.BarSketch;
using Legend=OpenFlashChart.Legend;

public partial class Pie : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        OpenFlashChart.OpenFlashChart chart = new OpenFlashChart.OpenFlashChart();
        chart.Title = new Title("Pie Chart");

        OpenFlashChart.Pie pie = new OpenFlashChart.Pie();
        Random random = new Random();

        List<PieValue> values = new List<PieValue>();
        List<string> labels = new List<string>();
        for (int i = 0; i < 12; i++)
        {
            values.Add(new PieValue(random.NextDouble(),"Pie"+i));
            labels.Add(i.ToString());
        }
        values.Add(0.2);
        pie.Values = values;

       // pie.Alpha = 50;

        //pie.Colour = "#fff";
        pie.Colours = new string[]{"#04f","#1ff","#6ef","#f30"};
        chart.AddElement(pie);
        string s = chart.ToPrettyString();
        Response.Clear();
        Response.CacheControl = "no-cache";
        Response.Write(s);
        Response.End();
    }
}
