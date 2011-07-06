/* */

package elements.axis {
	
	import flash.display.Sprite;
  import flash.text.TextField;
	import flash.geom.Rectangle;
	import global.Global;
	import elements.labels.BaseLabel;
	import string.Css;
	import string.Utils;
		
	public class AxisLabel extends BaseLabel {
		public var xAdj:Number = 0;
		public var yAdj:Number = 0;
		public var leftOverhang:Number = 0;
		public var rightOverhang:Number = 0;
		public var xVal:Number = NaN;
		public var yVal:Number = NaN;
		public var textField:TextField;
				
		public function AxisLabel(style_string:Object)	{
		  super();
		  textField = new TextField();

			// defaults:
			this.style = "font-size: 12px;";
			
		  object_helper.merge_2( { "style": style_string }, this );
			
			this.css = new Css(this.style);
		}
		
		/**
		 * Rotate the label and align it to the X Axis tick
		 * 
		 * @param	rotation
		 */

		public function rotate_and_align( rotation:Number, parent:Sprite ): void
		{
			this.textField.rotation = rotation;
			
			// Remove any previously rotated bitmap.
			while (this.numChildren > 0)
				this.removeChildAt(0);
			this.build_from_field(textField);
			
			var titleRect:Rectangle = this.getBounds(parent);
			var tempRect:Rectangle;

			if (this.textField.rotation == 0)
			{
				this.xAdj = - titleRect.width / 2;
				///yAdj += 0;
			} 
			else if (this.textField.rotation == -90) 
			{
				this.xAdj = - titleRect.width / 2;
				this.yAdj = titleRect.height;
			} 
			else if (this.textField.rotation == 90) 
			{
				this.xAdj = titleRect.width / 2;
				//yAdj += 0;
			} 
			else if (Math.abs(this.textField.rotation) == 180) 
			{
				this.xAdj = titleRect.width / 2;
				this.yAdj = titleRect.height;
			} 
			else if (this.textField.rotation < -90) //-90
			{
				// temporarily change rotation to easily determine x adjustment
				this.textField.rotation += 180;
				tempRect = this.textField.getBounds(parent);
				this.textField.rotation -= 180;

				this.xAdj = titleRect.width + ((3 * tempRect.x) / 2);
				this.yAdj = -titleRect.y;
			} 
			else if (this.textField.rotation < 0) 
			{
				// temporarily change rotation to easily determine x adjustment
				this.textField.rotation += 90;
				tempRect = this.textField.getBounds(parent);
				this.textField.rotation -= 90;

				this.xAdj = -titleRect.width - (tempRect.x / 2);
				this.yAdj = -titleRect.y;
			} 
			else if (this.textField.rotation < 90) 
			{
				this.xAdj = -titleRect.x / 2;
				this.yAdj = -titleRect.y;
			} 
			else 
			{
				// temporarily change rotation to easily determine x adjustment
				this.textField.rotation -= 90;
				tempRect = this.textField.getBounds(parent);
				this.textField.rotation += 90;

				this.xAdj = -tempRect.x / 2;
				this.yAdj = -titleRect.y;
			}
			
			this.leftOverhang = Math.abs(titleRect.x + this.xAdj);
			this.rightOverhang = Math.abs(titleRect.x + titleRect.width + this.xAdj);
		}
	}
}