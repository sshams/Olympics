/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Language;
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	
	public class LanguageMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "LanguageMediator";
		
		public function LanguageMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			language.addEventListener(LanguageEvent.EN, language_enHandler);
			language.addEventListener(LanguageEvent.AR, language_arHandler);
			
			language.addEventListener(AnimationEvent.ANIMATION_OUT_COMPLETE, language_animateOutCompleteHandler);
		}
		
		private function language_enHandler(event:LanguageEvent):void {
			facade.sendNotification(ApplicationFacade.LANGUAGE, event);
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, language);
		}
		
		private function language_arHandler(event:LanguageEvent):void {
			facade.sendNotification(ApplicationFacade.LANGUAGE, event);
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, language);
		}
		
		private function language_animateOutCompleteHandler(event:AnimationEvent):void {
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, language);
		}
		
		public function get language():Language {
			return viewComponent as Language;
		}
	}
}