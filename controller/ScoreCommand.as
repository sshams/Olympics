package controller {
	import model.LeaderboardProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.mediators.ClockMediator;
	import view.mediators.PointsMediator;
	
	public class ScoreCommand extends SimpleCommand implements ICommand {
		
		override public function execute(notification:INotification):void {
			var leaderboardProxy:LeaderboardProxy = facade.retrieveProxy(LeaderboardProxy.NAME) as LeaderboardProxy;
			var pointsMediator:PointsMediator = facade.retrieveMediator(PointsMediator.NAME) as PointsMediator;
			var clockMediator:ClockMediator = facade.retrieveMediator(ClockMediator.NAME) as ClockMediator;
			
			leaderboardProxy.insert(pointsMediator.getPoints(), clockMediator.getTime(), clockMediator.getRounds());
		}
		
	}
}