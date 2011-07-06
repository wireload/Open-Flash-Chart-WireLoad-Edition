package {
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.utils.getDefinitionByName;
 	import flash.display.LoaderInfo;
 	
 	import Spinner;

  /**
  Preloader roughly based on Keith Peters work at http://www.bit-101.com/blog/?p=946.
  */
  public class PreloaderFactory extends MovieClip {
    private var spinner:Spinner = null;
    
    public function PreloaderFactory() {
      stop();
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      spinner = new Spinner();
      spinner.x = stage.stageWidth / 2.0 - spinner.width / 2.0;
      spinner.y = stage.stageHeight / 2.0 - spinner.height / 2.0;
      addChild(spinner);
    }
 
    public function onEnterFrame(event:Event):void {
      if (framesLoaded == totalFrames) {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        nextFrame();
        init();
        removeChild(spinner);
      }
    }
 
    private function init():void {
      var mainClass:Class = Class(getDefinitionByName("Main"));
      if(mainClass) {
        var app:Object = new mainClass(LoaderInfo(this.loaderInfo).parameters);
        addChild(app as DisplayObject);
      }
    }
  }
}
