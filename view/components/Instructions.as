/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	
	public class Instructions extends MovieClip implements IAnimatable, ILanguageable {
		
		public var close:MovieClip;
		public var ready:MovieClip;
		public var instructionClip:MovieClip;
		
		private var timelineMax:TimelineMax;
		private var lang:String = LanguageEvent.EN;
		
		public function Instructions() {
			super();
			close.addEventListener(MouseEvent.CLICK, close_clickHandler);
			close.buttonMode = true;
			
			ready.buttonMode = true;
			ready.addEventListener(MouseEvent.MOUSE_UP, ready_mouseUpHandler);
		}
		
		private function ready_mouseUpHandler(event:MouseEvent):void {
			dispatchEvent(new MenuEvent(MenuEvent.FACEBOOK));
		}
		
		public function animateIn():void {
			TweenMax.from(this, .5, {y:String(200), alpha:0, ease:Expo.easeOut});
		}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {
			TweenMax.to(this, .1, {alpha:0, ease:Expo.easeOut, onComplete:animateOut_completeHandler});
		}
		public function animateOut_completeHandler():void {
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_OUT_COMPLETE));
		}

		public function reset():void {
			TweenMax.to(this, 0, {alpha:1});
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				timelineMax.insertMultiple([
					TweenMax.to(instructionClip, .25, {alpha:0}),
					TweenMax.to(ready, .25, {alpha:0}),
					TweenMax.to(close, .25, {alpha:0})
				]);
			}
			
		}

		public function layout_completeHandler():void {
			ready.play();
			close.play();
			instructionClip.play();
			timelineMax.reverse();
		}
		
		private function close_clickHandler(event:MouseEvent):void {
			animateOut();
		}
	}
}