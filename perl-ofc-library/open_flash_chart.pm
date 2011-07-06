
use strict; use warnings;


# This class manages all functions of the open flash chart api.
package chart;
sub new() {
  # Constructer for the open_flash_chart_api
  # Sets our default variables
  my ($proto, $skip_bootstrap) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  
  $self->{'data_load_type'} = 'inline_js'; # or 'url_callback'  not sure if we still need both
  
  $self->{'skip_bootstrap'} = 0; # you can set this to 1 if you want to handle the includes
  $self->{'skip_bootstrap'} = $skip_bootstrap if defined($skip_bootstrap);
  
  $self->{'chart_props'} = {

    "title"=>{
      "text"=>"Default Chart Title",
      "style"=>"{font-size:20px; font-family:Verdana; text-align:center;}"
    },
  };

  my $x = axis->new('x_axis');
  $x->set_min(undef);
  $x->set_max(undef);
  $x->set_labels({"labels"=>["January","February","March","April","May"]});
  
  my $y = axis->new('y_axis');
  $y->set_steps(5);
  
  $self->{'axis'} = {
  	'x_axis' => $x,
  	'y_axis' => $y
  };
  $self->{'elements'} = [];
  
  return $self;
}

# props are at the chart level, such as axis
sub get_axis() {
  my ($self, $name) = @_;
  
  my $e=undef;
  eval("\$e = ${name}->new();");
  if ( defined($e) ) {
    return $e;
  } 
}

sub add_axis() {
  my ($self, $prop) = @_;
  push(@{$self->{'props'}}, $prop);
}

# elements are the data series items, usually containing values to plot
sub get_element() {
  my ($self, $element_name) = @_;
  
  my $e=undef;
  eval("\$e = ${element_name}->new();");
  if ( defined($e) ) {
    return $e;
  } 
}

sub add_element() {
  my ($self, $element) = @_;
  if ( $element->{'use_extremes'} == 1 ) {
  	$self->use_extremes();
  }
  push(@{$self->{'elements'}}, $element);
}

sub use_extremes {
  my ($self) = @_;

  for ( keys %{$self->{'axis'}} ) {
  	$self->{'axis'}->{$_}->{'props'}->{'max'} = 'a';
  	$self->{'axis'}->{$_}->{'props'}->{'min'} = 'a';
  }  
}

sub render_chart_data() {
  my ($self) = @_;

  my $tmp = '';

  my $ext = $self->get_auto_extremes();
  
  $tmp .= "{";
  $tmp .= main::to_json($self->{'chart_props'});

  for ( keys %{$self->{'axis'}} ) {
  	if ($self->{'axis'}->{$_}->{'props'}->{'max'} eq 'a') {
			$self->{'axis'}->{$_}->{'props'}->{'max'} = main::smooth_max($ext->{$_ . '_max'});
		}
  	if ($self->{'axis'}->{$_}->{'props'}->{'min'} eq 'a') {
			$self->{'axis'}->{$_}->{'props'}->{'min'} = main::smooth_min($ext->{$_ . '_min'});
		}
    $tmp .= $self->{'axis'}->{$_}->to_json();
  }  

  if ( @{$self->{'elements'}} > 0 ) {
    $tmp .= "\n".'"elements" : [';
    for my $s ( @{$self->{'elements'}} ) {
      $tmp .= $s->to_json() . ',';  
    }  
    $tmp =~ s/,$//g;
    $tmp .= ']';
  }
  $tmp =~ s/,$//g;
  $tmp .= "\n}";

  return $tmp;
}


