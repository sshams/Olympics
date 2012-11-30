/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Terms;
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	
	public class TermsMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "TermsMediator";
		
		public function TermsMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			terms.addEventListener(AnimationEvent.ANIMATION_OUT_COMPLETE, terms_animateOutCompleteHandler);
		}
		
		private function terms_animateOutCompleteHandler(event:AnimationEvent):void {
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, terms);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.LANGUAGE:
					terms.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get terms():Terms {
			return viewComponent as Terms;
		}
	}
}