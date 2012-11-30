/**
 * Author: Saad Shams
 * Version: 1.0
 * Date: 2011-03-15
 **/
package com.saad {
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;

	public class TweenClips {
		
		public function TweenClips() {
		}
		
		/**
		 * @param items receives as an array populated with clips to animate
		 * */
		
		public static function from(clips:Vector.<MovieClip>, duration:Number, vars:Object, onComplete:Function=null, delay:Number=0):void {
			var timeline:TimelineMax = new TimelineMax({onComplete:onComplete, delay:delay});
			var tweens:Array = new Array();
			
			for(var i:int=0; i<clips.length; i++){
				tweens.push(TweenMax.from(clips[i], duration, vars));
			}
			
			timeline.appendMultiple(tweens, 0, TweenAlign.START, 0.2);
		}
		
		/**
		 * @param items receives as an array populated with clips to animate
		 * */
		
		public static function to(clips:Vector.<MovieClip>, duration:Number, vars:Object, onComplete:Function=null, delay:Number=0):void {
			var timeline:TimelineMax = new TimelineMax({onComplete:onComplete, delay:delay});
			var tweens:Array = new Array();
			
			for(var i:int=clips.length-1; i>=0; i--){
				tweens.push(TweenMax.to(clips[i], duration, vars));
			}
			
			timeline.appendMultiple(tweens, 0, TweenAlign.START, 0.2);
		}
		
		
		public static function animateInFrom(clips:Vector.<MovieClip>, duration:Number, vars:Object, delay:Number=0, onComplete:Function=null):void {
			var timeline:TimelineMax = new TimelineMax({onComplete:onComplete, delay:delay});
			var tweens:Array = new Array();
			
			for(var i:int=0; i<clips.length; i++){
				tweens.push(TweenMax.from(clips[i], duration, vars));
			}
			
			timeline.appendMultiple(tweens, 0, TweenAlign.START, duration/2);
		}
		
		/**
		 * @param items receives as an array populated with clips to animate
		 * */
		
		public static function animateOutTo(clips:Vector.<MovieClip>, duration:Number, vars:Object, delay:Number=0, onComplete:Function=null):void {
			var timeline:TimelineMax = new TimelineMax({onComplete:onComplete, delay:delay});
			var tweens:Array = new Array();
			
			for(var i:int=clips.length-1; i>=0; i--){
				tweens.push(TweenMax.to(clips[i], duration, vars));
			}
			
			timeline.appendMultiple(tweens, 0, TweenAlign.START, duration/2);
		}
		
		/**
		 * @param clips receives as an array populated with clips to glow
		 * */
		
		public static function animateGlow(clips:Vector.<MovieClip>, duration, vars:Object=null, vars2:Object=null):void {
			TweenPlugin.activate([GlowFilterPlugin]);
			
			vars.onComplete = TweenClips.animateGlowOut;
			
			for(var i:int=0; i<clips.length; i++){
				vars.onCompleteParams = [clips[i], duration, vars2];
				TweenMax.to(clips[i], duration/2, vars);
			}
		}
		
		public static function animateGlowOut(clip:MovieClip, duration:Number, vars2:Object=null):void { //reset the glow function
			TweenMax.to(clip, duration/2, vars2);
		}
		
	}
}