sub render_swf {
  my ($self, $width, $height, $data_url) = @_;

  my $html = '';
  
  if ( $self->{'data_load_type'} eq 'inline_js' ) {
    if ($self->{'skip_bootstrap'} == 0 ) {
      $html.='<script type="text/javascript" src="swfobject.js"></script>';
      $self->{'skip_bootstrap'} = 1;
    }
    $html .= qq^
    <div id="my_chart"></div>
    <script type="text/javascript">
      var so = new SWFObject("open-flash-chart.swf", "ofc", "$width", "$height", "9", "#FFFFFF");
      so.addVariable("data-file", "$data_url");
      so.addParam("allowScriptAccess", "always" );//"sameDomain");
      so.write("my_chart");
    </script>
    ^;
  } else {
    $html .= qq^
    <object
      classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
      codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
      width="$width"
      height="$height"
      id="graph_2"
      align="middle">
    <param name="allowScriptAccess" value="sameDomain" />
    <param name="movie" value="open-flash-chart.swf?width=$width&height=$height&data=$data_url"/>
    <param name="quality" value="high" />
    <param name="bgcolor" value="#FFFFFF" />
    <embed
      src="open-flash-chart.swf?width=$width&height=$height&data=$data_url"
      quality="high"
      bgcolor="#FFFFFF"
      width="$width"
      height="$height"
      name="open-flash-chart"
      align="middle"
      allowScriptAccess="sameDomain"
      type="application/x-shockwave-flash"
      pluginspage="http://www.macromedia.com/go/getflashplayer"
    />
    </object>
    ^;
  }

  return $html;
}

#
# control how the auto max works
#
# @param $smooth_rounding an int argument.
#   1 or 0: rounds the y_max to the nearest 10, 50, 100, 200, or 500
# @param $head_room an decimal argument.
#   defines how much extra y scale you want above your highest data point
#   defaults to 0.1 (or 10%) extra space at the top of a chart
sub get_auto_extremes() {
  my ($self, $smooth_rounding, $head_room) = @_;
  $smooth_rounding = 1 if !defined($smooth_rounding);
  $head_room = 0.1 if !defined($head_room);
  
  my $extremes = {'x_axis_max' => undef, 'x_axis_min' => undef, 'y_axis_max' => undef, 'y_axis_min' => undef, 'other' => undef};
    
  for my $e ( @{$self->{'elements'}} ) {

    $extremes->{'x_axis_max'} = $e->{'extremes'}->{'x_axis_max'} if !defined($extremes->{'x_axis_max'});
    if ( $e->{'extremes'}->{'x_axis_max'} > $extremes->{'x_axis_max'} ) {
        $extremes->{'x_axis_max'} = $e->{'extremes'}->{'x_axis_max'};
    }

    $extremes->{'y_axis_max'} = $e->{'extremes'}->{'y_axis_max'} if !defined($extremes->{'y_axis_max'});
    if ( $e->{'extremes'}->{'y_axis_max'} > $extremes->{'y_axis_max'} ) {
        $extremes->{'y_axis_max'} = $e->{'extremes'}->{'y_axis_max'};
    }

    $extremes->{'x_axis_min'} = $e->{'extremes'}->{'x_axis_min'} if !defined($extremes->{'x_axis_min'});
    if ( $e->{'extremes'}->{'x_axis_min'} < $extremes->{'x_axis_min'} ) {
        $extremes->{'x_axis_min'} = $e->{'extremes'}->{'x_axis_min'};
    }

    $extremes->{'y_axis_min'} = $e->{'extremes'}->{'y_axis_min'} if !defined($extremes->{'y_axis_min'});
    if ( $e->{'extremes'}->{'y_axis_min'} < $extremes->{'y_axis_min'} ) {
        $extremes->{'y_axis_min'} = $e->{'extremes'}->{'y_axis_min'};
    }

  }
 
  return $extremes;
}











#Not Yet Supported
#"area_hollow",
#"hbar",



#############################
sub _____ELEMENT_OBJECTS_____(){}
#############################
package element;
use Carp qw(cluck);

our $AUTOLOAD;
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};

	$self->{'extremes'} = {};
  $self->{'element_props'} =  {
    'type'      => '',
    'values'    => [1.5,1.69,1.88,2.06,2.21],
  };
  return bless $self, $class;
}

sub set_values {
  my ($self, $values_arg) = @_;
  $self->{'element_props'}->{'values'} = $values_arg if defined($values_arg);
  $self->set_extremes();
}

