/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	
	public class Intro extends MovieClip implements IAnimatable, ILanguageable {
		public var copy_01:MovieClip;
		public var copy_02:MovieClip;
		public var glasses:MovieClip;
		public var game:MovieClip;
		
		private var lang:String = LanguageEvent.EN;
		private var timelineMax:TimelineMax;
		
		public function Intro() {
			game.addEventListener(MouseEvent.CLICK, game_clickHandler);
			game.buttonMode = true;
		}
		
		public function animateIn():void {
			TweenMax.from(copy_01, 1, {delay:0.1, y:String(30), alpha:0, ease:Expo.easeInOut});
			TweenMax.from(copy_02, 1, {delay:0.2, y:String(30), alpha:0, ease:Expo.easeInOut});
			TweenMax.from(glasses, 1, {delay:0.3, y:String(30), alpha:0, ease:Expo.easeInOut});
			TweenMax.from(game, 1, {delay:0.3, y:String(30), alpha:0, ease:Expo.easeInOut});
		}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {}
		public function animateOut_completeHandler():void {}
		public function reset():void {}
		
		private function game_clickHandler(event:MouseEvent):void {
			dispatchEvent(new MenuEvent(MenuEvent.INSTRUCTIONS));
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				
				timelineMax.insertMultiple([
					TweenMax.to(copy_01, .25, {alpha:0}),
					TweenMax.to(copy_02, .25, {alpha:0}),
					TweenMax.to(game, .25, {alpha:0})
				]);
			}
			//for any dynamic components, before adding to stage, change their look before adding to stage.
		}
		
		public function layout_completeHandler():void {
			copy_01.play();
			copy_02.play();
			game.play();
			
			timelineMax.reverse();
		}
	}
}