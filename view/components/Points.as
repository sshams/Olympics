/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import view.events.LanguageEvent;
	
	public class Points extends MovieClip implements IAnimatable, ILanguageable {
		
		private var timelineMax:TimelineMax;
		private var totalScore:Number = 0;
		private var isGameOver:Boolean = false;
		
		public var pointsClip:MovieClip;
		private var lang:String = LanguageEvent.EN;
		
		public function Points() {
			pointsClip.pointsText.pointsText.autoSize = TextFieldAutoSize.CENTER;
			pointsClip.pointsText.pointsText.text = "0";
		}
	
		public function getPoints():Number {
			return totalScore;
		}
		
		public function addScore(score:Number):void {
			if(!isGameOver) {
				totalScore = totalScore+score;
				if(totalScore >= 0) {
					pointsClip.pointsText.pointsText.text = String(totalScore);
				}
			}
		}
		
		public function subtractScore(score:Number):void {
			if(!isGameOver) {
				totalScore = totalScore-score;
				if(totalScore >= 0) {
					pointsClip.pointsText.pointsText.text = String(totalScore);
				} else {
					totalScore = 0;
					pointsClip.pointsText.pointsText.text = String(totalScore);
				}
			}
		}
		
		public function gameOver():void {
			isGameOver = true;
		}

		public function animateIn():void {}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {}
		public function animateOut_completeHandler():void {}
		public function reset():void {
			totalScore = 0;
			pointsClip.pointsText.pointsText.text = "0";
			isGameOver = false;
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				timelineMax.insertMultiple([
					TweenMax.to(pointsClip, .15, {alpha:0})
				]);
			}
			
		}
		
		public function layout_completeHandler():void {
			pointsClip.play();
			timelineMax.reverse();
		}
	}
}