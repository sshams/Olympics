/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package controller.facebook {
	import com.facebook.graph.data.FacebookAuthResponse;
	
	import flash.external.ExternalInterface;
	
	import model.RegistrationProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FacebookLoginCommand extends SimpleCommand implements ICommand {
		override public function execute(notification:INotification):void {
			
			var response:FacebookAuthResponse = FacebookAuthResponse(notification.getBody());
			
			var registrationProxy:RegistrationProxy = facade.retrieveProxy(RegistrationProxy.NAME) as RegistrationProxy;
			if(!ApplicationFacade.registration_id) { 
				ExternalInterface.call("trace", "exists");
				registrationProxy.exists(ApplicationFacade.uid); 
				facade.sendNotification(ApplicationFacade.ADD_GAME);
			} else { 
				ExternalInterface.call("trace", "addRegistration");
				facade.sendNotification(ApplicationFacade.ADD_REGISTRATION);
			}
			
		}
	}
}