<%@ Language="PerlScript"%>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart qw(random_color);

my $g = chart->new();

if ( $Request->QueryString("data")->Item == 1 ) {

  
  my $e = $g->get_element('bar_stack');
  
  $e->set_values([
    [{"val"=>rand(20),"colour"=>random_color()},{"val"=>rand(40),"colour"=>random_color()}],
    [{"val"=>rand(20),"colour"=>random_color()},{"val"=>rand(20),"colour"=>random_color()},{"val"=>rand(20),"colour"=>random_color()}],
    [{"val"=>rand(10)},{"val"=>rand(20)},{"val"=>rand(30)}],
    [{"val"=>rand(20)},{"val"=>rand(20)},{"val"=>rand(20)}],
    [{"val"=>rand(5)},{"val"=>rand(10)},{"val"=>rand(5)},{"val"=>rand(20)},{"val"=>rand(5),"colour"=>random_color()},{"val"=>rand(5)},{"val"=>rand(5)}]
   ]);  
  
  $g->add_element($e);

  $Response->{'ContentType'} = "text/javascript";
	$Response->write($g->render_chart_data());
  $Response->exit();

} else {
  
%>
<html>
  <head>
    <title>OFC Stack Bar Test</title>
  </head>
  <body>
    <h1>OFC Stack Bar Test</h1>
<%
  $Response->write($g->render_swf(600, 400, '?data=1&'.time()));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->
</body>
</html>
<%  
}
%>
