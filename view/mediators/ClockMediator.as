/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Clock;
	import view.events.ClockEvent;
	import view.events.GameEvent;
	import view.events.LanguageEvent;
	
	public class ClockMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "ClockMediator";
		
		public function ClockMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			clock.addEventListener(ClockEvent.TIME_OVER, clock_timeOverHandler);
		}
		
		private function clock_timeOverHandler(event:ClockEvent):void {
			facade.sendNotification(ApplicationFacade.TIME_OVER);
			facade.sendNotification(ApplicationFacade.INSERT_SCORE);
		}
		
		public function getTime():Number {
			return clock.getTime();
		}
		
		public function getRounds():Number {
			return clock.getRounds();
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.START_CLOCK,
				ApplicationFacade.RESET_CLOCK_POINTS,
				ApplicationFacade.ADD_TIME,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.START_CLOCK:
					clock.start();
					break;
				case ApplicationFacade.RESET_CLOCK_POINTS:
					clock.reset();
					clock.stopClock();
					break;
				case ApplicationFacade.ADD_TIME:
					clock.updateBonusTime();
					break;
				case ApplicationFacade.LANGUAGE:
					clock.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get clock():Clock {
			return viewComponent as Clock;
		}
	}
}