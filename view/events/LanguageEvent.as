/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class LanguageEvent extends Event { 
		
		public static const EN:String = "en";
		public static const AR:String = "ar";
		
		public function LanguageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new LanguageEvent(type, bubbles, cancelable);
		}
	}
}