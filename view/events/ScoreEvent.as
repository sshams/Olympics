/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class ScoreEvent extends Event {
		
		public static const ADD_SCORE:String = "addScore";
		public static const SUBTRACT_SCORE:String = "subtractScore";
		public var points:int;
		
		public function ScoreEvent(type:String, points:int=0, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.points = points;
		}
		
		override public function clone():Event {
			return new ScoreEvent(type, this.points, bubbles, cancelable);
		}
	}
}