/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.text.TextFieldAutoSize;
	
	import model.valueObjects.LeaderboardRowVO;
	
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.events.LeaderboardEvent;
	import view.events.MenuEvent;
	
	public class Leaderboard extends MovieClip implements IAnimatable, ILanguageable {
		
		private var loading:Loading;
		private var rowContainer:MovieClip;
		private var timelineMax:TimelineMax;
		private var rows:Array = new Array();
		
		public var userRow:MovieClip;
		public var rowTitles;
		
		public var inviteFriends;
		public var downloads;
		public var leaderboardTitle;
		
		public var playAgain:MovieClip;
		public var close:MovieClip;
		public var points:MovieClip;
		
		public var instrMessage;
		
		public var regions:Array = new Array("bahrain","jordan","kuwait","ksa-riyadh","ksa-jeddah","qatar","oman","uae");
		
		private var downloadURL:String;
		private var regionID:int;
		
		private var lang:String = LanguageEvent.EN;
		
		public function Leaderboard() {
			loading = new Loading();
			userRow.visible = false;
			
			rowContainer = new MovieClip();
			rowContainer.x = 178;
			rowContainer.y = 300;
			addChild(rowContainer);
			
			close.addEventListener(MouseEvent.CLICK, close_clickHandler);
			close.buttonMode = true;
			
			playAgain.buttonMode = true;
			downloads.buttonMode = true;
			inviteFriends.buttonMode = true;
			
			playAgain.addEventListener(MouseEvent.CLICK, playAgain_clickHandler);
			downloads.addEventListener(MouseEvent.CLICK, downloads_clickHandler);
			inviteFriends.addEventListener(MouseEvent.CLICK, inviteFriends_clickHandler);
		}
		
		private function close_clickHandler(event:MouseEvent):void {
			animateOut();
		}
		
		public function populate(leaderboard:Array):void {
			
			while(rowContainer.numChildren) {
				rowContainer.removeChildAt(0);
			}
			
			var userVO:LeaderboardRowVO = leaderboard[0];
			var leaderboardRowVOs:Array = leaderboard[1];
			
			if(String(userVO.name).length==0)
				userRow.visible = false;
			else
				userRow.visible = true;
			
			if(userVO.country_id) {
				regionID = userVO.country_id;
			} else {
				regionID = 8;
			}
			
			removeChild(loading);
			
			userRow.rank.ranktf.autoSize = TextFieldAutoSize.CENTER;
			userRow.nametf.autoSize = TextFieldAutoSize.LEFT;
			userRow.points.pointstf.autoSize = TextFieldAutoSize.RIGHT;
				
			userRow.rank.ranktf.text = String(userVO.rank);
			userRow.nametf.text = userVO.name;
			userRow.points.pointstf.text = String(userVO.points);
			rows.length = 0;
			
			for(var i:Number = 0; i<leaderboardRowVOs.length;i++) {
				var leaderboardRow:LeaderboardRow = new LeaderboardRow();
				var leaderboardRowVO:LeaderboardRowVO = leaderboardRowVOs[i];
				
				leaderboardRow.name = "leaderboardRow"+i;
				
				leaderboardRow.rank.ranktf.autoSize = TextFieldAutoSize.CENTER;
				leaderboardRow.nametf.autoSize = TextFieldAutoSize.LEFT;
				leaderboardRow.points.pointstf.autoSize = TextFieldAutoSize.RIGHT;
				
				leaderboardRow.rank.ranktf.text = String(leaderboardRowVO.rank);
				leaderboardRow.nametf.text = leaderboardRowVO.name;
				leaderboardRow.points.pointstf.text = String(leaderboardRowVO.points);
				leaderboardRow.y = Number((leaderboardRow.bg.height)*i);
				if(i>0 && i%2) {
					leaderboardRow.bg.visible = false;
				}
				rows.push(leaderboardRow);
				rowContainer.addChild(leaderboardRow);
			}
			repositionLeaderboardRow(lang)
		}

		private function playAgain_clickHandler(event:MouseEvent):void {
			dispatchEvent(new MenuEvent(MenuEvent.PLAY_AGAIN));
		}
		
		private function downloads_clickHandler(event:MouseEvent):void {
			if(this.lang == LanguageEvent.EN) {
				downloadURL = String("http://www.mcdonaldsarabia.com/"+regions[(regionID-1)]+"/en/promotions/the-glass-of-champions-prizes.html");
			} else {
				downloadURL = String("http://www.mcdonaldsarabia.com/"+regions[(regionID-1)]+"/ar/promotions/the-glass-of-champions-prizes.html");
			}
			
   			navigateToURL(URLRequest(downloadURL), "_blank");
		}
		
		public function displayMessage(visibility:Boolean):void {
			if(visibility) {
				instrMessage.visible = true;
			} else if(!visibility) {
				instrMessage.visible = false;
			}
		}
		
		private function inviteFriends_clickHandler(event:MouseEvent):void {
			var urlStr:String;
			if(this.lang == LanguageEvent.EN) {
				urlStr = "https://www.facebook.com/dialog/send?app_id=153236354807862&name=The%20Glass%20Of%20Champions&link=https://apps.facebook.com/mcdcocacola/share/?lang=en&redirect_uri=https://apps.facebook.com/mcdcocacola/";
			} else {
				urlStr = "https://www.facebook.com/dialog/send?app_id=153236354807862&name=&link=https://apps.facebook.com/mcdcocacola/share/?lang=ar&redirect_uri=https://apps.facebook.com/mcdcocacola/";
			}
   			navigateToURL(new URLRequest(urlStr), "_blank");
		}
		
		public function animateIn():void {
			TweenMax.from(this, .5, {y:String(200), alpha:0, ease:Expo.easeOut, onComplete:animateIn_completeHandler});
		}
		
		public function animateIn_completeHandler():void {
			addChild(loading);
			dispatchEvent(new LeaderboardEvent(LeaderboardEvent.LEADERBOARD));
		}
		
		public function animateOut():void {
			TweenMax.to(this, .1, {alpha:0, ease:Expo.easeOut, onComplete:animateOut_completeHandler});
		}
		
		public function animateOut_completeHandler():void {
			//dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_OUT_COMPLETE));
		}
		
		public function reset():void {
			while(rowContainer.numChildren) {
				rowContainer.removeChildAt(0);
			}
			rows.length = 0;
			TweenMax.to(this, 0, {alpha:1});
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type) {
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				timelineMax.insertMultiple([
					TweenMax.to(userRow.rank, .25, {alpha:0}),
					TweenMax.to(userRow.nametf, .25, {alpha:0}),
					TweenMax.to(userRow.points, .25, {alpha:0}),
					TweenMax.to(close, .25, {alpha:0}),
					TweenMax.to(rowTitles, .25, {alpha:0}),
					TweenMax.to(leaderboardTitle, .25, {alpha:0}),
					TweenMax.to(playAgain, .25, {alpha:0}),
					TweenMax.to(inviteFriends, .25, {alpha:0}),
					TweenMax.to(downloads, .25, {alpha:0}),
					TweenMax.to(instrMessage, .25, {alpha:0})
				]);
				
				for(var i:Number = 0; i<rows.length;i++) {
					var rowObject:MovieClip = rows[i] as MovieClip;
					timelineMax.insertMultiple([
						TweenMax.to(rowObject.rank, .25, {alpha:0}),
						TweenMax.to(rowObject.nametf, .25, {alpha:0}),
						TweenMax.to(rowObject.points, .25, {alpha:0}),
					]);
				}
			}
		}
		
		public function repositionLeaderboardRow(lang:String):void {
			for(var i:Number = 0; i<rows.length;i++) {
				var rowObject:MovieClip = rows[i] as MovieClip;
				switch (lang) {
					case LanguageEvent.EN:
						rowObject.rank.x = -2.5;
						rowObject.nametf.x = 29;
						rowObject.points.x = 418;
						rowObject.points.pointsText.gotoAndStop(1);
					break;
					case LanguageEvent.AR:
						rowObject.rank.x = 458;
						rowObject.nametf.x = 339;
						rowObject.points.x = 65;
						rowObject.points.pointsText.gotoAndStop(2);
					break;
				}
			}
		}
		
		
		public function layout_completeHandler():void {
			userRow.rank.play();
			userRow.points.play();
			close.play();
			instrMessage.play();
			rowTitles.play();
			playAgain.play();
			downloads.play();
			inviteFriends.play();
			leaderboardTitle.play();
			if(rowContainer.numChildren>0) {
				for(var i:Number = 0; i<rows.length;i++) {
					var rowObject:MovieClip = rows[i] as MovieClip;
					rowObject.rank.play();
					rowObject.points.play();
				}
			}
			resetRows();
			//timelineMax.reverse();
		}
		
		private function resetRows():void {
			var i:Number = 0;
			
			if(this.lang == LanguageEvent.EN) {
				userRow.rank.x = 0;
				userRow.nametf.x = 30;
				userRow.points.x = 420;
				userRow.points.pointsText.gotoAndStop(1);
				if(rowContainer.numChildren>0) {
					for(i = 0; i<rows.length;i++) {
						var rowObject:MovieClip = rows[i] as MovieClip;
						rowObject.rank.x = -2.5;
						rowObject.nametf.x = 29;
						rowObject.points.x = 418;
						rowObject.points.pointsText.gotoAndStop(1);
					}
				}
			}
			
			if(this.lang == LanguageEvent.AR) {
				userRow.rank.x = 461;
				userRow.nametf.x = 340;
				userRow.points.x = 65;
				userRow.points.pointsText.gotoAndStop(2);
				if(rowContainer.numChildren>0) {
					for(i = 0; i<rows.length;i++) {
						rowObject = rows[i] as MovieClip;
						rowObject.rank.x = 458;
						rowObject.nametf.x = 339;
						rowObject.points.x = 65;
						rowObject.points.pointsText.gotoAndStop(2);
					}
				}
			}
			timelineMax.reverse();
		}
	}
}