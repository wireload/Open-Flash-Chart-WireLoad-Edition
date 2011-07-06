#!C:/perl/bin/perl -w

use open_flash_chart;


my $g = chart->new();
  
my $e = $g->get_element('bar');
$g->add_element($e);



print $g->render_chart_data();
