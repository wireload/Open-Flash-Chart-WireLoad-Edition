/* */

package elements.labels {
	
	import flash.display.Sprite;
	import flash.display.Stage;
  import flash.text.TextField;
  import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import string.Css;
	import string.Utils;
	
	public class LegendLabel extends BaseLabel {
		public var data_colour:Number;
		public var data_size:Number = 7;
		public var data_padding:Number = 4;
		public var size:Number;
		private var top_padding:Number = 0;
		
		public function LegendLabel( style_string:Object, text:String, data_colour:Number)
		{
			super();
							
			// defaults:
			this.style = "font-size: 12px";
			this.text = text;
			this.data_colour = data_colour;
			
			object_helper.merge_2( { "style": style_string }, this );
			
			this.css = new Css(this.style);
			// Creates a child with the right text.
			this.build(this.text);
      var textField:TextField = this.getChildAt(0) as TextField;  
      var block_size:Number = textField.height;
      // Scoot the text out to make space for the colour block.
      textField.x = textField.x + block_size;
			this.draw_block(x+data_padding, textField.y+data_padding, block_size-2*data_padding, block_size-2*data_padding, this.data_colour);			
		}
		
		private function draw_block(x:Number, y:Number, width:Number, height:Number, colour:Number):void {
			this.graphics.beginFill(colour, 100);
			this.graphics.drawRect(x, y, width, height );
			this.graphics.endFill();
		}
		
		public override function get_width():Number {
		  return this.getChildAt(0).width + this.getChildAt(0).height;
		}
		
		public function get_height():Number {
			if ( this.text == null )
				return 0;
			else
				return this.css.padding_top+
					this.css.margin_top+
					this.getChildAt(0).height+
					this.css.padding_bottom+
					this.css.margin_bottom;
		}
	}
}