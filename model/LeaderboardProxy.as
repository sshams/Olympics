/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.xml.XMLDocument;
	
	import model.valueObjects.LeaderboardRowVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LeaderboardProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "LeaderboardProxy";
		
		private var request:URLRequest;
		private var variables:URLVariables;
		private var loader:URLLoader;
		
		private var leaderboardRowVOs:Array;
		private var userRowVO:LeaderboardRowVO;
		
		public function LeaderboardProxy() {
			super(NAME, null);
		}
		
		public function insert(points:Number, time:Number, rounds:Number):void {
			var request:URLRequest = new URLRequest(URIProxy.PATH + URIProxy.SCORE_INSERT);
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.registration_id = ApplicationFacade.registration_id;
			variables.points = points;
			variables.time = time;
			variables.rounds = rounds;
			request.data = variables;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES.toUpperCase();
			loader.addEventListener(Event.COMPLETE, insert_completeHandler);
			loader.load(request);
		}
		
		public function insert_completeHandler(event:Event):void {
			try {
				var variables:URLVariables = new URLVariables(URLLoader(event.target).data);
				
				if(variables.success && variables.success != 0) {
					facade.sendNotification(ApplicationFacade.INSERT_SUCCESS);
				}
			} catch (error:Error) {
				ExternalInterface.call("trace", event.target.data + " - " + error);
			}
		}
		
		public function leaderboard():void {
			request = new URLRequest(URIProxy.PATH + URIProxy.LEADEROBARD);
			request.method = URLRequestMethod.POST;
			
			variables = new URLVariables();
			variables.uid = ApplicationFacade.uid;
			
			if(ApplicationFacade.registration_id) {
				variables.registration_id = ApplicationFacade.registration_id;
				variables.country_id = ApplicationFacade.country_id;
			}
			request.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES.toUpperCase();
			loader.addEventListener(Event.COMPLETE, urlLoader_leaderboardHandler);
			loader.load(request);
		}
		
		private function urlLoader_leaderboardHandler(event:Event):void {
			var xmlDocument:XMLDocument = new XMLDocument();
			xmlDocument.ignoreWhite = true;
			xmlDocument.parseXML(event.target.data);
			
			userRowVO = new LeaderboardRowVO(xmlDocument.firstChild.attributes.rank, xmlDocument.firstChild.attributes.name, xmlDocument.firstChild.attributes.points, xmlDocument.firstChild.attributes.country_id);

			leaderboardRowVOs = [];			
			for(var i:int=0; i<xmlDocument.firstChild.childNodes.length; i++) {
				var row:Object = xmlDocument.firstChild.childNodes[i].attributes;
				leaderboardRowVOs.push(new LeaderboardRowVO(row.rank, row.name, row.points, row.country_id));
			}
			
			this.facade.sendNotification(ApplicationFacade.LEADERBOARD_SUCCESS, [userRowVO, leaderboardRowVOs]);
		}
		
	}
}