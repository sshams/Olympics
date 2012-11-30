/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model {
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import model.valueObjects.RegistrationVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RegistrationProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "RegistrationProxy";
		
		public static const REGISTRATION_SUCCESS:String = "registrationSuccess";
		
		private var request:URLRequest;
		private var variables:URLVariables;
		private var loader:URLLoader;
		
		public function RegistrationProxy(data:Object=null) {
			super(NAME, data);
		}
		
		public function insert(registrationVO:RegistrationVO):void {
			request = new URLRequest(URIProxy.PATH + URIProxy.REGISTRATION_INSERT);
			request.method = URLRequestMethod.POST;
			
			variables = new URLVariables();
			variables.uid = ApplicationFacade.uid;
			variables.first_name = registrationVO.first_name;
			variables.last_name = registrationVO.last_name;
			variables.email = registrationVO.email;
			variables.phone = registrationVO.phone;
			variables.country_id = registrationVO.country_id;
			variables.lang = registrationVO.lang;
			request.data = variables;
			
			ApplicationFacade.country_id = registrationVO.country_id;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, urlLoader_insertHandler);
			loader.load(request);
		}
		
		private function urlLoader_insertHandler(event:Event):void {
			try {
				var variables:URLVariables = new URLVariables(URLLoader(event.target).data);
				if(variables.success && variables.success != 0) {
					ApplicationFacade.registration_id = variables.registration_id;
					facade.sendNotification(REGISTRATION_SUCCESS);
				}
			} catch (error:Error) {
				ExternalInterface.call("trace", event.target.data + " - " + error);
			}
		}
		
		public function exists(uid:String):void {
			request = new URLRequest(URIProxy.PATH + URIProxy.REGISTRATION_EXISTS);
			request.method = URLRequestMethod.POST;
			
			variables = new URLVariables();
			variables.uid = uid;
			request.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES.toUpperCase();
			loader.addEventListener(Event.COMPLETE, urlLoader_existsHandler);
			loader.load(request);
		}
		
		protected function urlLoader_existsHandler(event:Event):void {
			try {
				var variables:URLVariables = new URLVariables(URLLoader(event.target).data);
				
				if(variables.success && variables.success != 0) {
					ApplicationFacade.registration_id = variables.registration_id;
					ApplicationFacade.country_id = variables.country_id;
					//facade.sendNotification(ApplicationFacade.ADD_GAME);
				} else {
					facade.sendNotification(ApplicationFacade.ADD_REGISTRATION);
				}
				
			} catch(error:Error) {
				ExternalInterface.call("trace", event.target.data + " - " + error);
			}
		}
	}
}