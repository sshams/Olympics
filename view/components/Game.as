/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.saad.IAnimatable;
	import com.saad.ILanguageable;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import view.events.AnimationEvent;
	import view.events.ClockEvent;
	import view.events.GameEvent;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	import view.events.ScoreEvent;
	
	public class Game extends MovieClip implements IAnimatable, ILanguageable {
		
		
		private var lang:String = LanguageEvent.EN;
		private var timelineMax:TimelineMax;
		private var classInstance:Object;
		
		private var countdownTimer:Timer = new Timer(1000,4);
		private var powerBarTimer:Timer = new Timer(20);
		private var idleStateTimer:Timer = new Timer(10000);
		private var countdownClip:countdown = new countdown();
		private var pointsPopupClip:pointsPopup = new pointsPopup();
		
		private var intialCounter:Number = 0;
		private var ringPower:Number = 0;
		private var ringIdCurrent:Number = 0;
		private static var totalRingLoopCounter:Number = 0;
		private static var ringLoopCounter:Number = 0;		
		private static var ringTossThreshold:Number = 60;
		private static var ringPowerBooster:Number = 10;
		private static var arrowRotation:Number = 0;
		
		private static var lockArrow:Boolean = false;
		private static var gameOverFlag:Boolean = false;
		private static var ringPosition:Object;
		
		private static var ringHighlightArray:Array = new Array();
		private static var ringColorArray:Array = new Array();
		private static var distanceArray:Array = new Array();
		private static var angleRangeArray:Array = new Array([15,35],[77,102],[145,160],[38,70],[110,140]);
		private static var ringPointsArray:Array = new Array(10,8,6,2,4);
		private static var glassColorArray:Array = new Array ("0x2ABFF8","0x000000","0xCD0026","0xFF9900","0x33CC00");
		
		public var glass1:MovieClip;
		public var glass2:MovieClip;
		public var glass3:MovieClip;
		public var glass4:MovieClip;
		public var glass5:MovieClip;
		
		public var ring:MovieClip;
		public var ringBack:MovieClip;
		public var ringFront:MovieClip;
		
		public var idleState:MovieClip;
		public var powerbar:MovieClip;
		public var bonusTimeText:MovieClip;
		public var remainingGlasses:MovieClip;
		public var directionArrow:MovieClip;
		
		public var clock:Clock;
		public var points:Points;
		
		public function Game() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEvent);
		}
		
		public function animateIn():void  {
			this.startGame();
		}
		
		public function startGame():void {
			gameOverFlag = false;
			idleState.visible = false;
			idleState.alpha = 0;
			intialCounter = 0;
			countdownClip.gotoAndStop(1);
			countdownTimer.reset();
			countdownTimer.start();
			
			ringPosition = {xPos:ring.x,yPos:ring.y};
			directionArrow.arrow.gotoAndStop(150);
			//TweenMax.delayedCall(3.5, addListenerStatus, [true]);
			TweenMax.delayedCall(3.5, function(){idleStateTimer.start()});
			resetRing();
		}
		
		public function animateIn_completeHandler():void {}
		public function animateOut():void {
			//gameOver();
			TweenMax.to(this, .1, {alpha:0, ease:Expo.easeOut, onComplete:animateOut_completeHandler});
		}
		public function animateOut_completeHandler():void {
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_OUT_COMPLETE));
		}
		public function reset():void {
			
			intialCounter = 0;
			arrowRotation = 0;
			totalRingLoopCounter = 0;
			ringPower = 0;
			ringIdCurrent = 0;
			ringLoopCounter = 0;		
			ringTossThreshold = 60;
			ringPowerBooster = 10;
			
			
			gameOverFlag = true;
			idleStateTimer.stop();
			idleStateTimer.reset();
			addListenerStatus(false);
			resetRingCounter();
			points.reset();
			clock.reset();
			TweenMax.to(this, 0, {alpha:1});
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				timelineMax.insertMultiple([
					TweenMax.to(idleState, .25, {alpha:0}),
					TweenMax.to(remainingGlasses.textComponent, .25, {alpha:0})
				]);
			}
			
		}
		
		public function layout_completeHandler():void {
			idleState.play();
			remainingGlasses.textComponent.play();
			timelineMax.reverse();
			}

		public function addedToStageEvent(e:Event):void {
			classInstance = this;
			
			populateColorArray();
			populateDistanceArray();
			TweenPlugin.activate([BezierPlugin]);
			countdownTimer.addEventListener(TimerEvent.TIMER, onCountdownHandler);
			
			this.addChild(countdownClip);
			countdownClip.x = 410;
			countdownClip.y = 260;
		}
		
		private function onCountdownHandler(e:TimerEvent):void {
			intialCounter++;
			trace("intialCounter ",intialCounter)
			if(intialCounter<=3) {
				countdownClip.play();
			} else {
				trace("i am here")
				addListenerStatus(true);
				
			}
			if(intialCounter==3) {
				dispatchEvent(new GameEvent(GameEvent.START_CLOCK));
			}
			
			
			//trace("intialCounter "+intialCounter)
		}
		
		// Game logic ----------------------------------------
		
		private function populateDistanceArray():void {
			distanceArray.length = 0;
			for(var i:Number = 0 ; i<5; i++) {
				distanceArray.push(GetDistanceSquare(this["glass"+(i+1)].x,this["glass"+(i+1)].y,ring.x,ring.y));
			}
			//trace("distanceArray ",distanceArray);
		}
		
		private function GetDistanceSquare(xA:Number, yA:Number, xB:Number, yB:Number):Number {
			var xDiff:Number = xA - xB;
			var yDiff:Number = yA - yB;
			 
			return Math.round(Math.sqrt(xDiff * xDiff + yDiff * yDiff));
		}
		
		private function populateColorArray():void {
			ringColorArray.length = 0
			for(var i:Number = 0 ;i < 5; i++) {
				ringColorArray.push(i);
			}
			//trace("ringColorArray "+ringColorArray)
		}
		
		private function getRandomRingColor():Number {
			var randomColor:Number = 0;
			var ringColorId:Number = 0;
			//trace("populateColorArray "+populateColorArray);
			if(ringColorArray.length >0) {
				randomColor = Math.round(Math.random()*(ringColorArray.length-1));
			  	ringColorId = ringColorArray[randomColor];
				ringColorArray.splice(randomColor,1);
			}
			if(ringColorArray.length ==0)
			{
				totalRingLoopCounter++;
				populateColorArray();
			}
			
			ringIdCurrent = (ringColorId+1)
			
			return ringIdCurrent;
		}
		
		private function resetRing():void {
			ringPower = 0;
			var randomRingColor:Number = getRandomRingColor();
			ring.gotoAndStop(randomRingColor);
			ringFront.gotoAndStop(randomRingColor);
			ringBack.gotoAndStop(randomRingColor);
			ring.scaleX = ring.scaleY = ringFront.scaleX = ringFront.scaleY = ringBack.scaleX = ringBack.scaleY = 1;
			ring.x = ringFront.x = ringBack.x = ringPosition.xPos;
			ring.y = ringFront.y = ringBack.y = ringPosition.yPos;
			this.setChildIndex(ring,this.numChildren-1);
			this.setChildIndex(ringFront,this.numChildren-1);
			this.setChildIndex(ringBack,this.numChildren-1);
			powerbar.gotoAndStop(1);
			TweenMax.to(directionArrow.arrow,.5, {alpha:1, ease:Expo.easeOut});
			//idleStateTimer.start();
		}
		
		private function powerbarCallback(e:TimerEvent):void {
			
			if(powerbar.currentFrame < powerbar.totalFrames)
				ringPower = ringPower+ringPowerBooster;
			
		}
		
		
		private function idleStateCallback(e:TimerEvent):void {
			//trace("callback called ");
			idleStateTimer.stop();
			idleStateTimer.reset();
			idleState.visible = true;
			TweenMax.to(idleState,1, {alpha:1, ease:Expo.easeOut});
		}
		
		
		private function onMouseMoveCallback(e:MouseEvent):void
		{
			var resultantAngle:Number = angleBetween(mouseX, mouseY, ring.x, ring.y);
			
			//trace("resultantAngle ",resultantAngle);
			if(resultantAngle >48 && resultantAngle<128)
			{
					arrowRotation = Math.round(resultantAngle*directionArrow.arrow.totalFrames/180);
					TweenMax.to(directionArrow.arrow,1, {frame:arrowRotation, ease:Expo.easeOut});
			} else if(resultantAngle <48)
			{
				arrowRotation = Math.round(48*directionArrow.arrow.totalFrames/180);
				TweenMax.to(directionArrow.arrow,1, {frame:arrowRotation, ease:Expo.easeOut});
			}
			else if(resultantAngle>128 && resultantAngle<180)
			{
				arrowRotation = Math.round(128*directionArrow.arrow.totalFrames/180);
				TweenMax.to(directionArrow.arrow,1, {frame:arrowRotation, ease:Expo.easeOut});
			}
		}
		
		private function onMouseDownCallback(e:MouseEvent):void
		{
			TweenMax.to(idleState,1, {alpha:0, ease:Expo.easeOut, onComplete:function(){idleState.visible = false}});
			powerBarTimer.start();
			powerbar.play();
		}
		
		private function onMouseUpCallback(e:MouseEvent):void
		{
			powerBarTimer.stop();
			powerbar.stop();
			flickRing();
			addListenerStatus(false);
		}
		
		private function addListenerStatus(listenerStatus:Boolean):void
		{
			//trace('add listener ', listenerStatus);
			if(!listenerStatus)
			{
				if(stage)
				{
					idleStateTimer.removeEventListener(TimerEvent.TIMER, idleStateCallback);
					powerBarTimer.removeEventListener(TimerEvent.TIMER, powerbarCallback);
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCallback);
					stage.removeEventListener(MouseEvent.MOUSE_UP  , onMouseUpCallback);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveCallback);
				}
				
			}else if(listenerStatus && gameOverFlag == false)
			{
				if(stage)
				{
					idleStateTimer.addEventListener(TimerEvent.TIMER, idleStateCallback);
					powerBarTimer.addEventListener(TimerEvent.TIMER, powerbarCallback);
					if(!stage.hasEventListener(MouseEvent.MOUSE_UP))
					{
						stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCallback);
						stage.addEventListener(MouseEvent.MOUSE_UP  , onMouseUpCallback);
						stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveCallback);
					}
				}
			}
		}
		
		private function setRingPos(xPos:Number, yPos:Number, scaleNum:Number, ringRotation:Number = 0):void
		{
			ringFront.x = ringBack.x = xPos;
			ringFront.y = ringBack.y = yPos;
			ringFront.rotation = ringBack.rotation = ringRotation;
			ringFront.scaleX = ringFront.scaleY = ringBack.scaleX = ringBack.scaleY = scaleNum;
		}
		
		private function flickRing():void
		{
			
			var resultantAngle:Number = Number(Math.atan2( mouseY - ring.y, mouseX - ring.x )* (180 / Math.PI))-90;
			var ringDestX:Number = ring.x + Math.cos((resultantAngle+90)*Math.PI/180)*ringPower;
			var ringDestY:Number = ring.y + Math.sin((resultantAngle+90)*Math.PI/180)*ringPower;
			var curClass:MovieClip = this;

			var closeGlassObject:Object = getClosestGlass(ringDestX,ringDestY)
			var closestGlass:MovieClip = curClass.getChildByName("glass"+(closeGlassObject.glassId)) as MovieClip;
			closestGlass.glassId = closeGlassObject.glassId;
			
			if(closeGlassObject.distance <= ringTossThreshold)
			{
				if(ringIdCurrent == closeGlassObject.glassId)
				{
					//trace("yay !!")
					TweenMax.delayedCall(2,highlightRing,[closeGlassObject]);
				}
				else
				{
					TweenMax.delayedCall(2,updateScore,["subtract", MovieClip(classInstance.getChildByName("glass"+(closeGlassObject.glassId)) as MovieClip)]);
					//trace("!! ",closeGlassObject.glassId)	
				}
				
				
				TweenMax.to(ring,1.5, {
						scaleX:Number(1-(ringPower/1000)*1.2),
						scaleY:Number(1-(ringPower/1000)*1.2),
						x:closestGlass.x, 
						y:closestGlass.y+15, 
						ease:Bounce.easeOut, 
						bezierThrough:[{y:Number(closestGlass.y-(ringPower))}],
						onUpdate:function()
						{
							setRingPos(ring.x, ring.y, ring.scaleX);
						}});
				TweenMax.to(ring,0, {delay:1,onComplete:function()
							{
								curClass.setChildIndex(ringFront, Number(curClass.getChildIndex(closestGlass)+1)); 
								curClass.setChildIndex(ringBack, Number(curClass.getChildIndex(closestGlass)-1)); 
						}});
				
			}
			else
			{
				//trace("i am in lower angle")
				var bounceX:Number;
				var bounceY:Number;
				
				if(Math.round(closestGlass.y-(ringPower/2)) < Math.round(closestGlass.height))
				{
					bounceX = (ringDestX-Math.random()*100);
					bounceY = (closestGlass.y-Math.random()*50);
					
					TweenMax.to(ring,1.5, {
						x:bounceX, 
						y:bounceY, 
						scaleX:Number(1-(ringPower/1000)*1.5),
						scaleY:Number(1-(ringPower/1000)*1.5),
						rotation:0,
						ease:Bounce.easeOut, 
						bezierThrough:[{y:closestGlass.y-(ringPower/2)}],
						onUpdate:function()
						{
							setRingPos(ring.x, ring.y, ring.scaleX, ring.rotation);
						}});
					TweenMax.to(ring,0, {delay:.6,onComplete:function()
							{
								curClass.setChildIndex(ringFront, 1); 
								curClass.setChildIndex(ringBack, 1); 
						}});	
				}else
				{
					bounceX = ringDestX;
					bounceY = closestGlass.y;
					TweenMax.to(ring,.1, {
						x:bounceX, 
						y:closestGlass.y-(ringPower/2), 
						scaleX:Number(1-(ringPower/1000)*1.5),
						scaleY:Number(1-(ringPower/1000)*1.5),
						rotation:0,
						onUpdate:function()
						{
							setRingPos(ring.x, ring.y, ring.scaleX, ring.rotation);
						}});
					
					ringDestX = ring.x + Math.cos((resultantAngle+90)*Math.PI/180);
					ringDestY = ring.y + Math.sin((resultantAngle+90)*Math.PI/180);
					
					TweenMax.to(ring,.5, {
						delay:.1,
						x:ringDestX, 
						y:ringDestY, 
						scaleX:1,
						scaleY:1,
						rotation:0,
						ease:Bounce.easeOut, 
						bezierThrough:[{y:closestGlass.y-(ringPower/2)}],
						onUpdate:function()
						{
							setRingPos(ring.x, ring.y, ring.scaleX, ring.rotation);
						}});
					/*TweenMax.to(ring,0, {delay:.6,onComplete:function()
							{
								curClass.setChildIndex(ringFront, 1); 
								curClass.setChildIndex(ringBack, 1); 
						}});*/	
					
				}
				
			}
			
			TweenMax.to(directionArrow.arrow,.5, {alpha:0, ease:Expo.easeOut});
			TweenMax.delayedCall(2, function(){idleStateTimer.reset();idleStateTimer.start()});
			TweenMax.delayedCall(2,resetRing);
			TweenMax.delayedCall(2,addListenerStatus,[true]);
		}
		
		private function updateScore(action:String, targetGlass:MovieClip):void
		{
			var score:Number;
			
			switch (action)
			{
				case "add":
					score = Number(ringPointsArray[(targetGlass.glassId-1)]);
					//scoreDisplay.updateScore(score);
					dispatchEvent(new ScoreEvent(ScoreEvent.ADD_SCORE, score));
				break;
				case "subtract":
					score = Number(ringPointsArray[(targetGlass.glassId-1)]);
					//scoreDisplay.updateScore(score);
					//trace("substract score "+score);
					dispatchEvent(new ScoreEvent(ScoreEvent.SUBTRACT_SCORE, score));
				break;
			}
			
			showPointsPopup(action, targetGlass, score);
			
		}
		
		private function showPointsPopup(action:String, targetGlass:MovieClip,score:Number):void
		{
			pointsPopupClip.x = Number(targetGlass.x - 30);
			pointsPopupClip.y = Number(targetGlass.y - targetGlass.height/2);
			pointsPopupClip.alpha = 0;
			pointsPopupClip.points.autoSize = TextFieldAutoSize.CENTER;
			switch (action)
			{
				case "add":
					pointsPopupClip.points.text = String("+"+score);
				break;
				case "subtract":
					pointsPopupClip.points.text = String("-"+score);
				break;
			}
			TweenMax.to(pointsPopupClip.bg,0,{tint:uint(glassColorArray[(targetGlass.glassId-1)])});
			classInstance.addChild(pointsPopupClip);
			showPointPopup();
		}
		
		private function showPointPopup():void
		{
			TweenMax.to(pointsPopupClip,1, {y:(pointsPopupClip.y-50), alpha:1, ease:Expo.easeOut});
			TweenMax.delayedCall(1.3,hidePointPopup);
		}
		
		private function hidePointPopup():void
		{
			TweenMax.to(pointsPopupClip,0.5, {alpha:0, ease:Expo.easeOut, onComplete:function (){classInstance.removeChild(pointsPopupClip)}});
		}
		
		private function highlightRing(targetGlassObject:Object):void
		{
			var ringId:Number = targetGlassObject.glassId;
			var i:Number = 0;
			var highlightCounter:Number = 0;
			
			MovieClip(remainingGlasses["circle"+ringId]).gotoAndStop(ringId+1);
			
			for(i = 1 ; i <= 5 ;i++)
			{
				if(MovieClip(remainingGlasses["circle"+(i)]).currentFrame >1)
					highlightCounter++;
			}
			if(highlightCounter == 5)
			{
				//timerDisplay.updateBonusTime();
				bonusTimeText.gotoAndStop(1);
				bonusTimeText.play();
				dispatchEvent(new ClockEvent(ClockEvent.ADD_TIME));
				TweenMax.delayedCall(1, resetRingCounter);
			}
			
			//var closestGlass:MovieClip = curClass.getChildByName("glass"+(ringId)) as MovieClip;
			updateScore("add" , MovieClip(classInstance.getChildByName("glass"+(ringId)) as MovieClip));
			//trace("highlightCounter "+highlightCounter);
		}
		
		private function resetRingCounter():void
		{
			for(var i:Number = 1 ; i <= 5 ;i++)
			{
				MovieClip(remainingGlasses["circle"+(i)]).gotoAndStop(1);
			}
			ringLoopCounter++;
		}
		
		private function getClosestGlass(ringDestX:Number, ringDestY:Number):Object
		{
			var distanceArray:Array = new Array();
			var shortestDistance:Number = 0;
			for(var i:Number = 0 ; i<5; i++)
			{
				var ringDistance:Number = GetDistanceSquare(ringDestX,ringDestY,this["glass"+(i+1)].x,this["glass"+(i+1)].y)
				distanceArray.push({distance:ringDistance,glassId:(i+1)});
			}
			distanceArray.sortOn("distance", Array.NUMERIC);
			return distanceArray[0];
		}
		

		private function angleBetween(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			
			var angle:Number = Number(Math.atan2( y2 - y1, x2 - x1 )* (180 / Math.PI));
			var resultAngle:Number = angle < 0 ? angle + 360 : angle;
			return resultAngle;
		}
		
		public function gameOver():void
		{
			//trace("Game Over")
			gameOverFlag = true;
			addListenerStatus(false);
			//TweenMax.delayedCall(2, dispatchEvent,[new MenuEvent(MenuEvent.LEADERBOARD)]);
			dispatchEvent(new MenuEvent(MenuEvent.LEADERBOARD));
		}

	}
}