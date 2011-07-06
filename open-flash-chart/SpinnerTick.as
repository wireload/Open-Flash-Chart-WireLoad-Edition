package {
	import flash.display.Sprite;
	
	public class SpinnerTick extends Sprite {
		public function SpinnerTick(angle:Number, innerRadius:Number, outerRadius:Number) {
			this.graphics.lineStyle(Spinner.THICKNESS, 0, 1.0, false, "normal", "rounded");

		  var x:Number = outerRadius + innerRadius * Math.cos(angle);
		  var y:Number = outerRadius + innerRadius * Math.sin(angle);
			this.graphics.moveTo(x, y);
		  x = outerRadius + outerRadius * Math.cos(angle);
		  y = outerRadius + outerRadius * Math.sin(angle);
			this.graphics.lineTo(x, y);
		}
	}
}