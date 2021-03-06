package charts {
	import charts.Elements.Element;
	import charts.Elements.PointBarGlass;
	import string.Utils;
	import global.Global;
	
	public class BarGlass extends BarBase {	
		public function BarGlass( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			if (value == null)
			  throw new Error("null value");
			
			var default_style:Object = {
					colour:		this.style.colour,
					tip:		this.style.tip
			};
					
			if( value is Number )
				default_style.top = value;
			else
				object_helper.merge_2( value, default_style );
			
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
				
			return new PointBarGlass(index, default_style, this.group);
		}
	}
}