/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class MenuEvent extends Event { 
		
		public static const INSTRUCTIONS:String = "instructions";
		public static const LEADERBOARD:String = "leaderboard";
		public static const REGISTRATION:String = "registration";
		public static const GAME:String = "game";
		public static const PLAY_AGAIN:String = "playAgain";
		public static const LANGUAGE:String = "language";
		public static const TERMS:String = "terms";
		public static const FACEBOOK:String = "facebook";
		
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new MenuEvent(type, bubbles, cancelable);
		}
	}
}