sub set_extremes {
  my ($self) = @_;
  my $extremes = {'x_axis_max' => undef, 'x_axis_min' => undef, 'y_axis_max' => undef, 'y_axis_min' => undef, 'other' => undef};
  for ( @{$self->{'element_props'}->{'values'}} ) {
    if ( ref($_) eq 'HASH' || ref($_) eq 'ARRAY' ) {
      return $extremes;
    }
    $extremes->{'y_axis_max'} = $_ if !defined($extremes->{'y_axis_max'});
    if ( $_ > $extremes->{'y_axis_max'} ) {
      $extremes->{'y_axis_max'} = $_;
    }
    $extremes->{'y_axis_min'} = $_ if !defined($extremes->{'y_axis_min'});
    if ( $_ < $extremes->{'y_axis_min'} ) {
      $extremes->{'y_axis_min'} = $_;
    }
  }
  $self->{'extremes'} = $extremes;
}

sub to_json() {
  my ($self) = @_;
  my $json = main::to_json($self->{'element_props'});
  $json =~ s/,$//g;
  return '{' . $json . '}';
}
sub AUTOLOAD {
	my $self = shift;
	my $type = ref($self) or warn "$self is not an object";

	my $name = $AUTOLOAD;
	$name =~ s/.*://;   # strip fully-qualified portion
	
	if ( $name eq 'values' ) {
	  $self->{'element_props'}->{'values'} = [];
	  cluck "You need to call set_values() instead of plain values().";
	  return undef;
	}
	
	$name =~ s/^set_//; # strip set_
	$name =~ s/^get_//; # strip get_

	unless (exists $self->{'element_props'}->{$name} ) {
	  cluck "'$name' is not a valid property in class $type";
	  return undef;
	}

	if (@_) {
	  return $self->{'element_props'}->{"$name"} = shift;
	} else {
    return $self->{'element_props'}->{"$name"};
	}
}
sub DESTROY {  }


package bar_and_line_base;
our @ISA = qw(element);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'colour'} = main::random_color();
  $self->{'element_props'}->{'text'} = 'text';
  $self->{'element_props'}->{'font-size'} = 10;

  #$self->{'element_props'}->{'show_y2'} = 'false';
  #$self->{'element_props'}->{'y2_lines'} = [];
  #$self->{'element_props'}->{'values_2'} = [];

  return $self;
}





#
#
# LINE TYPES
#
#
package line;
our @ISA = qw(bar_and_line_base);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'width'} = 2;
  return $self;
}
package line_dot;
our @ISA = qw(line);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'dot-size'} = 6;
  return $self;
}
package line_hollow;
our @ISA = qw(line);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'dot-size'} = 8;
  return $self;
}
package area_hollow;
our @ISA = qw(bar_and_line_base);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'width'} = 2;
  $self->{'element_props'}->{'fill'} = '';
  $self->{'element_props'}->{'text'} = '';
  $self->{'element_props'}->{'dot-size'} = 5;
  $self->{'element_props'}->{'halo-size'} = 2;
  $self->{'element_props'}->{'fill-alpha'} = 0.6;
  return $self;
}


#
#
# BAR TYPES
#
#
package bar;
our @ISA = qw(bar_and_line_base);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'alpha'} = 0.5;
  return $self;
}

package bar_3d;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_fade;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_glass;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_sketch;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_filled;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'outline-colour'} = main::random_color();
  return $self;
}

package bar_stack;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'text'} = __PACKAGE__ . ' ' . $self->{'element_props'}->{'text'};
  $self->{'element_props'}->{'values'} = [
                    [{"val"=>1},{"val"=>3}],
                    [{"val"=>1},{"val"=>1},{"val"=>2.5}],
                    [{"val"=>5},{"val"=>5},{"val"=>2},{"val"=>2},{"val"=>2,"colour"=>main::random_color()},{"val"=>2},{"val"=>2}]
                   ];
  
  return $self;
}

