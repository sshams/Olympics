﻿package {	import controller.facebook.FacebookInitCommand;	import controller.facebook.FacebookLoginCommand;	import controller.ScoreCommand;	import controller.StartupCommand;		import model.FacebookProxy;		import org.puremvc.as3.interfaces.IFacade;	import org.puremvc.as3.patterns.facade.Facade;
		public class ApplicationFacade extends Facade implements IFacade {				public static const STAGING:Boolean = true;				public static const STARTUP:String = "startup";				public static const EN:String = "en";		public static const AR:String = "ar";		public static const LANGUAGE:String = "language";				public static const ADD_INSTRUCTIONS:String = "addInstructions";		public static const REMOVE_INSTRUCTIONS:String = "removeInstructions";		public static const ADD_LEADERBOARD:String = "addLeaderboard";		public static const REMOVE_LEADERBOARD:String = "removeLeaderboard";		public static const ADD_TERMS:String = "addTerms";		public static const REMOVE_TERMS:String = "removeTerms";		public static const ADD_REGISTRATION:String = "addRegistration";		public static const REMOVE_REGISTRATION:String = "removeRegistration";		public static const ADD_GAME:String = "addGame";		public static const REMOVE_GAME:String = "removeGame";		public static const RESET_GAME:String = "resetGame";		public static const RESET_CLOCK_POINTS:String = "resetClockPoints";		public static const REMOVE_COMPONENT:String = "removeComponent";				public static const START_GAME:String = "startGame";		public static const START_CLOCK:String = "startClock";				public static const LEADERBOARD_SUCCESS:String = "leaderboardSuccess";				public static const ADD_SCORE:String = "addScore";		public static const ADD_TIME:String = "addTime";		public static const TIME_OVER:String = "timeOver";		public static const SUBTRACT_SCORE:String = "subtractScore";				public static const INSERT_SCORE:String = "insertScore";		public static const INSERT_SUCCESS:String = "insertSuccess";				public static const APP_ID:String = (STAGING) ? "410632875624636" : "153236354807862";		public static const PERMISSIONS:Object = {scope:"email, user_location"};				public static var uid:String = ""		public static var registration_id:int = 0;		public static var country_id:int = 0;		public static var lang:String = EN; 				public static function getInstance():ApplicationFacade {			if(instance == null) {				instance = new ApplicationFacade();			}			return instance as ApplicationFacade;		}				override protected function initializeController():void {			super.initializeController();			this.registerCommand(STARTUP, StartupCommand);			this.registerCommand(FacebookProxy.LOGIN, FacebookLoginCommand);			this.registerCommand(FacebookProxy.INIT, FacebookInitCommand);			this.registerCommand(INSERT_SCORE, ScoreCommand);		}				public function startup(cocaCola:CocaCola) {			this.sendNotification(STARTUP, cocaCola);		}			}}