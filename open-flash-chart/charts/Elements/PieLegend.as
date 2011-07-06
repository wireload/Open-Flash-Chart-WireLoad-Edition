package charts.Elements {
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import caurina.transitions.Equations;
	import flash.filters.DropShadowFilter;
	import elements.labels.LegendLabel;
  import global.Global;
  
	public class PieLegend extends Element {
	  private var values:Array;
	  private var colours:Array;
		private var border_colour:Number = 0;		
		private var border_width:Number = 1;
		
		public function PieLegend( values:Array, colours:Array, style_string:Object )
		{
		  this.values = values;
		  this.colours = colours;
		  	  
		  var y:Number = 0;
			for ( var i:Number = 0; i < values.length; i++ ) {
		    var legendLabel:LegendLabel = new LegendLabel(style_string, values[i].label, colours[i]);
		    legendLabel.y = y;
		    y += legendLabel.get_height();
		    this.addChild(legendLabel)
		  }
		}
		
		public function get_width():Number {
		  // YMO
		  // Flash calculates 'width' based on the child elements, the text fields.
		  // This code should be in LegendLabel.
		  return width + 15;
		}
	}
}
