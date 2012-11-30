/**
* @author Saad Shams :: sshams@live.com
* Copy or reuse is prohibited.
* */

package view.components {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.saad.IAnimatable;
	
	import flash.display.MovieClip;
	
	public class Background extends MovieClip implements IAnimatable {
		public function Background() {}
		
		public function animateIn():void {
			TweenMax.from(this, 1.6, {alpha:0, ease:Cubic.easeOut});
		}
		public function animateIn_completeHandler():void {}
		public function animateOut():void {}
		public function animateOut_completeHandler():void {}
		public function reset():void {}
	}
}