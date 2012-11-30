package {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import view.components.Loading;
	
	public class Preloader extends MovieClip {
		
		public var loading:Loading;
		public var bar:MovieClip;
		public var textField:TextField;
		
		private var loader:Loader = new Loader();
		
		public function Preloader() {
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest("CocaCola.swf"));
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var percent:Number = Math.round(event.bytesLoaded / event.bytesTotal * 100);
			bar.scaleX = event.bytesLoaded / event.bytesTotal;
			textField.text = percent + "%";
		}
		
		private function completeHandler(event:Event):void {
			removeChild(loading);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			
			var application:DisplayObject = loader.content;
			trace(application);
			addChild(application);
		}
	}
}