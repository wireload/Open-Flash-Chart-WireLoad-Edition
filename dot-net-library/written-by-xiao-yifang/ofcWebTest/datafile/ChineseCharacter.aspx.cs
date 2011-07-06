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

public partial class ChineseCharacter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        OpenFlashChart.OpenFlashChart chart = new OpenFlashChart.OpenFlashChart();
        List<double> data1 = new List<double>();

        for (double i = 0; i < 6.2; i += 0.2)
        {
            data1.Add(Math.Sin(i) * 1.9 + 7);
        
        }

        OpenFlashChart.LineHollow line1 = new LineHollow();
        line1.Values = data1;
        line1.HaloSize = 0;
        line1.Width = 2;
        line1.DotSize = 5;

      

        chart.AddElement(line1);

        chart.Title = new Title("中文测试");
        chart.Y_Axis.SetRange(0, 15, 5);

        chart.X_Axis.Labels.Values = (new string[] { "中文测试" ,null,"第二"});

        //when set to vertical ,the chinese character can not be displayed,
        //this may due to the flash ActionScript,the flash embeded font do not support chinese well

        //chart.X_Axis.Labels.Vertical = true;
        Response.Clear();
        Response.CacheControl = "no-cache";
        Response.Write(chart.ToPrettyString());
        Response.End();
    }
}
