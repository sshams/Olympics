package controller {
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookAuthResponse;
	
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import model.FacebookProxy;
	import model.LeaderboardProxy;
	import model.RegistrationProxy;
	import model.URIProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.mediators.ApplicationMediator;
	import view.mediators.GameMediator;
	import view.mediators.InstructionsMediator;
	import view.mediators.IntroMediator;
	import view.mediators.LanguageMediator;
	import view.mediators.LeaderboardMediator;
	import view.mediators.MenuMediator;
	import view.mediators.RegistrationMediator;
	import view.mediators.TermsMediator;
	
	public class StartupCommand extends SimpleCommand implements ICommand {
		
		override public function execute(notification:INotification):void {
			
			var app:CocaCola = notification.getBody() as CocaCola;
			
			facade.registerProxy(new URIProxy());
			facade.registerProxy(new RegistrationProxy());
			facade.registerProxy(new LeaderboardProxy());
			facade.registerProxy(new FacebookProxy(ApplicationFacade.APP_ID, ApplicationFacade.PERMISSIONS));
			
			facade.registerMediator(new ApplicationMediator(app));
			facade.registerMediator(new LanguageMediator(app.language));
			facade.registerMediator(new GameMediator(app.game));
			facade.registerMediator(new InstructionsMediator(app.instructions));
			facade.registerMediator(new IntroMediator(app.intro));
			facade.registerMediator(new LeaderboardMediator(app.leaderboard));
			facade.registerMediator(new MenuMediator(app.menu));
			facade.registerMediator(new RegistrationMediator(app.registration));
			facade.registerMediator(new TermsMediator(app.terms));
			
			var facebookProxy:FacebookProxy = facade.retrieveProxy(FacebookProxy.NAME) as FacebookProxy;
			facebookProxy.init();
		}
		
	}

}