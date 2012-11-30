/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */
package model.valueObjects {
	public class LeaderboardRowVO {
		
		public var rank:int;
		public var name:String;
		public var points:int;
		public var country_id:int = 8;
		
		/*
		Please follow the id's given below for their respective regions
		1 - bahrain
		2 - jordan
		3 - kuwait
		4 - ksa-riyadh
		5 - ksa-jeddah
		6 - qatar
		7 - oman
		8 - uae
		*/
		
		public function LeaderboardRowVO(rank:int, name:String, points:int, country_id:int) {
			this.rank = rank;
			this.name = name;
			this.points = points;
			this.country_id = country_id;
		}
		
		public function toString():String {
			return this.rank + " " + this.name + " " + this.points + " " + this.country_id;
		}
		
	}
}