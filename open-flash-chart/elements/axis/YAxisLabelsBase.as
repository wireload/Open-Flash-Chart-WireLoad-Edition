package elements.axis {
	import flash.display.Sprite;
	import elements.axis.AxisLabel;
	import flash.text.TextFormat;
	//import org.flashdevelop.utils.FlashConnect;
	import br.com.stimuli.string.printf;
	import global.Global;
	
	public class YAxisLabelsBase extends Sprite {
		private var steps:Number;
		private var right:Boolean;
		protected var rotate:String;
  	private var style:Object;
		
		public function YAxisLabelsBase( values:Array, steps:Number, json:Object, name:String, style_name:String ) {
			this.steps = steps;
      
			this.style = {
				rotate:		0,
				visible:	true,
				labels:		null,
				steps:		1,
				size:		10,
				colour:		'#000000',
				style: 'font-size: 12px; color: #000;'
			};
			
			if( ( json.y_axis != null ) && ( json.y_axis.labels != null ) )
				object_helper.merge_2( json.y_axis.labels, this.style );
			
			// are the Y Labels visible?
			if( !style.visible )
				return;
				
			if( json.y_axis && json.y_axis.rotate )
				this.rotate = json.y_axis.rotate;
  		if (rotate == "vertical")
  			style.rotate = 270;
				
			// labels
			var pos:Number = 0;
			
			for each ( var v:Object in values )
			{
				var tmp:AxisLabel = this.make_label( v.val, style, style.style );
				tmp.yVal = v.pos;
				this.addChild(tmp);
				
				pos++;
			}
		}

		//
		// use Y Min, Y Max and Y Steps to create an array of
		// Y labels:
		//
		protected function make_labels( min:Number, max:Number, right:Boolean, steps:Number ):Array {
			var values:Array = [];
			
			var min_:Number = Math.min( min, max );
			var max_:Number = Math.max( min, max );
			
			// hack: hack: http://kb.adobe.com/selfservice/viewContent.do?externalId=tn_13989&sliceId=1
			max_ += 0.000004;
			
			var eek:Number = 0;
			for( var i:Number = min_; i <= max_; i+=steps ) {
				
				values.push( { val:printf('%.3f',i), pos:i } );
				
				// make sure we don't generate too many labels:
				if( eek++ > 250 ) break;
			}
			return values;
		}
		
		private function make_label(text:String, label_style:Object, css_style:Object):AxisLabel
		{
			// does _root already have this textFiled defined?
			// this happens when we do an AJAX reload()
			// these have to be deleted by hand or else flash goes wonky.
			// In an ideal world we would put this code in the object
			// distructor method, but I don't think actionscript has these :-(

			var tf:AxisLabel = new AxisLabel(css_style);
			//tf.border = true;
			
			tf.textField.text = text;
			
      tf.rotate_and_align(label_style.rotate, this);

			return tf;
		}

		// move y axis labels to the correct x pos
		public function resize( left:Number, sc:ScreenCoords ):void
		{
		}


		public function get_width():Number{
			var max:Number = 0;
			for( var i:Number=0; i<this.numChildren; i++ )
			{
				var tf:AxisLabel = this.getChildAt(i) as AxisLabel;
				max = Math.max( max, tf.width );
			}
			return max;
		}
		
		public function die(): void {
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}