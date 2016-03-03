package  {
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.*;
	import fl.motion.*;
	import flash.utils.getTimer;
	import flash.display.Shape;
	import flash.utils.Timer;
	
	/*
	
	The purpose of Main will be to effectively manage the state of the game itself.
	It will also load the assets needed that already aren't integrated as animations.
	
	
	 */
	
	public class StateManager extends MovieClip
	{
		
		public const START = 256, PRE_GAME = 257, INGAME = 258, PAUSE = 259,
							RESULT_FAIL = 271, RESULT_PASS = 272, GAME_OVER =280, INSTRUCTIONS = 290;
		
		private const RED:uint = 0xFF0000, GREEN:uint = 0x00FF00, BLUE:uint = 0x0000FF;
		private const F_X = 738, F_Y = 50, F_WIDTH:Number = 288, F_HEIGHT:Number = 20;
				
		private var gState:int, score:int, chainTimer:int, chainLength:int, deltaTime:Number, prev:Number;
		private var fillBar:Shape = new Shape();
		private var strikeCount:int, currentLevel;
		
		private var results:ResultsManager = new ResultsManager();
		
		private var chainHandler:Timer = new Timer(1000/24);
		private var keepScore:Boolean;
		
		public function StateManager() {
			// constructor code
			
			//for the purposes of the dempo presentation, it'll be 100 going down
			//the main version will start at 0.
			this.resetGame();
			currentLevel = -1;
			
			//this.addEventListener(Event.ENTER_FRAME, update);
			chainHandler.addEventListener(TimerEvent.TIMER, this.handleChainTimer);
			chainHandler.start();
			
			changeBar();
			//stage.addChild(fillBar);.
			
			trace("Added Event Listeners");			
		}
		
		public function getRM()
		{
			return this.results;
		}
		
		public function setLevel(l:int)
		{
			this.currentLevel = l;
		}
		
		public function incLevel()
		{
			this.currentLevel++;
		}
		
		public function getLevel()
		{
			return this.currentLevel;
		}
		
		public function getGameState():int
		{
			return gState;
		}
				
		private function get_results()
		{
			//stage.gotoAndPlay("");
			
			if(score >= 30 + (currentLevel+1)*5 || (score <= 30 + (currentLevel+1)*5 && strikeCount < 3))
			{
				//switchState(RESULT_PASS);
			}
			else
			{
				//switchState(RESULT_FAIL);
			}
		}
		
		/*private function update(ev:Event)
		{
			deltaTime = (getTimer() - prev) * .001;
			deltaTime = (deltaTime > 3 ? 3 : (deltaTime < (1/24) ? 1/24 : deltaTime));//cap deltaTime at 3 seconds.

			prev = getTimer();

			chainTimer -= deltaTime;
			
			if(chainTimer < 0)
			{
				chainTimer = 0;
				chainLength = 0;
			}
			//trace(score);
		}*/
		
		private function handleChainTimer(t:TimerEvent)
		{
			//trace("Chain Timer Call");
			
			chainTimer -= Math.floor(1000/24);
			
			if(chainTimer < 0)
			{
				chainTimer = 0;
				chainLength = 0;
				//trace("Chain Reset");
			}
		}
		
		
		public function getBar():Shape
		{
			return fillBar;
		}
		
		public function switchState(nextState:int)
		{
			switch(gState)
			{
				case PRE_GAME:
				{
					score = 0;
					
					//we are transitioning to the main game itself.
					
					
					break;
				}
			}
			
			switch(nextState)
			{
				
			}
			
			gState = nextState;
		}
		
		private function changeBar():void
		{
			//var color = (score >= 100 || isPerfect ? (GREEN | BLUE) : Color.interpolateColor(GREEN, RED, 1 - (score/100)));
			
			var color:uint, arg1:uint, arg2:uint, ratio:Number;
			
			/*if(score >= 100 || strikeCount < 3)
			{
				color = GREEN|BLUE;
			}
			else if (score >= 50 + (currentLevel)*5) //max is 75
			{
				color = GREEN;
			}
			else if (score >= 30 + (currentLevel+1)*5) //max is 60
			{				
				color = GREEN|RED;
			}
			else
			{
				color = RED;				
			}			*/
			
			if(score >= 100 || strikeCount < 3)
			{
				color = GREEN|BLUE;
			}
			else if (score >= 80) //max is 75
			{
				color = GREEN;
			}
			else if (score >= 60) //max is 60
			{				
				color = GREEN|RED;
			}
			else
			{
				color = RED;				
			}			
			
			fillBar.graphics.clear();
			fillBar.graphics.beginFill(color);
			fillBar.graphics.drawRect(F_X, F_Y, F_WIDTH *(score >= 100? 1 : score / 100), F_HEIGHT);
			fillBar.graphics.endFill();
		}
		
		public function resetGame()
		{
			strikeCount = 0;
			score = 0;
			keepScore = true;
			chainHandler.start();
		}
		
		public function stopGame(e:Event = null)
		{			
			trace("Game Over Hi");
			
			keepScore = false;
			chainHandler.stop();
			
			this.results.ShowResults(this.score);
		}
		
		public function addScore(ev:Event):void
		{
			if(!keepScore)
				return;
			//trace(ev + " Added");
			chainLength++;
			chainTimer = (11 - (chainLength > 10 ? 10 : chainLength)) * 200;
			trace("Added");
			
			if(chainLength > 6 && chainLength%6 == 0)
			{
				strikeCount = (strikeCount > 0 ? strikeCount-1: 0);
			}
						
			if(score >= 100)
			{
				score += 1 * (int)(chainLength/10);
			}
			else
			{
				score+= 10 - (int)(chainLength > 6 ? 3 : chainLength/2);
				score = (score >= 100 ? 100 : score);
			}
			changeBar();
		}
		
		public function subScore(ev:Event):void
		{
			if(!keepScore)
				return;
			trace("Subbed");
			
			score -= (4 + 2*(int)((this.currentLevel/2) + 1));
			penalize();
		}
		
		private function penalize():void
		{			
			chainLength = chainTimer = 0;
			
			strikeCount = (strikeCount > 3? 3: strikeCount+1);			
									
			score = (score <= 0 ? 0 : score);
			changeBar();			
		}
		
		public function subScore2(ev:Event)
		{						
			if(!keepScore)
				return;
			score -= 10;
			penalize();
		}
	}
	
}
