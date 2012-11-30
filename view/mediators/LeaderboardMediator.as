/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import model.LeaderboardProxy;
	import model.valueObjects.LeaderboardRowVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Leaderboard;
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.events.LeaderboardEvent;
	import view.events.MenuEvent;
	
	public class LeaderboardMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "LeaderboardMediator";
		
		public function LeaderboardMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}

		override public function onRegister():void {
			leaderboard.addEventListener(AnimationEvent.ANIMATION_OUT_COMPLETE, leaderboard_animationOutCompleteHandler);
			leaderboard.addEventListener(LeaderboardEvent.LEADERBOARD, leaderboard_leaderboardHandler);
			leaderboard.addEventListener(MenuEvent.PLAY_AGAIN, leaderboard_playAgainHandler);
		}
		
		private function leaderboard_animationOutCompleteHandler(event:AnimationEvent):void {
			facade.sendNotification(ApplicationFacade.REMOVE_GAME);
			facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, leaderboard);
		}
		
		private function leaderboard_leaderboardHandler(event:LeaderboardEvent):void {
			var leaderboardProxy:LeaderboardProxy = facade.retrieveProxy(LeaderboardProxy.NAME) as LeaderboardProxy;
			leaderboardProxy.leaderboard();
		}
		
		private function leaderboard_playAgainHandler(event:MenuEvent):void {
			this.facade.sendNotification(ApplicationFacade.RESET_GAME);
			this.facade.sendNotification(ApplicationFacade.RESET_CLOCK_POINTS);
			this.facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, leaderboard);
			this.facade.sendNotification(ApplicationFacade.START_GAME);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.LEADERBOARD_SUCCESS,
				ApplicationFacade.ADD_LEADERBOARD,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.LEADERBOARD_SUCCESS:
					leaderboard.populate(notification.getBody() as Array);
					break;
				case ApplicationFacade.ADD_LEADERBOARD:
					leaderboard.displayMessage(notification.getBody() as Boolean);
					break;
				case ApplicationFacade.LANGUAGE:
					leaderboard.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get leaderboard():Leaderboard {
			return viewComponent as Leaderboard;
		}
	}
}