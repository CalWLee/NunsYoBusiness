package
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	public class Desk extends MovieClip
	{
		//private var jobTimer; //timer used for each kid to cause trouble. Reset to another 1000.
		private var cdTimer:Timer;
		private var cState:int;
		private var jobTimer:Timer;
		private var activations: int;
		private var hairArray:Array = new Array("Brunette","Blonde","RedHeaded");
		private var hairColor:String;
		
		public static const IDLE = 30;
		public static const ACTIVE = 31;
		public static const RECOVERY = 32;
		public static const HIT_REC = 34;
		public static const READY = 35;

		public function Desk() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);	
			
			cdTimer = new Timer(1200 + 1800*Math.random(),1);
			cdTimer.addEventListener(TimerEvent.TIMER, activate);			
			
			
			jobTimer = new Timer(2000 - 1000*Math.random(),1);			
			jobTimer.addEventListener(TimerEvent.TIMER, deactivate);
			
			cState = IDLE;
			this.stop();
			
			var index = (int)(Math.floor(hairArray.length*Math.random()));
			trace(index);
			hairColor = hairArray[index];
		}
		
		public function onAddedToStage(ev:Event)
		{
			activations = 0;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			stage.addEventListener("GAME_END",this.reset);
			//stage.addEventListener(CollisionEvent.COLLIDE,hitReact);
			//stage.addEventListener("BEHAVE",hitReact);
		}
		
		public function onRemovedFromStage(e:Event)
		{
			var index = (int)(Math.floor(hairArray.length*Math.random()));
			trace(index);
			hairColor = hairArray[index];
			
			stage.removeEventListener("GAME_END",this.reset);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function onGameEnd(e:Event)
		{
			stage.removeChild(this);
		}
		
		//get the student's current state (Is it misbehaving? Is it sitting quietly??)
		public function getState():int
		{
			return cState;
		}
		
		/*start location functions*/
		public function getX():Number
		{
			return this.x;
		}
		
		public function getY():Number
		{
			return this.y;
		}
		
		public function getCenterX():Number
		{
			return this.width/2 + this.x;
		}
		
		public function getCenterY():Number
		{
			return this.height/2 + this.y;
		}
		
		public function getBox():Rectangle
		{
			return new Rectangle(this.x, this.y, this.width, this.height);
		}
		/*end location methods*/	
		
		/*start state change functions*/
			
		public function isReady()
		{
			return !cdTimer.running;
		}
		
		public function setTimer(ratio:Number, currentLev:Number)
		{			
			activations = (activations > 20 ? 10 - 2*currentLev : activations);
			
			jobTimer.delay = 1500 + ((activations > 10 ? -10 : -activations)*100) + 0.5*((1-ratio)*((currentLev+1)*300) + (500*Math.random()));
			cdTimer.delay = (3000 + (200*(activations>=10? 10: activations)) + 3000*Math.random()) - (ratio*(currentLev*500));
			
			//trace(name +": "+jobTimer.delay);
			cdTimer.start();
		}
		
		public function activate(t:TimerEvent)
		{
			//cdTimer.stop();		//stop cooldown
			jobTimer.start();	//start acting
			
			activations++;
			
			this.gotoAndPlay("act"+this.hairColor);
			cState = ACTIVE;
		}
		
		//ratio = in-game timer divided the seconds allotted for the round.
		//offset = additional seconds to add 
		/*
		public function activate(ratio:Number, currentLev:Number, offset:Number = 0):void
		{
			//trace("activated");
			jobTimer = 2 - (ratio + (currentLev*.1)) + offset;
			this.gotoAndPlay("act");
			cState = ACTIVE;
		}
		*/
		private function deactivate(t:TimerEvent):void
		{
			//trace("deactivating, recovering");
			this.gotoAndPlay("recovery"+this.hairColor);
			cState = RECOVERY;
			
			activations = (activations - 2 <= 0 ? 0 : activations - 2);			
			
			jobTimer.reset();
			//this.addCD(3 + Math.random());
		}
		
		public function reset(e:Event = null):void
		{
			//trace("back to idle");
			//this.stop();
			jobTimer.reset();
			cdTimer.reset();
			this.gotoAndStop("idle"+this.hairColor);
			//cdTimer.start();
			cState = IDLE;
		}
		
		public function hitReact():void
		{			
			
			if(cState == ACTIVE || (cState == RECOVERY && !currentFrameLabel == "recoveryEnd"+this.hairColor))
			{
				this.dispatchEvent(new Event("SUCCESS",true));
			}
			else if (cState == IDLE)
			{				
				this.dispatchEvent(new Event("FAILURE2",true));
			}
			else
			{
				return;
			}
			
			cState = HIT_REC;
			jobTimer.reset();
			
			this.gotoAndPlay("react"+this.hairColor);
		}
		/*end state change functions*/
		
		/*
		public function addCD(cd:Number):void
		{
			cdTimer+=cd;
		}
		
		public function subCD(cd:Number):void
		{
			cdTimer-=cd;
			trace("Cooldown of " + this.name + ": " + cdTimer);
		}
		
		public function getCD():Number
		{
			return cdTimer;
		}
		
		public function clearCD():void
		{
			cdTimer = 0;
		}
		*/
		//public function Update(dTime:Number):void{
		public function Update(e:Event):void
		{
			//jobTimer = (jobTimer - dTime < 0 ? 0 : jobTimer - dTime);
			//cdTimer = (cdTimer - dTime < 0 ? 0 : cdTimer - dTime);
			
			/**/
			
			if(cdTimer.running)
			{
				//trace("Cooldown");
			}
			
			if(cState==ACTIVE)
			{
				if(currentFrameLabel == "actEnd"+this.hairColor)
				{
					this.gotoAndPlay("act"+this.hairColor);
				}
			}
			else
			{
				if((cState == RECOVERY && currentFrameLabel == "recoveryEnd"+this.hairColor) //recovery animation is over, return to idle
						|| (cState == HIT_REC && currentFrameLabel == "reactEnd"+this.hairColor) )
				{
					if(cState == RECOVERY)
					{
						//trace("dispatch");
						this.dispatchEvent(new Event("FAILURE",true));
					}
					
					this.reset();
				}
				else if(currentFrameLabel == "idleEnd"+this.hairColor)
				{
					this.gotoAndStop("idle"+this.hairColor);
				}
			}
		}
	}
}