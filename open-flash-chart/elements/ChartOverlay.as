package elements {
	import flash.display.*;
	import string.Utils;
	import com.serialization.json.JSON;
	
	public class ChartOverlay extends Sprite {
		private var style:Object;
		private var border_colour:Number;
		
		function ChartOverlay( json:Object )
		{
			// default values
			this.style = {
			  'border-colour': '#000000',
			  'border-stroke': 0,
			  'border-alpha': 1,
			  'border-roundness': 0
			};
			
			if( json != null )
				object_helper.merge_2( json, this.style );
						
			this.border_colour = Utils.get_colour(this.style['border-colour']);
		}

		public function resize( sc:ScreenCoords ):void
		{
			this.graphics.clear();

      this.graphics.lineStyle(this.style['border-stroke'], this.border_colour, this.style['border-alpha']);
      this.graphics.drawRoundRect(sc.left, sc.top, sc.width, sc.height, this.style['border-roundness']);
		}
	}
}