#stackbar must override set_extremes() because of nested value list
sub set_extremes {
  my ($self) = @_;
  my $extremes = {'x_axis_max' => undef, 'x_axis_min' => undef, 'y_axis_max' => undef, 'y_axis_min' => undef, 'other' => undef};
  for my $v ( @{$self->{'element_props'}->{'values'}} ) {
    my $bar_ext = {'x_axis_max' => undef, 'x_axis_min' => undef, 'y_axis_max' => undef, 'y_axis_min' => undef, 'other' => undef};
    if (ref($v) eq 'ARRAY') {
      for ( @$v ) {
        next if !defined($_->{'val'});
        if ( !defined($bar_ext->{'y_axis_max'}) ) {
          $bar_ext->{'y_axis_max'} = $_->{'val'} ;
        } else {
          $bar_ext->{'y_axis_max'} += $_->{'val'};
        }
      }
    }
    if ( $bar_ext->{'y_axis_max'} > $extremes->{'y_axis_max'} ) {
      $extremes->{'y_axis_max'} = $bar_ext->{'y_axis_max'};
    }
  }
  $self->{'extremes'} = $extremes;
}


package pie;
our @ISA = qw(element);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'alpha'} = 0.5;
  $self->{'element_props'}->{'colours'} = [main::random_color(), main::random_color(), main::random_color(), main::random_color(), main::random_color()];
  $self->{'element_props'}->{'border'} = 2;
  $self->{'element_props'}->{'animate'} = 1;
  $self->{'element_props'}->{'start-angle'} = 0;
  
  $self->{'element_props'}->{'values'} = [ {'value'=>rand(255), 'text'=>'linux'}, {'value'=>rand(255), 'text'=>'windows'}, {'value'=>rand(255), 'text'=>'vax'}, {'value'=>rand(255), 'text'=>'NexT'}, {'value'=>rand(255), 'text'=>'solaris'}];

  return $self;
}


package scatter;
our @ISA = qw(element);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'use_extremes'} = 1;	# scatter needs x-y min-maxes to print
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'values'} = [
    {"x"=>-5,  "y"=>-5 },
    {"x"=>0,   "y"=>0  },
    {"x"=>5,   "y"=>5,  "dot-size"=>20},
    {"x"=>5,   "y"=>-5, "dot-size"=>5},
    {"x"=>-5,  "y"=>5,  "dot-size"=>5},
    {"x"=>0.5, "y"=>1,  "dot-size"=>15}
  ];

  return $self;
}
sub set_extremes {
  my ($self) = @_;
  my $extremes = {'x_axis_max' => undef, 'x_axis_min' => undef, 'y_axis_max' => undef, 'y_axis_min' => undef, 'other' => undef};
  for ( @{$self->{'element_props'}->{'values'}} ) {
    $extremes->{'y_axis_max'} = $_->{'y'} if !defined($extremes->{'y_axis_max'});
    if ( $_->{'y'} > $extremes->{'y_axis_max'} ) {
      $extremes->{'y_axis_max'} = $_->{'y'};
    }
    $extremes->{'y_axis_min'} = $_->{'y'} if !defined($extremes->{'y_axis_min'});
    if ( $_->{'y'} < $extremes->{'y_axis_min'} ) {
      $extremes->{'y_axis_min'} = $_->{'y'};
    }

    $extremes->{'x_axis_max'} = $_->{'x'} if !defined($extremes->{'x_axis_max'});
    if ( $_->{'x'} > $extremes->{'x_axis_max'} ) {
      $extremes->{'x_axis_max'} = $_->{'x'};
    }
    $extremes->{'x_axis_min'} = $_->{'x'} if !defined($extremes->{'x_axis_min'});
    if ( $_->{'x'} < $extremes->{'x_axis_min'} ) {
      $extremes->{'x_axis_min'} = $_->{'x'};
    }

  }
  $self->{'extremes'} = $extremes;
}

#############################
sub _____AXIS_OBJECTS_____(){}
#############################
package axis;
use Carp qw(cluck);

our $AUTOLOAD;
sub new() {
  my ($proto, $name) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  $self->{'name'} = $name; # x_axis | y_axis | y_axis_right
  $self->{'props'} =  {
  	'labels' =>       undef,
		'stroke' =>				undef,
		'tick-length' =>	undef,
		'colour' =>				undef,
		'offset' =>				undef,
		'grid-colour' =>	undef,
		'3d' =>						undef,
		'steps' =>				undef,
		'visible' =>			undef,
		'min' =>					undef,
		'max' =>					'a'
  };
  return bless $self, $class;
}

