/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class LeaderboardEvent extends Event {
		
		public static const LEADERBOARD:String = "leaderbaord";
		
		public function LeaderboardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new LeaderboardEvent(type, bubbles, cancelable);
		}
	}
}