/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	
	public class Language extends MovieClip implements IAnimatable, ILanguageable {
		
		public var english:MovieClip;
		public var arabic:MovieClip;
		
		public function Language() {
			english.buttonMode = arabic.buttonMode = true;
			english.addEventListener(MouseEvent.CLICK, english_clickHandler);
			arabic.addEventListener(MouseEvent.CLICK, arabic_clickHandler);
		}
		
		private function english_clickHandler(event:MouseEvent):void {
			dispatchEvent(new LanguageEvent(LanguageEvent.EN));
		}
		
		private function arabic_clickHandler(event:MouseEvent):void {
			dispatchEvent(new LanguageEvent(LanguageEvent.AR));
		}
		
		public function animateIn():void {
		}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {
			TweenMax.to(this, 1, {alpha:0, ease:Cubic.easeInOut, onComplete:animateOut_completeHandler});
		}
		public function animateOut_completeHandler():void {
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_OUT_COMPLETE));
		}
		public function reset():void {
			TweenMax.to(this, 0, {alpha:1});
		}
		
		public function layout(event:LanguageEvent):void {
		}
		
		public function layout_completeHandler():void {}
		
	}
}