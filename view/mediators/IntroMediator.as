/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import model.FacebookProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Intro;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	
	public class IntroMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "IntroMediator";
		
		private var facebookProxy:FacebookProxy;
		
		public function IntroMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
			intro.addEventListener(MenuEvent.INSTRUCTIONS, intro_instructionsHandler);
		}
		
		override public function onRegister():void {
			facebookProxy = facade.retrieveProxy(FacebookProxy.NAME) as FacebookProxy;
		}
		
		private function intro_instructionsHandler(event:MenuEvent):void { 
			facade.sendNotification(ApplicationFacade.ADD_INSTRUCTIONS);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_GAME,
				ApplicationFacade.REMOVE_GAME,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.ADD_GAME:
					intro.mouseEnabled = false;
					intro.mouseChildren = false;
					break;
				case ApplicationFacade.REMOVE_GAME:
					intro.mouseEnabled = true;
					intro.mouseChildren = true;
					break;
				case ApplicationFacade.LANGUAGE:
					intro.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get intro():Intro {
			return viewComponent as Intro;
		}
		
	}
}