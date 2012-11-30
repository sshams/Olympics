/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class AnimationEvent extends Event {
		
		public static const ANIMATE_IN:String = "animateIn";
		public static const ANIMATE_IN_COMPLETE:String = "animateInComplete";
		public static const ANIMATION_OUT:String = "animationOut";
		public static const ANIMATION_OUT_COMPLETE:String = "animationOutComplete";
		
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new AnimationEvent(type, bubbles, cancelable);
		}
		
	}
}