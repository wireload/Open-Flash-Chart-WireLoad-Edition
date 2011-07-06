<%@ Language="PerlScript"%>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart;

my $g = chart->new();
#$g->{'chart_props'}->{'tooltip'} = {'text'=>'#val#'};

if ( $Request->QueryString("data")->Item == 1 ) {

  my $e = $g->get_element('pie');
  $g->add_element($e);
  
	$Response->write($g->render_chart_data());
  $Response->exit();

} else {
  
%>
<html>
  <head>
    <title>OFC Pie Test</title>
  </head>
  <body>
    <h1>OFC Pie Test</h1>
<%
  $Response->write($g->render_swf(600, 400, '?data=1&'.time()));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->
</body>
</html>
<%  
}
%>
