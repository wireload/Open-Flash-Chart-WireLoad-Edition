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
	
	public class AxisLabelsBase extends Sprite {	
		public var need_labels:Boolean;
		public var axis_labels:Array = [];
		internal var style:Object;
		
		function AxisLabelsBase(axisJson:Object) {
			this.need_labels = true;
			
			this.style = {
				rotate:		0,
				visible:	true,
				labels:		null,
				steps:		1,
				size:		10,
				colour:		'#000000',
				style:  'font-size: 12px; color: #000000;'
			};
						
			if (axisJson != null && axisJson.labels != null)
				object_helper.merge_2(axisJson.labels, this.style);
			
			// Interpret special rotation keywords.
			if ( this.style.rotate is String ) {
				if (this.style.rotate == "vertical") {
					this.style.rotate = 270;
				} else if (this.style.rotate == "diagonal") {
					this.style.rotate = -45;
				}
			}
			
			this.style.colour = Utils.get_colour(this.style.colour);
			
			if (this.style.labels is Array && this.style.labels.length > 0) {
				this.need_labels = false;
				
				for each(var s:Object in this.style.labels)
					this.add(s, this.style);
			}
			
		}

		public function add(label:Object, style:Object):void {		
			var label_style:Object = {
				colour:		style.colour,
				text:		'',
				rotate:		style.rotate,
				size:		style.size,
				colour:		style.colour
			};
			
			//
			// inherit some properties from
			// our parents 'globals'
			//
			if (label is String)
				label_style.text = label as String;
			else
				object_helper.merge_2( label, label_style );
			
			// our parent colour is a number, but
			// we may have our own colour:
			if (label_style.colour is String)
				label_style.colour = Utils.get_colour(label_style.colour);
			
			this.axis_labels.push( label_style.text );

			if (label_style.visible == null) {
				//
				// some labels will be invisible due to our parents step value
				//
				if ( ( (this.axis_labels.length - 1) % style.steps ) == 0 )
					label_style.visible = true;
				else
					label_style.visible = false;
			}
			
			var l:AxisLabel = this.make_label(label_style, style.style);
			
			// YMO Change: Enable text rotation without font embedding.
			this.addChild(l);
  	}
		
		public function get( i:Number ): String {
			if( i<this.axis_labels.length )
				return this.axis_labels[i];
			else
				return '';
		}
		
		public function make_label(label_style:Object, css_style:Object):AxisLabel {
			var title:AxisLabel = new AxisLabel(css_style);
      title.x = 0;
			title.y = 0;
			
			title.textField.text = label_style.text;
			title.rotate_and_align(label_style.rotate, this);
			
			title.visible = label_style.visible;
			
			return title;
		}
		
		
		public function count(): Number {
			return this.axis_labels.length;
		}
		
		public function get_height(): Number {
			var height:Number = 0;
			for( var pos:Number=0; pos < this.numChildren; pos++ ) {
				var child:DisplayObject = this.getChildAt(pos);
				height = Math.max( height, child.height );
			}
			
			return height;
		}
		
		public function get_width(): Number {
			var width:Number = 0;
			for (var pos:Number=0; pos < this.numChildren; pos++) {
				var child:DisplayObject = this.getChildAt(pos);
				width = Math.max(width, child.x + child.width);
			}
			
			return width;
		}
		
		public function die(): void {		
			this.axis_labels = null;
			this.style = null;
			this.graphics.clear();
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}
