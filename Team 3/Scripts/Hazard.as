package  {
	
	import flash.events.*;
	import flash.utils.*;
	import flash.display.MovieClip;
	
	public class Hazard extends MovieClip{

		public static const TYPE_NONE: int = -1, TYPE_BANANA: int = 0, TYPE_GUM: int = 1, TYPE_SMOKE: int = 2, N_TYPES: int = 3;
		public static const STATE_IDLE = 0, STATE_ACTIVE = 1, STATE_FADE =2;
		
		private const FADE:String = "Fade",  END:String = "End";
		
		private var type: int, animState:int, activeTimer:Timer, fadeTimer:Timer;
		private var labels:Array = new Array("clear", "banana", "gum", "smoke");
		
		//collision detection stuff 
		private var player:MovementManager;
		private var index_x:int, index_y:int;

		public function Hazard(ix:int, iy:int) {
			// constructor code
			type = TYPE_NONE;
			animState = STATE_IDLE
			
			activeTimer = new Timer(1875,1);
			fadeTimer = new Timer(1,12);
			
			var tmp: String;
			//trace("hi")
			
			for(var i:int = 0; i < 2*(N_TYPES+1); i++)
			{				
				if(i%(N_TYPES+1) == 0)
				{
					continue;
				}
				else
				{
					tmp = labels[i%(N_TYPES+1)] + FADE + ( i > N_TYPES ? END : "");
					labels.push(tmp);
				}
			}
			
			this.index_x = ix;
			this.index_y = iy;
			this.stop();
			//trace(labels);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, Update);
			activeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,deactivate);
		}
		
		public function getState()
		{
			return this.animState;
		}
		
		public function onAddedToStage(ev:Event)
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleInput);
			stage.addEventListener("GAME_END",deactivateTrigger);
		}
		
		public function onRemovedFromStage(e:Event)
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleInput);
			stage.removeEventListener("GAME_END",deactivateTrigger);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function attachPlayer(p:MovementManager)
		{
			this.player = p;
		}
		
		public function getX()
		{
			return this.index_x;
		}
		
		public function getY()
		{
			return this.index_y;
		}
		
		
		public function Update(d:Number):void
		{
			if(this.animState == STATE_FADE && this.currentFrameLabel == labels[type]+FADE+END)
			{
				this.reset();
				this.gotoAndStop("clear");
			}
		}
		
		
		public function handleInput(keyEvent:KeyboardEvent):void
		{
			if(animState != STATE_ACTIVE)
			{
				return;
			}
			
			trace("Hazard " + this.getX() + ", " + this.getY());
			trace("Nun " + player.getX() + ", " + player.getY());
			
			if(player.getX() == this.getX() && player.getY() == this.getY())
			{
				player.changeState(this.type);
				this.deactivateTrigger();
			}			
		}
		
		public function activate():void
		{			
			type = Math.floor(Math.random() * ((N_TYPES) - TYPE_BANANA + 1)) + TYPE_BANANA;
			
			animState = STATE_ACTIVE;
			activeTimer.start();
			
			this.gotoAndStop(labels[type]);
		}
		
		private function deactivate(t:TimerEvent)
		{
			trace("deactivate");
			animState = STATE_FADE;
			
			try
			{
				this.gotoAndPlay(labels[type]+FADE);
			}
			catch(ae:ArgumentError)
			{
				this.gotoAndPlay("clear");
			}
		}
		
		private function reset()
		{
			this.type = TYPE_NONE;
			activeTimer.stop();
		}
		
		private function deactivateTrigger(e:Event = null):void
		{
			animState = STATE_IDLE;
			this.gotoAndStop("clear");
			this.reset();
		}
	}
	
}
