package {
  import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Sprite;
	  
	/**
	A simple spinner that remains lightweight by avoiding non Flash
	dependencies. It's meant to look like the classical indicator
	icon but use fewer bytes than the gif version.
	*/
  public class Spinner extends Sprite {
    private var refreshTimer:Timer;
    protected static var TICKS:int = 12;
    protected static var SIZE:Number = 32;
    public static var THICKNESS:Number = 3;
    protected static var TICK_SPEED:Number = 70;
		
    public function Spinner() {
      init();
    }
    
    protected function init():void {
      var innerRadius:Number = SIZE / 3.5;
      var outerRadius:Number = SIZE / 2;
      var angle:Number = 2 * Math.PI / TICKS;
      
      for (var i:int = 0; i < TICKS; i++) {
        addChild(new SpinnerTick(i*angle, innerRadius, outerRadius));
      }
		  setAlphas(0);

  		refreshTimer = new Timer(TICK_SPEED, 0);
  		refreshTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
  		  setAlphas(refreshTimer.currentCount);
  		});
  		refreshTimer.start();
    }

    private function setAlphas(tickNum:int):void {
      for(var i:int = 0; i<TICKS; i++) {
				var tick:SpinnerTick = getChildAt(i) as SpinnerTick;
        tick.alpha = ((TICKS-i + tickNum) % TICKS) / TICKS;
      }      
    }
  }
}
