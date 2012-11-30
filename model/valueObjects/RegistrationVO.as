/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model.valueObjects {
	public class RegistrationVO {
		
		public var uid:String;
		public var first_name:String;
		public var last_name:String;
		public var email:String;
		public var phone:String;
		public var country_id:int;
		public var lang:String;
		
		public function RegistrationVO() {

		}
		
		public function toString():String {
			return "uid:" + this.uid + " first_name:" + this.first_name + " last:" + this.last_name + " email:" + this.email + " phone:" + this.phone + " country_id:" + this.country_id + " lang:" + this.lang;
		}
	}
}