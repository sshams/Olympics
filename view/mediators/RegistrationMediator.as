/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import model.FacebookProxy;
	import model.RegistrationProxy;
	import model.valueObjects.facebook.UserVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Registration;
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	import view.events.RegistrationEvent;
	import view.events.facebook.MeEvent;
	
	public class RegistrationMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "RegistrationMediator";
		
		private var facebookProxy:FacebookProxy;
		private var registrationProxy:RegistrationProxy;
		
		public function RegistrationMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
			facebookProxy = facade.retrieveProxy(FacebookProxy.NAME) as FacebookProxy;
			registrationProxy = facade.retrieveProxy(RegistrationProxy.NAME) as RegistrationProxy;
		}
		
		override public function onRegister():void {
			registration.addEventListener(MeEvent.ME, registration_meHandler);
			registration.addEventListener(RegistrationEvent.REGISTRATION, registration_registrationHandler);
			registration.addEventListener(MenuEvent.GAME, registration_gameHandler);
			registration.addEventListener(AnimationEvent.ANIMATION_OUT_COMPLETE, registration_animateOutCompleteHandler);
		}
		
		private function registration_animateOutCompleteHandler(event:AnimationEvent):void {
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, registration);
		}
		
		private function registration_meHandler(event:MeEvent):void {
			facebookProxy.getMe();
		}
		
		private function registration_registrationHandler(event:RegistrationEvent):void {
			registrationProxy.insert(event.registrationVO);
		}
		
		private function registration_gameHandler(event:MenuEvent):void {
			this.facade.sendNotification(ApplicationFacade.REMOVE_REGISTRATION);
			//this.facade.sendNotification(ApplicationFacade.ADD_GAME);
		}
		
		override public function listNotificationInterests():Array {
			return [
				FacebookProxy.ME,
				RegistrationProxy.REGISTRATION_SUCCESS,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case FacebookProxy.ME:
					registration.populate(notification.getBody() as UserVO);
					break;
				case RegistrationProxy.REGISTRATION_SUCCESS:
					registration.success();
					break;
				case ApplicationFacade.LANGUAGE:
					registration.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get registration():Registration {
			return viewComponent as Registration;
		}
		
	}
}