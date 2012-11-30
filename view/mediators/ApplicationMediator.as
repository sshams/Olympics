/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import com.saad.IAnimatable;
	
	import flash.system.ApplicationDomain;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.events.LanguageEvent;
	
	public class ApplicationMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_GAME,
				ApplicationFacade.REMOVE_GAME,
				ApplicationFacade.ADD_INSTRUCTIONS,
				ApplicationFacade.REMOVE_INSTRUCTIONS,
				ApplicationFacade.ADD_LEADERBOARD,
				ApplicationFacade.REMOVE_LEADERBOARD,
				ApplicationFacade.ADD_REGISTRATION,
				ApplicationFacade.REMOVE_REGISTRATION,
				ApplicationFacade.ADD_TERMS,
				ApplicationFacade.REMOVE_TERMS,
				ApplicationFacade.REMOVE_COMPONENT,
				ApplicationFacade.LANGUAGE,
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.ADD_INSTRUCTIONS:
					app.addInstructions();
					break;
				
				case ApplicationFacade.REMOVE_INSTRUCTIONS:
					app.removeInstructions();
					break;
				
				case ApplicationFacade.ADD_LEADERBOARD:
					app.addLeaderboard();
					break;
				
				case ApplicationFacade.ADD_TERMS:
					app.addTerms();
					break;
				
				case ApplicationFacade.REMOVE_TERMS:
					app.removeTerms();
					break;
				
				case ApplicationFacade.ADD_GAME:
					app.addGame();
					break;
				
				case ApplicationFacade.REMOVE_GAME:
					app.removeGame();
					break;
				
				case ApplicationFacade.REMOVE_LEADERBOARD:
					app.removeLeaderboard();
					break;
				
				case ApplicationFacade.ADD_REGISTRATION:
					app.addRegistration();
					break;
				
				case ApplicationFacade.REMOVE_REGISTRATION:
					app.removeRegistration();
					break;
				
				case ApplicationFacade.REMOVE_COMPONENT:
					app.removeComponent(notification.getBody() as IAnimatable);
					break;
				
				case ApplicationFacade.LANGUAGE:
					app.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get app():CocaCola {
			return viewComponent as CocaCola;
		}
	}
}