/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events.facebook {
	import flash.events.Event;
	
	public class MeEvent extends Event {
		
		public static const ME:String = "me";
		
		public function MeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new MeEvent(type, bubbles, cancelable);
		}
	}
}