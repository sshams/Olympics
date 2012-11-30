/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class ClockEvent extends Event {
		
		public static const ADD_TIME:String = "addTime";
		public static const TIME_OVER:String = "timeOver";
		
		public function ClockEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ClockEvent(type, bubbles, cancelable);
		}
		
	}
}