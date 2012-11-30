/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package model.valueObjects.facebook {
	public class LocationVO {
		
		public var id:String;
		public var name:String;
		
		public function LocationVO(id:String, name:String) {
			this.id = id;
			this.name = name;
		}
	}
}