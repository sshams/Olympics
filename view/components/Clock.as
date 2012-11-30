/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components
{
	import com.greensock.TweenMax;
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import view.events.ClockEvent;
	import view.events.LanguageEvent;

	public class Clock extends MovieClip implements IAnimatable, ILanguageable {
		private static var clockCountdown:Number = 60;
		private static var BonusTimeCounter:Number = 0;
		private static var userGameTime:Number = 0;
		
		private var gameTimer:Timer = new Timer(1000);
		private var userTime:Timer = new Timer(1000);
		public var timerText:TextField;

		public function Clock() {
			timerText.autoSize = TextFieldAutoSize.CENTER;
			timerText.text = String(":"+clockCountdown);
		}
		
		public function getRounds():Number {
			return BonusTimeCounter;
		}
		
		public function getTime():Number { 
			return userGameTime;
		}
		
		public function start():void {
			gameTimer.repeatCount = clockCountdown;
			gameTimer.delay = 1000;
			gameTimer.addEventListener(TimerEvent.TIMER, countdown);
			userTime.addEventListener(TimerEvent.TIMER, userGameTimeListener);
			gameTimer.start();
			userTime.start();
		}

		private function countdown(event:TimerEvent) {
			//trace(event.currentTarget.repeatCount,"  --  ", event.currentTarget.currentCount);
			
			var totalSecondsLeft:Number = event.currentTarget.repeatCount - event.currentTarget.currentCount;
			timerText.autoSize = TextFieldAutoSize.CENTER;
			timerText.text = timeFormat(totalSecondsLeft);
			if(totalSecondsLeft == 0) {
				dispatchEvent(new ClockEvent(ClockEvent.TIME_OVER));
				stopClock();
			}
				
		}
		
		public function stopClock():void {
			//trace("Stop Clock -----  ");
			gameTimer.reset();
			gameTimer.stop();
			gameTimer.removeEventListener(TimerEvent.TIMER, countdown);
			
			userTime.reset();
			userTime.stop();
			userTime.removeEventListener(TimerEvent.TIMER, userGameTimeListener);
		}
		
		private function userGameTimeListener(e:TimerEvent):void {
			userGameTime++;
		}


		private function timeFormat(seconds:int):String {
			var minutes:int;
			var sMinutes:String;
			var sSeconds:String;
			if (seconds > 59) {
				minutes = Math.floor(seconds / 60);
				sMinutes = String(minutes);
				sSeconds = String(seconds % 60);
			} else {
				sMinutes = "";
				sSeconds = String(seconds);
			}
			if (sSeconds.length == 1) {
				sSeconds = "0" + sSeconds;
			}
			return sMinutes + ":" + sSeconds;
		}

		public function updateBonusTime():void {
			gameTimer.repeatCount = gameTimer.repeatCount + 5;
			BonusTimeCounter++;
		}

		public function animateIn():void {}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {}
		public function animateOut_completeHandler():void {}
		
		public function reset():void  {
			//trace("reset called ");
			clockCountdown = 60;
			timerText.text = String(":"+clockCountdown);
		}
		
		public function layout(event:LanguageEvent):void {
		}
		
		public function layout_completeHandler():void {}

	}
}