sub to_json() {
  my ($self) = @_;
  my $json = main::to_json($self->{'props'}, $self->{'name'});
  #$json =~ s/,$//g;
  return $json;
}
sub AUTOLOAD {
	my $self = shift;
	my $type = ref($self) or warn "$self is not an object";

	my $name = $AUTOLOAD;
	$name =~ s/.*://;   # strip fully-qualified portion
	$name =~ s/^set_//; # strip set_
	$name =~ s/^get_//; # strip get_

	unless (exists $self->{'props'}->{$name} ) {
	  cluck "'$name' is not a valid property in class $type";
	  return undef;
	}

	if (@_) {
	  return $self->{'props'}->{"$name"} = shift;
	} else {
    return $self->{'props'}->{"$name"};
	}
}
sub DESTROY {  }












#
#
# GENERAL HELPERS
#
#
package main;
sub to_json {
  my ($data_structure, $name) = @_;

  my $tmp='';
  
  if ( defined($name) && $name ne '' ) {
  	$name =~ s/\"/\'/gi;
    $tmp.= "\n\"$name\" : ";
  }
  
  if ( ref $data_structure eq 'ARRAY' ) {
    $tmp.= "[";
    for (@$data_structure) {
      $tmp.= to_json($_,'');
    }
    $tmp =~ s/,$//g;
    $tmp.= "]";
  } elsif ( ref $data_structure eq 'HASH' ) {
    $tmp.= "{" if defined($name);
    for (keys %{$data_structure}) {
      $tmp.= to_json($data_structure->{$_}, $_ || '');
    }
    $tmp =~ s/,$//g;
    $tmp.= "}" if defined($name);
  
  } else {
  	
  	if ( !defined($data_structure) ) {
  		return;
  	}
  	
    if ( $data_structure =~ /^-{0,1}[\d.]+$/ ) {
      #number
      $tmp.= $data_structure;
    } else {
      #not number
      $data_structure =~ s/\"/\'/gi;
      $tmp.= "\"$data_structure\"";
    }
  } 
  
  return $tmp.',';
}

sub random_color {
  my @hex;
  for (my $i = 0; $i < 64; $i++) {
    my ($rand,$x);
    for ($x = 0; $x < 3; $x++) {
      $rand = rand(255);
      $hex[$x] = sprintf ("%x", $rand);
      if ($rand < 9) {
        $hex[$x] = "0" . $hex[$x];
      }
      if ($rand > 9 && $rand < 16) {
        $hex[$x] = "0" . $hex[$x];
      }
    }
  }
  return "\#" . $hex[0] . $hex[1] . $hex[2];
}

# URL-encode string
sub url_escape {
    my($toencode) = @_;
    $toencode=~s/([^a-zA-Z0-9_\-. ])/uc sprintf("%%%02x",ord($1))/eg;
    $toencode =~ tr/ /+/;    # spaces become pluses
    return $toencode;
}


# round the number up a bit to a nice round number
# also changes number to an int
sub smoother {
	my $number = shift;
	my $min_max = shift;
	my $n = $number;
	
	if ( $min_max eq 'max' ) {
		$n+=1;
	} else {
		$n-=1;
	}
  if ( $n <= 10 ) { $n = int($n) }
  elsif ( $n < 30 ) { $n = $n + (-$n % 5) }
 	elsif ( $n < 100 ) { $n = $n + (-$n % 10) }
 	elsif ( $n < 500 ) { $n = $n + (-$n % 50) }
 	elsif ( $n < 1000 ) { $n = $n + (-$n % 100) }
 	elsif ( $n < 10000 ) { $n = $n + (-$n % 200) }
 	else { $n = $n + (-$n % 500) }
  return int($n);
}
sub smooth_max {
	my $number = shift;
	return smoother($number, 'max');
}
sub smooth_min {
	my $number = shift;
	return smoother($number, 'min');
}

1;
