/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	public class PowerEvent extends Event {
		
		public static const POWER:String = "power";
		public var power:int;
		
		public function PowerEvent(type:String, power:int, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.power = power;
		}
		
		override public function clone():Event {
			return new PowerEvent(type, this.power, bubbles, cancelable);
		}
	}
}