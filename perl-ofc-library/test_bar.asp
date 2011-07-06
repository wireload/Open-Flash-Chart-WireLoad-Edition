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

if ( $Request->QueryString("data")->Item == 1 ) {

  
  my $e = $g->get_element('bar');
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(20) );
	}
  $e->set_values($data);
  $g->add_element($e);

  
  $e = $g->get_element('bar_filled');
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(40) );
	}
  $e->set_values($data);
  $g->add_element($e);  

 
	$Response->write($g->render_chart_data());
  $Response->exit();

} else {
  
%>
<html>
  <head>
    <title>OFC Bar Test</title>
  </head>
  <body>
    <h1>OFC Bar Test</h1>
<%
    $Response->write($g->render_swf(600, 400, '?data=1&'.time()));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->

</body>
</html>
<%  
}
%>
