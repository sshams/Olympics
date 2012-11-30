/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model {
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookAuthResponse;
	
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import model.valueObjects.facebook.UserVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FacebookProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "FacebookProxy";
		
		public static const INIT:String = "init";
		public static const LOGIN:String = "login";
		public static const ME:String = "me";
		
		public static var authenticated:Boolean = false;
		
		protected var appID:String;
		protected var permissions:Object;
		
		public function FacebookProxy(appID:String, permissions:Object) {
			super(NAME, null);
			this.appID = appID;
			this.permissions = permissions;
			
			this.getLoginStatus();
		}
		
		public function init():void { 
			Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			Facebook.init(this.appID, this.initHandler);
		}
		
		protected function initHandler(response:FacebookAuthResponse, fail:Object):void {
			if(response && response.uid){
				facade.sendNotification(INIT, response);
			}
		}
		
		public function login():void {
			Facebook.login(loginHandler, this.permissions);
		}
		
		protected function loginHandler(response:FacebookAuthResponse, fail:Object):void {
			if(response && response.uid) {
				authenticated = true;
				facade.sendNotification(LOGIN);
			} else {
				//ExternalInterface.call("trace", "code:" + fail.error.code + ", message:" + fail.error.message + ", type:" + fail.error.type);
			}
		}
		
		public function getLoginStatus():void {
			ExternalInterface.call("trace", "getLoginStatus");
			Facebook.addJSEventListener("auth.sessionChange", getLoginStatusHandler);
			Facebook.getLoginStatus();
		}
		
		private function getLoginStatusHandler(response:Object):void {
			ExternalInterface.call("trace", "authenticated");
			authenticated = true;
		}
		
		public function getMe():void {
			Facebook.api("/me", getMeHandler);
		}
		
		protected function getMeHandler(response:Object, fail:Object):void {
			if(response && response.id) {
				facade.sendNotification(ME, new UserVO(response));
			} else {
				ExternalInterface.call("trace", "code:" + fail.error.code + ", message:" + fail.error.message + ", type:" + fail.error.type);
			}
		}
		
		public function getStatuses():void {
			Facebook.api("/me/statuses", getStatusesHandler);
		}
		
		protected function getStatusesHandler(response:FacebookAuthResponse, fail:Object):void {
		}
		
		public function post(message:String):void {
			Facebook.api("/me/feed", postHandler, {message:message}, "POST");
		}
		
		protected function postHandler(response:FacebookAuthResponse, fail:Object):void {
		}
		
		public function logout():void {
			Facebook.logout(logoutHandler);
		}
		
		protected function logoutHandler(response:Object):void {
		}
		
	}
}