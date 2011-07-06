package {

	import caurina.transitions.Tweener;
	import caurina.transitions.Equations;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import charts.Elements.Element;
	import com.serialization.json.JSON;
	import string.Utils;
	import string.Css;
	import object_helper;
	import global.Global;
	
	public class Tooltip extends Sprite {
		// JSON style:
		private var style:Object;
		
		private var tip_style:Number;
		private var tipped_elements:Array;
		private var active_tip_elements:Array;
		private var tip_showing:Boolean;
		
		public var tip_text:String;
		
		public static const CLOSEST:Number = 0;
		public static const PROXIMITY:Number = 1;
		public static const NORMAL:Number = 2;		// normal tooltip (ugh -- boring!!)
		
		public function Tooltip( json:Object )
		{
			//
			// we don't want mouseOver events for the
			// tooltip or any children (the text fields)
			//
			this.mouseEnabled = false;
			this.tip_showing = false;
			
			this.style = {
				shadow:		true,
				rounded:	1,
				stroke:		2,
				colour:		'#808080',
				background:	'#f0f0f0',
				title:		"color: #0000F0; font-weight: bold; font-size: 12;",
				body:		"color: #000000; font-weight: normal; font-size: 12;",
				mouse:		Tooltip.CLOSEST,
				text:		"_default"
			};

			if( json )
			{
				this.style = object_helper.merge( json, this.style );
			}

				
			this.style.colour = Utils.get_colour( this.style.colour );
			this.style.background = Utils.get_colour( this.style.background );
			this.style.title = new Css( this.style.title );
			this.style.body = new Css( this.style.body );
			
			this.tip_style = this.style.mouse;
			this.tip_text = this.style.text;
			this.tipped_elements = [];
			this.active_tip_elements = [];
			
			if( this.style.shadow==1 )
			{
				var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
				dropShadow.blurX = 4;
				dropShadow.blurY = 4;
				dropShadow.distance = 4;
				dropShadow.angle = 45;
				dropShadow.quality = 2;
				dropShadow.alpha = 0.5;
				// apply shadow filter
				this.filters = [dropShadow];
			}
		}
		
		public function make_tip( elements:Array ):void {
      // YMO Change: Only redo the tips when necessary. This reduces flickering on slow machines.
			var noChange:Boolean = true;
			if (elements.length != active_tip_elements.length) {
			  noChange = false;
			} else {
  			for (var i:Number = 0; i<elements.length; i++) {
  			  if (elements[i] != active_tip_elements[i]) {
  			    noChange = false;
  			    break;
  			  }
			  }
      }			
      if (noChange)
        return;
      active_tip_elements = elements;

			this.graphics.clear();
			
			while (this.numChildren > 0)
				this.removeChildAt(0);

			var height:Number = 0;
			var x:Number = 5;
			
			for each ( var e:Element in elements ) {				
				var o:Object = this.make_one_tip(e, x);
				height = Math.max(height, o.height);
				x += o.width + 2;
			}
			
			this.graphics.lineStyle(this.style.stroke, this.style.colour, 1);
			this.graphics.beginFill(this.style.background, 1);
		
			this.graphics.drawRoundRect(
				0,0,
				width+10, height + 5,
				6,6 );
		}
			
		private function make_one_tip( e:Element, x:Number ):Object {		
			var tt:String = e.get_tooltip();
			var lines:Array = tt.split( '<br>' );
			
			var top:Number = 5;
			var width:Number = 0;
			
			if (lines.length > 1) {
				
				var title:TextField = this.make_title(lines.shift());
				title.mouseEnabled = false;
				title.x = x;
				title.y = top;
				top += title.height;
				width = title.width;
				
				this.addChild(title);
			}
			
			var text:TextField = this.make_body(lines.join('\n'));
			text.mouseEnabled = false;
			text.x = x;
			text.y = top;
			width = Math.max( width, text.width );
			this.addChild( text );
			
			top += text.height;
			return { width:width, height:top };
		}

		private function make_title( text:String ):TextField {
			
			var title:TextField = new TextField();
			title.mouseEnabled = false;
			
			title.htmlText =  text;
			/*
			 * 
			 * Start thinking about just using html formatting 
			 * instead of text format below.  We could do away
			 * with the title textbox entirely and let the user
			 * use:
			 * <b>title stuff</b><br>Here is the value
			 * 
			 */
			var fmt:TextFormat = new TextFormat();
			fmt.color = this.style.title.color;
			fmt.font = "Verdana";
			fmt.bold = (this.style.title.font_weight=="bold");
			fmt.size = this.style.title.font_size;
			fmt.align = "right";
			title.setTextFormat(fmt);
			title.autoSize = "left";
			
			return title;
		}			
			
		private function make_body( body:String ):TextField {
			
			var text:TextField = new TextField();
			text.mouseEnabled = false;
			
			text.htmlText =  body;
			var fmt2:TextFormat = new TextFormat();
			fmt2.color = this.style.body.color;
			fmt2.font = "Verdana";
			fmt2.bold = (this.style.body.font_weight=="bold");
			fmt2.size = this.style.body.font_size;
			fmt2.align = "left";
			text.setTextFormat(fmt2);
			text.autoSize="left";
			
			return text;
		}
		
		private function get_pos( e:Element ):flash.geom.Point {

			var pos:Object = e.get_tip_pos();
			
			var x:Number = (pos.x + this.width + 16) > this.stage.stageWidth ? (this.stage.stageWidth - this.width - 16) : pos.x;
			
			var y:Number = pos.y;
			y -= 4;
			y -= (this.height + 10 ); // 10 == border size
			
			if( y < 0 )
			{
				// the tooltip has drifted off the top of the screen, move it down:
				y = 0;
			}
			return new flash.geom.Point(x, y);
		}
		
		private function show_tip( e:Element ):void {
			// remove the 'hide' tween
			Tweener.removeTweens( this );
			var p:flash.geom.Point = this.get_pos( e );
			
			if ( this.style.mouse == Tooltip.CLOSEST )
			{
				//
				// make the tooltip appear (if invisible)
				// and shoot to the correct position
				//
				this.visible = true;
				this.alpha = 1
				this.x = p.x;
				this.y = p.y;
			}
			else
			{
				// make the tooltip fade in gently
				this.tip_showing = true;
					
				CONFIG::debug { tr.ace('show'); }
				this.alpha = 0
				this.visible = true;
				this.x = p.x;
				this.y = p.y;
				Tweener.addTween(
					this,
					{
						alpha:1,
						time:0.4,
						transition:Equations.easeOutExpo
					} );
			}
		}
		
		public function draw( e:Element ):void {
			if ( this.tipped_elements[0] == e )
			{
				// if the tip is showing, don't make it 
				// show again because this makes it flicker
				if( !this.tip_showing )
					this.show_tip(e);
			}
			else
			{  
        set_tipped_elements([e]);
				this.make_tip( [e] );
				this.show_tip(e);
			}
		}
		
		public function closest( elements:Array ):void {
			if( elements.length == 0 )
				return;
			
			this.set_tipped_elements(elements);
			this.make_tip(elements);

			var p:flash.geom.Point = this.get_pos( elements[0] );
			
			this.visible = true;
			
			Tweener.addTween(this, { x:p.x, time:0.3, transition:Equations.easeOutExpo } );
			Tweener.addTween(this, { y:p.y, time:0.3, transition:Equations.easeOutExpo } );
		}
		
		/*
		Activate the 'tip' feature of each of the elements. Deactivate
		the tip feature of any element that used to be 'tipped'.
		*/
		private function set_tipped_elements(elements:Array): void {
		  var e:Element;
		  // Check for elements currently tipped but no longer intended to be.
		  for each(e in this.tipped_elements) {
		    if (elements.indexOf(e) == -1) {
		      e.set_tip(false);
	      }
		  }
      
      // Ensure all elements that should be tipped are.
		  this.tipped_elements = elements;
		  for each(e in this.tipped_elements) {
	      e.set_tip(true);
		  }
		} 
				
		private function hideAway() : void {
			this.visible = false;
			this.set_tipped_elements(new Array());
			this.alpha = 1;
		}
		
		public function hide():void {		
			this.tip_showing = false;
			CONFIG::debug { tr.ace('hide tooltip'); }
			
			Tweener.addTween(this, { alpha:0, time:0.6, transition:Equations.easeOutExpo, onComplete:hideAway } );
		}
		
		public function get_tip_style():Number {
			return this.tip_style;
		}

		public function set_tip_style( i:Number ):void {
			this.tip_style = i;
		}
		
		public function die():void {
			
			this.filters = [];
			this.graphics.clear();
			
			while( this.numChildren > 0 )
				this.removeChildAt(0);
		
			this.style = null;
			this.tipped_elements = null;
		}
	}
}