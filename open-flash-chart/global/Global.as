package global {
	
	import elements.axis.AxisLabel;
	import elements.labels.XLegend;
	import elements.axis.XAxisLabels;
	import com.dannypatterson.logging.FirebugTarget;
  import mx.logging.ILogger;
  import mx.logging.Log;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
	import flash.text.TextField;
	import mx.utils.ObjectUtil;
	
	public class Global {
		private static var instance:Global = null;
		private static var allowInstantiation:Boolean = false;
		
		public var x_labels:XAxisLabels;
		public var x_legend:XLegend;
		private var tooltip:String;
  	CONFIG::debug {
  	  /**
  	  A Firebug logger. Use like this:
  	  CONFIG::debug { Global.getInstance().logger.info("Hello"); }
      */
		  public var logger:ILogger;
		}
		
		public function Global() {
	  	CONFIG::debug {
  		  logger = Log.getLogger("myLogger");
        var logTarget:FirebugTarget = new FirebugTarget();
        logTarget.addLogger(logger);
      }
		}
		
		public static function getInstance() : Global {
			if ( Global.instance == null ) {
				Global.allowInstantiation = true;
				Global.instance = new Global();
				Global.allowInstantiation = false;
			}
			return Global.instance;
		}

    /**
    A function that logs objects by creating a textual representation.
    */
    CONFIG::debug
    public static function trace(title:String, anything:Object):void {
      getInstance().logger.info(title + ObjectUtil.toString(anything));
    }
		
		/**
		Create a bitmap containing an image of the given text rotated as 
		the text should have been. This method works even if the font of
		the text has not been embedded.
		*/
		public static function create_rotated_copy(text:TextField):Bitmap {
		  var originalRotation:Number = text.rotation;
		  // Remove the original text rotation so we can make a straight copy.
		  text.rotation = 0;
		  var bmp:BitmapData = new BitmapData(text.width, text.height, false);
      bmp.draw(text);
      var smooth:Boolean = originalRotation % 90 == 0 ? false : true; 
      var copy:Bitmap = new Bitmap(bmp, "auto", smooth);
      copy.rotation = originalRotation;

      text.rotation = originalRotation;
      return copy;
		}
		
		public function get_x_label( pos:Number ):String {
			
			// PIE charts don't have X Labels
			
			CONFIG::debug { tr.ace('xxx'); }
			CONFIG::debug { tr.ace( this.x_labels == null ) }
			CONFIG::debug { tr.ace(pos); }
//			tr.ace( this.x_labels.get(pos))
			
			
			if ( this.x_labels == null )
				return null;
			else
				return this.x_labels.get(pos);
		}
		
		public function get_x_legend(): String {
			
			// PIE charts don't have X Legend
			if( this.x_legend == null )
				return null;
			else
				return this.x_legend.text;
		}
		
		public function set_tooltip_string( s:String ):void {
			CONFIG::debug { tr.ace('@@@@@@@'); }
			CONFIG::debug { tr.ace(s); }
			this.tooltip = s;
		}
		
		public function get_tooltip_string():String {
			return this.tooltip;
		}
	}
}