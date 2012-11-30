/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.saad.IAnimatable;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.components.InertiaScroller;
	
	public class Terms extends MovieClip implements IAnimatable {
		
		private var timelineMax:TimelineMax;
		private var lang:String = LanguageEvent.EN;
		private var scrollerInstance:InertiaScroller = new InertiaScroller();
		
		
		public var close:MovieClip = new MovieClip();
		public var maskClip:MovieClip = new MovieClip();
		public var textClip:MovieClip = new MovieClip();
		public var scrollerUnit:MovieClip = new MovieClip();
		public var titleClip:MovieClip = new MovieClip();
		//public var scroller:MovieClip = new MovieClip();
		//public var scrollTrack:MovieClip = new MovieClip();
		
		public function Terms() {
			super();
			close.buttonMode = true;
			close.addEventListener(MouseEvent.CLICK, close_clickHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			textClip.y = 223.40;
			scrollerUnit.scroller.y = 0;
			scrollerInstance.Init(textClip ,maskClip , scrollerUnit.scroller, scrollerUnit.scrollTrack, this);
		}
		
		public function animateIn():void {
			textClip.y = 223.40;
			scrollerUnit.scroller.y = 0;
			TweenMax.from(this, .5, {y:String(200), alpha:0, ease:Expo.easeOut});
		}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {
			TweenMax.to(this, .3, {alpha:0, ease:Expo.easeOut, onComplete:animateOut_completeHandler});
		}
		public function animateOut_completeHandler():void {
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_OUT_COMPLETE));
		}
		public function reset():void {
			TweenMax.to(this, 0, {alpha:1});
		}
		
		private function close_clickHandler(event:MouseEvent):void {
			animateOut();
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				timelineMax.insertMultiple([
					TweenMax.to(textClip, .25, {alpha:0}),
					TweenMax.to(scrollerUnit, .25, {alpha:0}),
					TweenMax.to(titleClip, .25, {alpha:0}),
					TweenMax.to(close, .25, {alpha:0})
				]);
			}
			//for any dynamic components, before adding to stage, change their look before adding to stage.
		}
		
		public function layout_completeHandler():void {
			close.play();
			titleClip.play();
			textClip.play();
			scrollerUnit.play();
			resetScroller();
			timelineMax.reverse();
		}
		
		private function resetScroller():void
		{
			if(this.lang == LanguageEvent.EN)
			{
				scrollerUnit.x = 699
				maskClip.x = 98
				textClip.x = 99
			}
			if(this.lang == LanguageEvent.AR)
			{
				scrollerUnit.x = 91
				maskClip.x = 114
				textClip.x = 115
			}
			
		}
		
		
	}
}