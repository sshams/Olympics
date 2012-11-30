/**
 * Author: Saad Shams
 * Version: 1.0
 * Date: 2012-05-12
 **/
package com.saad {
	import view.events.LanguageEvent;

	public interface ILanguageable {
		function layout(event:LanguageEvent):void;
		function layout_completeHandler():void;
	}
}