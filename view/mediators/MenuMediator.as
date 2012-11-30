/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Menu;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	
	public class MenuMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "MenuMediator";
		
		public function MenuMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			menu.addEventListener(MenuEvent.INSTRUCTIONS, menu_instructionsHandler);
			menu.addEventListener(MenuEvent.LEADERBOARD, menu_leaderboardHandler);
			menu.addEventListener(MenuEvent.TERMS, menu_termsHandler);
			
			menu.addEventListener(LanguageEvent.EN, menu_enHandler);
			menu.addEventListener(LanguageEvent.AR, menu_arHandler);
		}
		
		private function menu_instructionsHandler(event:MenuEvent):void {
			facade.sendNotification(ApplicationFacade.ADD_INSTRUCTIONS);
			facade.sendNotification(ApplicationFacade.REMOVE_LEADERBOARD);
			facade.sendNotification(ApplicationFacade.REMOVE_TERMS);
			facade.sendNotification(ApplicationFacade.REMOVE_GAME);
			facade.sendNotification(ApplicationFacade.RESET_CLOCK_POINTS);
		}
		
		private function menu_leaderboardHandler(event:MenuEvent):void {
			facade.sendNotification(ApplicationFacade.ADD_LEADERBOARD, Boolean(false));
			facade.sendNotification(ApplicationFacade.REMOVE_INSTRUCTIONS);
			facade.sendNotification(ApplicationFacade.REMOVE_TERMS);
			//facade.sendNotification(ApplicationFacade.REMOVE_GAME);
			//facade.sendNotification(ApplicationFacade.RESET_CLOCK_POINTS);
		}
		
		private function menu_termsHandler(event:MenuEvent):void {
			facade.sendNotification(ApplicationFacade.ADD_TERMS);
			facade.sendNotification(ApplicationFacade.REMOVE_INSTRUCTIONS);
			facade.sendNotification(ApplicationFacade.REMOVE_LEADERBOARD);
			facade.sendNotification(ApplicationFacade.REMOVE_GAME);
			facade.sendNotification(ApplicationFacade.RESET_CLOCK_POINTS);
		}
		
		private function menu_enHandler(event:LanguageEvent):void {
			ApplicationFacade.lang = event.type;
			facade.sendNotification(ApplicationFacade.LANGUAGE, event);
		}
		
		private function menu_arHandler(event:LanguageEvent):void {
			ApplicationFacade.lang = event.type;
			facade.sendNotification(ApplicationFacade.LANGUAGE, event);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.LANGUAGE:
					menu.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get menu():Menu {
			return viewComponent as Menu;
		}
	}
}