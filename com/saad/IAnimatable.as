/**
 * Author: Saad Shams
 * Version: 1.0
 * Date: 2011-03-15
 **/
package com.saad {
	public interface IAnimatable {
		function animateIn():void;
		function animateIn_completeHandler():void;
		function animateOut():void;
		function animateOut_completeHandler():void;
		function reset():void;
	}
}