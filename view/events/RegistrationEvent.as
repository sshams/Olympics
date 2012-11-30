/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.events {
	import flash.events.Event;
	
	import model.valueObjects.RegistrationVO;
	
	public class RegistrationEvent extends Event {
		
		public static const REGISTRATION:String = "registration";
		
		public var registrationVO:RegistrationVO;
		
		public function RegistrationEvent(type:String, registrationVO:RegistrationVO=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.registrationVO = registrationVO;
		}
		
		override public function clone():Event {
			return new RegistrationEvent(type, registrationVO, bubbles, cancelable);
		}
	}
}