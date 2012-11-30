/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Points;
	import view.events.LanguageEvent;
	
	public class PointsMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "PointsMediator";
		
		public function PointsMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
		}
		
		public function getPoints():Number {
			return points.getPoints();
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_SCORE,
				ApplicationFacade.SUBTRACT_SCORE,
				ApplicationFacade.RESET_CLOCK_POINTS,
				ApplicationFacade.TIME_OVER,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.ADD_SCORE:
					points.addScore(notification.getBody() as Number);
					break;
				case ApplicationFacade.SUBTRACT_SCORE:
					points.subtractScore(notification.getBody() as Number);
					break;
				case ApplicationFacade.RESET_CLOCK_POINTS:
					points.reset();
					break;
				case ApplicationFacade.TIME_OVER:
					points.gameOver();
					break;
				case ApplicationFacade.LANGUAGE:
					points.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get points():Points {
			return viewComponent as Points;
		}
	}
}