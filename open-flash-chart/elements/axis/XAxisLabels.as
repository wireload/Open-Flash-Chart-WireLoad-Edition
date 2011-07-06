package elements.axis {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import elements.axis.AxisLabel;
	import string.Utils;
	import com.serialization.json.JSON;
	import global.Global;
	
	public class XAxisLabels extends AxisLabelsBase {
		function XAxisLabels(json:Object) {		
		  super(json.x_axis);
		}
		
		//
		// we were not passed labels and need to make
		// them from the X Axis range
		//
		public function auto_label(range:Range, steps:Number):void {
			
			//
			// if the user has passed labels we don't do this
			//
			if ( this.need_labels ) {
				if ( this.style.visible ) {
					this.style.steps = steps;
					for( var i:Number = range.min; i <= range.max; i++ )
						this.add( NumberUtils.formatNumber( i ), this.style );
				}
			}
		}
		
		public function resize( sc:ScreenCoords, yPos:Number ) : void//, b:Box )
		{
			
			this.graphics.clear();
			var i:Number = 0;
			
			for( var pos:Number=0; pos < this.numChildren; pos++ )
			{
			/*
			var child:DisplayObject = this.getChildAt(pos);
				child.x = sc.get_x_tick_pos(pos) - (child.width / 2);
				child.y = yPos;
				
				if( this.style.rotate == 'vertical' )
					child.y += child.height;
				
				if( this.style.rotate == 'diag' )
					child.y += child.height;

			*/		
				var child:AxisLabel = this.getChildAt(pos) as AxisLabel;
				child.x = sc.get_x_tick_pos(pos) + child.xAdj;
				child.y = yPos + child.yAdj;
				//
				//if( this.style.vertical )
					//child.y += child.height;
				//
				//if( this.style.diag )
					//child.y += child.height;

//				i+=this.style.step;
			}
		}
		
		public function get_last_label(): AxisLabel {
		  if (this.numChildren == 0)
		    return null;
		  return this.getChildAt(this.numChildren -1) as AxisLabel;
		}
		
		//
		// to help Box calculate the correct width:
		//
		public function last_label_width() : Number
		{
			// is the last label shown?
//			if( ( (this.labels.length-1) % style.step ) != 0 )
//				return 0;
				
			// get the width of the right most label
			// because it may stick out past the end of the graph
			// and we don't want to truncate it.
//			return this.mcs[(this.mcs.length-1)]._width;
			if ( this.numChildren > 0 )
				return this.getChildAt(this.numChildren - 1).width;
			else
				return 0;
		}
		
		// see above comments
		public function first_label_width() : Number
		{
			if( this.numChildren>0 )
				return this.getChildAt(0).width;
			else
				return 0;
		}
	}
}
