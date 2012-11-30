/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package controller.facebook {
	import com.facebook.graph.data.FacebookAuthResponse;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FacebookInitCommand extends SimpleCommand implements ICommand {
		
		override public function execute(notification:INotification):void {
			var response:FacebookAuthResponse = FacebookAuthResponse(notification.getBody());
			ApplicationFacade.uid = response.uid;
		}
		
	}
}