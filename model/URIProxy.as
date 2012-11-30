/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model {
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class URIProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "URIProxy";
		
		public static var PATH:String;
		public static var REGISTRATION_INSERT:String;
		public static var REGISTRATION_EXISTS:String;
		public static var LEADEROBARD:String;
		public static var SCORE_INSERT:String;
		public static var USER:String;
		
		public function URIProxy(data:Object=null) {
			super(NAME, data);
			
			if(ApplicationFacade.STAGING) {
				PATH = "http://localhost/~sshams/Coca-Cola-PHP/index.php/";
				//PATH = "http://10.244.153.90/~sshams/Coca-Cola-PHP/index.php/";
			} else {
				PATH = "http://facebook.ebroadcast.me/mcdonalds/cocacola/index.php/";
				//PATH = "index.php/";
			}
			
			REGISTRATION_INSERT = "registration/insert";
			REGISTRATION_EXISTS = "registration/exists";
			LEADEROBARD = "score/leaderboard";
			SCORE_INSERT = "score/insert";
			USER = "score/user";
		}
	}
}