/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.display.*;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class InertiaScroller extends MovieClip
	{
		private var contentmaskMc:MovieClip = new MovieClip();
		private var contentMc:MovieClip = new MovieClip();
		private var scrollerMc:MovieClip = new MovieClip();
		private var scrollTrackMc:MovieClip = new MovieClip();
		private var parentStage:Object;
		
		private var scrollerXPosition:Number;
		private var scrollerYPosition:Number;
		private var contentYPosition:Number;
		
		public function InertiaScroller()
		{

		}
		
		public function Init(content:MovieClip,contentmask:MovieClip,scroller:MovieClip,scrolltrack:MovieClip,stageInstance:Object):void
		{
			contentMc = content;
			scrollerMc = scroller;
			scrollTrackMc = scrolltrack;
			contentmaskMc = contentmask;
			contentMc.mask = contentmaskMc;
			scrollerXPosition = scrollerMc.x;
			scrollerYPosition = scrollerMc.y;
			contentYPosition = contentMc.y;
			parentStage = stageInstance;
			if (contentMc.height < contentmask.height)
			{
				scrollerMc.visible = false;
				scrollTrackMc.visible = false;
			}else
			{
				scrollerMc.visible = true;
				scrollTrackMc.visible = true;
				activateScroller();
			}
			
		}
		
		private function activateScroller():void
		{
			scrollerMc.clickState = false;
			scrollerMc.addEventListener(MouseEvent.MOUSE_DOWN, scrollContent);
			parentStage.addEventListener(MouseEvent.MOUSE_MOVE, scrollmouseMove);
			parentStage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
		}
		
		
		private function scrollContent(e:MouseEvent):void
		{
			e.currentTarget.clickState = true;
			MovieClip(e.currentTarget).startDrag(false, new Rectangle(scrollerXPosition, scrollerYPosition, 0, (scrollTrackMc.height - MovieClip(e.currentTarget).height)));
		}
		private function scrollmouseMove(e:MouseEvent):void
		{
			if (scrollerMc.clickState == true)
			{
				runScroller();
			}
		}
		
		private function runScroller():void
		{
			var scrollPosition:Number = ( -(contentMc.height - (contentmaskMc.height)) * (scrollerMc.y) ) / (scrollTrackMc.height - scrollerMc.height);
 			var scrollInitLocation:Number = (( -(contentMc.height - contentmaskMc.height) * scrollerYPosition ) / (scrollTrackMc.height - scrollerMc.height)) - contentYPosition;
			TweenMax.killTweensOf(contentMc);
			TweenMax.to(contentMc,1,{y:Math.round(scrollPosition + Math.abs(scrollInitLocation)), ease:Expo.easeOut});
		}
		
		private function stopScroll(e:MouseEvent):void
		{
			if (scrollerMc.clickState == true)
			{
				scrollerMc.clickState = false;
				scrollerMc.stopDrag();
			}
		}
		
		
	}

}