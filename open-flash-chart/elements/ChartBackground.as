package elements {
	import flash.display.*;
	import flash.geom.*;
	import string.Utils;
	import com.serialization.json.JSON;
	
	public class ChartBackground extends Sprite {
		private var style:Object;
		private var top_colour:Number;
		private var bottom_colour:Number;
		
		function ChartBackground( json:Object )
		{
			// default values
			this.style = {
			  'top-colour': '#FFFFFF',
			  'bottom-colour': '#FFFFFF',
			  'corner-roundness': 0
			};
			
			if( json != null )
				object_helper.merge_2( json, this.style );
						
			this.top_colour = Utils.get_colour( this.style['top-colour'] );
			this.bottom_colour = Utils.get_colour( this.style['bottom-colour'] );
		}

		public function resize( sc:ScreenCoords ):void
		{
			this.graphics.clear();

      this.graphics.lineStyle(0, 0, 0);
      var matr:Matrix = new Matrix();
      matr.createGradientBox(sc.width, sc.height, Math.PI / 2, 0, 0);
      this.graphics.beginGradientFill(GradientType.LINEAR, [top_colour, bottom_colour], [1, 1], [0x00, 0xFF], matr);
      this.graphics.drawRoundRect(sc.left, sc.top, sc.width, sc.height, this.style['corner-roundness']);
      this.graphics.endFill()
		}
	}
}
