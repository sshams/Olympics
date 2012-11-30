/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model.valueObjects.facebook {
	import model.valueObjects.facebook.LocationVO;

	public class UserVO {
		
		public var uid:String
		public var first_name:String
		public var last_name:String
		public var name:String
		public var email:String
		public var gender:String
		public var location:LocationVO;
		public var link:String
		public var locale:String
		public var timezone:int
		public var updated_time:String
		public var verified:Boolean
		public var work:Array
		
		public function UserVO(response:Object) {
			this.uid = response.id ? response.id : "";
			this.first_name = response.first_name ? response.first_name : "";
			this.last_name = response.last_name ? response.last_name : "";
			this.name = response.name ? response.name : "";
			this.email = response.email ? response.email : "";
			this.gender = response.gender ? response.gender : "";
			this.link = response.link ? response.link : "";
			this.locale = response.locale ? response.locale : "";
			this.timezone = response.timezone ? response.timezone : -1;
			this.updated_time = response.updated_time ? response.updated_time : "";
			this.work = response.work ? response.work : null;
			this.verified = response.verified ? response.verified : false;
			this.location = response.location ? new LocationVO(response.location.id, response.location.name) : new LocationVO("", "");
		}
	}
}