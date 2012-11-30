/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import com.facebook.graph.Facebook;
	
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import model.FacebookProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Instructions;
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	
	public class InstructionsMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "InstructionsMediator";
		
		private var facebookProxy:FacebookProxy;
		
		public function InstructionsMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			facebookProxy = facade.retrieveProxy(FacebookProxy.NAME) as FacebookProxy;
			
			instructions.addEventListener(AnimationEvent.ANIMATION_OUT_COMPLETE, instructions_animateOutCompleteHandler);
			instructions.addEventListener(MenuEvent.FACEBOOK, intro_facebookHandler);
		}
		
		private function intro_facebookHandler(event:MenuEvent):void {
			if(!FacebookProxy.authenticated) {
				facebookProxy.login();
			} else {
				facade.sendNotification(ApplicationFacade.REMOVE_INSTRUCTIONS);
				facade.sendNotification(ApplicationFacade.ADD_GAME);
			}
		}
		
		private function instructions_animateOutCompleteHandler(event:AnimationEvent):void {
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, instructions);
			facade.sendNotification(ApplicationFacade.ADD_GAME);
		}
		
		override public function listNotificationInterests():Array {
			return [
				FacebookProxy.LOGIN,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				
				case FacebookProxy.LOGIN:
					instructions.animateOut();
					break;
				
				case ApplicationFacade.LANGUAGE:
					instructions.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get instructions():Instructions {
			return viewComponent as Instructions;
		}
	}
}