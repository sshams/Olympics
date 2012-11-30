/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.mediators {
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.Game;
	import view.events.AnimationEvent;
	import view.events.ClockEvent;
	import view.events.GameEvent;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	import view.events.ScoreEvent;
	
	public class GameMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "GameMediator";
		
		public function GameMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			facade.registerMediator(new PointsMediator(game.points));
			facade.registerMediator(new ClockMediator(game.clock));
			
			game.addEventListener(MenuEvent.LEADERBOARD, game_leaderboardHandler);
			game.addEventListener(AnimationEvent.ANIMATION_OUT_COMPLETE, game_animationOutCompleteHandler);
			game.addEventListener(ClockEvent.ADD_TIME, game_addTimeHandler);
			game.addEventListener(ScoreEvent.ADD_SCORE, game_addScoreHandler);
			game.addEventListener(ScoreEvent.SUBTRACT_SCORE, game_subtractScoreHandler);
			game.addEventListener(GameEvent.START_CLOCK, game_startClockHandler);
		}
		
		private function game_startClockHandler(event:GameEvent):void {
			facade.sendNotification(ApplicationFacade.START_CLOCK);
		}
		
		private function game_leaderboardHandler(event:MenuEvent):void {
			this.facade.sendNotification(ApplicationFacade.ADD_LEADERBOARD, Boolean(true));
		}
		
		private function game_animationOutCompleteHandler(event:AnimationEvent):void {
			this.facade.sendNotification(ApplicationFacade.REMOVE_COMPONENT, game);
		}
		
		private function game_addTimeHandler(event:ClockEvent):void {
			this.facade.sendNotification(ApplicationFacade.ADD_TIME);
		}
		
		private function game_addScoreHandler(event:ScoreEvent):void {
			this.facade.sendNotification(ApplicationFacade.ADD_SCORE, event.points);
		}
		
		private function game_subtractScoreHandler(event:ScoreEvent):void {
			this.facade.sendNotification(ApplicationFacade.SUBTRACT_SCORE, event.points);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.RESET_GAME,
				ApplicationFacade.TIME_OVER,
				ApplicationFacade.START_GAME,
				ApplicationFacade.LANGUAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.RESET_GAME:
					game.reset();
					break;
				case ApplicationFacade.TIME_OVER:
					game.gameOver();
					break;
				case ApplicationFacade.START_GAME:
					game.startGame();
					break;
				case ApplicationFacade.LANGUAGE:
					game.layout(notification.getBody() as LanguageEvent);
					break;
			}
		}
		
		public function get game():Game {
			return viewComponent as Game;
		}
	}
}