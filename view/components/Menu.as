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
	
	public class Menu extends MovieClip implements IAnimatable, ILanguageable {
		
		public var instructions:MovieClip;
		public var leaderboard:MovieClip;
		public var language:MovieClip;
		public var terms:MovieClip;
		
		private var lang:String = LanguageEvent.EN;
		private var timelineMax:TimelineMax;
		
		public function Menu() {
			instructions.buttonMode = leaderboard.buttonMode = language.buttonMode = terms.buttonMode = true;
			instructions.addEventListener(MouseEvent.CLICK, instructions_clickHandler);
			leaderboard.addEventListener(MouseEvent.CLICK, leaderboard_clickHandler);
			language.addEventListener(MouseEvent.CLICK, language_clickHandler);
			terms.addEventListener(MouseEvent.CLICK, terms_clickHandler);
		}
		
		public function animateIn():void { 
			TweenMax.from(instructions, 1, {delay:0.5, y:String(30), alpha:0, ease:Expo.easeInOut});
			TweenMax.from(leaderboard, 1, {delay:0.6, y:String(30), alpha:0, ease:Expo.easeInOut});
			TweenMax.from(language,1, {delay:0.7, y:String(30), alpha:0, ease:Expo.easeInOut});
			TweenMax.from(terms, 1, {delay:0.8, y:String(30), alpha:0, ease:Expo.easeInOut});
		}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {}
		public function animateOut_completeHandler():void {}
		public function reset():void {}
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				
				timelineMax.insertMultiple([
					TweenMax.to(instructions, .25, {y:String(25)}),
					TweenMax.to(leaderboard, .25, {y:String(25)}),
					TweenMax.to(language, .25, {y:String(25)}),
					TweenMax.to(terms, .25, {y:String(25)})
				]);
			}
		}
		
		public function layout_completeHandler():void {
			instructions.play();
			leaderboard.play();
			language.play();
			terms.play();
			
			timelineMax.reverse();
		}
		
		private function instructions_clickHandler(event:MouseEvent):void {
			dispatchEvent(new MenuEvent(MenuEvent.INSTRUCTIONS));
		}
		private function leaderboard_clickHandler(event:MouseEvent):void {
			dispatchEvent(new MenuEvent(MenuEvent.LEADERBOARD));
		}
		private function language_clickHandler(event:MouseEvent):void {
			if(lang == LanguageEvent.EN) {
				dispatchEvent(new LanguageEvent(LanguageEvent.AR));
			} else {
				dispatchEvent(new LanguageEvent(LanguageEvent.EN));
			}
		}
		private function terms_clickHandler(event:MouseEvent):void {
			dispatchEvent(new MenuEvent(MenuEvent.TERMS));
		}
	}
}