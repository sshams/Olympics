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
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.text.TLFTextField;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import model.valueObjects.RegistrationVO;
	import model.valueObjects.facebook.UserVO;
	
	import view.events.AnimationEvent;
	import view.events.LanguageEvent;
	import view.events.MenuEvent;
	import view.events.RegistrationEvent;
	import view.events.facebook.MeEvent;
	
	public class Registration extends MovieClip implements IAnimatable, ILanguageable {
		
		public var first_name:*;
		public var last_name:TLFTextField;
		public var email:TLFTextField;
		public var phone:TLFTextField;
		public var location:TLFTextField;
		public var country_id:ComboBox;
		
		private var textFields:Vector.<TLFTextField>;
		
		private var defaultValues:Array = [];
		
		private var defaultColor:uint = 0xA2A2A2;
		private var invalidColor:uint = 0xB31518;
		
		public var enter:MovieClip;
		public var copy:MovieClip;
		public var submit:MovieClip;
		public var close:MovieClip;
		private var loading:Loading = new Loading();
		
		private var lang:String = LanguageEvent.EN;
		private var timelineMax:TimelineMax;
		
		private var facebookVO:UserVO;
		
		private var en:Array = [
			{label: "Select your country", data:"-1"},
			{label: "Bahrain", data:"1"},
			{label: "Jordan", data:"2"},
			{label: "Kuwait", data:"3"},
			{label: "KSA Center, East and North", data:"4"},
			{label: "KSA West and South", data:"5"},
			{label: "Qatar", data:"6"},
			{label: "Oman", data:"7"},
			{label: "United Arab Emirates", data:"8"}
		];
		
		private var ar:Array = [
			{label: "اختر البلد", data:"-1"},
			{label: "البحرين", data:"1"},
			{label: "الأردن", data:"2"},
			{label: "الكويت", data:"3"},
			{label: "المملكة العربية السعودية,المنطقة الشرقية و الشمالية و الوسطى", data:"4"},
			{label: "المملكة العربية السعودية,المنطقة  الغربية و الجنوبية", data:"5"},
			{label: "قطر", data:"7"},
			{label: "سلطنة عمان", data:"6"},
			{label: "الامارات العربية المتحدة", data:"8"}
		];
		
		public function Registration() {
			this.mouseChildren = false;
			submit.buttonMode = true;
			submit.addEventListener(MouseEvent.CLICK, submit_clickHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			close.addEventListener(MouseEvent.CLICK, close_clickHandler);
		}
		
		private function close_clickHandler(event:MouseEvent):void {
			animateOut();
		}
		
		private function addedToStageHandler(event:Event):void {
			textFields = new Vector.<TLFTextField>();
			
			first_name = this.getChildByName("first_name") as TLFTextField;
			last_name = this.getChildByName("last_name") as TLFTextField;
			email = this.getChildByName("email") as TLFTextField;
			phone = this.getChildByName("phone") as TLFTextField;
			location = this.getChildByName("location") as TLFTextField;
			
			textFields.push(first_name, last_name, email, phone, location);
			defaultColor = first_name.textColor;
			country_id.dataProvider = new DataProvider(en);
			
			for(var i=0; i<textFields.length; i++) {
				defaultValues.push(TLFTextField(textFields[i]).text);
				textFields[i].addEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
				textFields[i].addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function textField_focusInHandler(event:FocusEvent):void {
			for(var i:int=0; i<textFields.length; i++){
				if(event.currentTarget == textFields[i] && event.currentTarget.text == defaultValues[i]) {
					event.currentTarget.text = "";
					textFields[i].setSelection(textFields[i].text.length,0);
					break;
				}
			}
		}
		
		private function textField_focusOutHandler(event:FocusEvent):void {
			for(var i:int=0; i<textFields.length; i++){
				if(event.currentTarget == textFields[i] && event.currentTarget.text == "") {
					event.currentTarget.text = defaultValues[i];
					break;
				}
			}
		}
		
		private function submit_clickHandler(event:MouseEvent):void {
			if(validate()){
				var registrationVO:RegistrationVO = new RegistrationVO();
				registrationVO.first_name = first_name.text;
				registrationVO.last_name = last_name.text;
				registrationVO.email = email.text;
				registrationVO.phone = phone.text;
				registrationVO.country_id = country_id.selectedIndex;
				registrationVO.lang = this.lang;
				
				dispatchEvent(new RegistrationEvent(RegistrationEvent.REGISTRATION, registrationVO));
				addChild(loading);
				this.mouseChildren = false;
			}
		}
		
		public function success():void {
			removeChild(loading);
			this.mouseChildren = true;
			animateOut();
			TweenMax.delayedCall(.2, success_completeHandler);
		}
		
		public function success_completeHandler():void {
			dispatchEvent(new MenuEvent(MenuEvent.GAME));
		}
		
		private function validate():Boolean {
			var isValid = true;
			
			for(var i=0; i<textFields.length - 1; i++){
				if(textFields[i].text == "" || textFields[i].text == defaultValues[i]){
					isValid = false;
					textFields[i].textColor = invalidColor;
				} else {
					textFields[i].textColor = defaultColor;
				}
			}
			
			if(country_id.selectedIndex == 0) {
				isValid = false;
				location.textColor = invalidColor;
				country_id.textField.textField.textColor = invalidColor;
			} else {
				location.textColor = defaultColor;
				country_id.textField.textField.textColor = defaultColor;
			}

			var emailRegExp:RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
			if(email.text.match(emailRegExp) == null) {
				isValid = false;
				email.textColor = invalidColor;
			} else {
				email.textColor = defaultColor;
			}
			
			return isValid;
		}
		
		public function populate(facebookVO:UserVO):void {
			this.facebookVO = facebookVO;
			this.mouseChildren = true;
			removeChild(loading);
			
			first_name.text = facebookVO.first_name;
			last_name.text = facebookVO.last_name;
			email.text = facebookVO.email;
		}

		public function animateIn():void {
			TweenMax.from(this, .5, {y:String(200), alpha:0, ease:Expo.easeOut, onComplete:animateIn_completeHandler});
			addChild(loading);
		}
		public function animateIn_completeHandler():void {
			dispatchEvent(new MeEvent(MeEvent.ME));
		}
		
		public function animateOut():void {
			TweenMax.to(this, .1, {alpha:0, ease:Expo.easeOut, onComplete:animateOut_completeHandler});
		}
		public function animateOut_completeHandler():void {
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_OUT_COMPLETE));
		}
		
		public function reset():void {
			TweenMax.to(this, 0, {alpha:1});
		}
		
		public function layout(event:LanguageEvent):void {
			if(this.lang != event.type){
				this.lang = event.type;
				timelineMax = new TimelineMax({onComplete:layout_completeHandler});
				
				timelineMax.insertMultiple([
					TweenMax.to(first_name, .25, {alpha:0}),
					TweenMax.to(last_name, .25, {alpha:0}),
					TweenMax.to(email, .25, {alpha:0}),
					TweenMax.to(phone, .25, {alpha:0}),
					TweenMax.to(location, .25, {alpha:0}),
					TweenMax.to(country_id, .25, {alpha:0}),
					TweenMax.to(enter, .25, {alpha:0}),
					TweenMax.to(copy, .25, {alpha:0}),
					TweenMax.to(submit, .25, {alpha:0})
				]);
			}
		}
		
		public function layout_completeHandler():void {
			enter.play();
			copy.play();
			submit.play();
			resetTextFields();
			timelineMax.reverse();
		}
		
		public function resetTextFields():void {
			var font:Font;
			var textFormat:TextFormat = new TextFormat();
			
			if(this.lang == LanguageEvent.EN) {
				country_id.x = 217;
				country_id.width = 190;
				country_id.dataProvider = new DataProvider(en);
				defaultValues = ["First name", "Last name", "Email address", "Phone number", "Country"];
				
				font = new Lubal();
				textFormat.align = TextFormatAlign.LEFT;
				textFormat.font = font.fontName;
				textFormat.size = 12;
				
				for(var i:int=0; i<textFields.length; i++) {
					textFields[i].text = defaultValues[i];
					textFields[i].textColor = defaultColor;
					textFields[i].setTextFormat(textFormat);
				}
				
				country_id.dropdown.setStyle("fontSize", 12);
			} else {
				country_id.x = 153;
				country_id.width = 215;
				country_id.dataProvider = new DataProvider(ar);
				defaultValues = ["الاسم", "العائلة", "البريد الإلكتروني", "رقم الهاتف", "البلد"];
				
				font = new GE();
				textFormat.align = TextFormatAlign.RIGHT;
				textFormat.font = font.fontName;
				textFormat.size = 12;
				
				
				for(var j:int=0; j<textFields.length; j++) {
					textFields[j].text = defaultValues[j];
					textFields[j].textColor = defaultColor;
					textFields[j].setTextFormat(textFormat);
				}
				
				country_id.dropdown.setStyle("fontSize", 8);
				country_id.dropdown.setStyle("color", 0xFF0000);
			}

		}

	}
}