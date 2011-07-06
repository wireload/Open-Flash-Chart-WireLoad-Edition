<%@ Page Language="C#" AutoEventWireup="true" CodeFile="chartcontrol.aspx.cs" Inherits="chartcontrol" %>

<%@ Register Assembly="OpenFlashChart" Namespace="OpenFlashChart" TagPrefix="cc1" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <cc1:OpenFlashChartControl ID="OpenFlashChartControl1" runat="server"  Datafile="datafile/pie.aspx" ExternalSWFfile="" ExternalSWFObjectFile="">
        </cc1:OpenFlashChartControl>
    
        
    </div>
    </form>
</body>
</html>
