package elements.labels {
	//import org.flashdevelop.utils.FlashConnect;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.*;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import string.Utils;
	import string.Css;
	import flash.display.*;
  import global.Global;


	public class YLegendBase extends Sprite {
		
		public var tf:TextField;
		
		public var text:String;
		public var style:String;
		private var css:Css;
		
//		[Embed(source = "C:\\Windows\\Fonts\\Verdana.ttf", fontFamily = "foo", fontName = '_Verdana')]
//		private static var EMBEDDED_FONT:String;
		
//		[Embed(systemFont='Arial', fontName='spArial', mimeType='application/x-font')]
//		public static var ArialFont:Class;
		
		CONFIG::enable_embed_arial {
  		[Embed(systemFont='Arial', fontName='spArial', mimeType='application/x-font')]
  		public static var ArialFont:Class;		  
		}
		
		public function YLegendBase( json:Object, name:String )
		{

			if( json[name+'_legend'] == undefined )
				return;
				
			if( json[name+'_legend'] )
			{
				object_helper.merge_2( json[name+'_legend'], this );
			}
			
			this.css = new Css( this.style );
			
			this.build( this.text );
		}
		
		private function build( text:String ): void {
			var title:TextField = new TextField();
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = this.css.color;
			fmt.font = this.css.font_family?this.css.font_family:'Verdana';
			//fmt.font = "spArial";
			fmt.size = this.css.font_size;
			fmt.align = "center";
			
			title.htmlText = text;
			title.setTextFormat(fmt);
			title.autoSize = "left";
			//title.embedFonts = true;
			title.rotation = 270;
			title.height = title.textHeight;
			title.antiAliasType = AntiAliasType.ADVANCED;
			title.autoSize = TextFieldAutoSize.LEFT;

			title.x = 0;
			title.y = 0;

      // YMO Change: Enable text rotation without font embedding.
			this.addChild(Global.create_rotated_copy(title));
		}
		
		public function resize():void {
			if ( this.text == null )
				return;
		}
		
		public function get_width(): Number {
			if( this.numChildren == 0 )
				return 0;
			else
				return this.getChildAt(0).width;
		}
		
		public function die(): void {
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}