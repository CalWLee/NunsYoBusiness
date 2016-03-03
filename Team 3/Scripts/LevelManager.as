package 
{
	import flash.events.Event;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.events.TimerEvent;
	import flash.net.*;
	import flash.media.*;

	public class LevelManager extends MovieClip
	{
		//private variables
		private var timer, cLevel, cooldown, isActive, cell_w, cell_h;
		private var deltaTime:Number,prev:Number, rows:Number, cols:Number;
		private var kids:Vector.<Desk> = new Vector.<Desk>(), readyKids:Vector.<int> = new Vector.<int>(), hazards: Vector.<Hazard> = new Vector.<Hazard>();
		private var levelArr = new Array(6,8,9,12,16);
		private var mapArr = new Array(), xArr = new Array(), yArr = new Array();
		private var timerArr = new Array(levelArr.length);
		
		//miscellaneous constants
		private const DESK_CONST = 1200;
		private const HAZARD_CONST = 1500;
		
		//attaching the player to share in the updating all at once. Just in case...
		private var player:MovementManager;
		
		private var clock:TimerManager = new TimerManager();
		private var deskTimer:Timer = new Timer(300);
		private var hazardTimer:Timer = new Timer(HAZARD_CONST);				
		
		//lookup table stuff
		public static const SPACE_BLANK = 0, SPACE_DESK = 1, SPACE_HAZARD = 2;
		private var lookupTable:Array = new Array(xArr.length);
		
		//looping sound variables
		//private var 
		
		public function LevelManager()
		{
			// constructor code
			this.addEventListener(Event.ENTER_FRAME, update);
			hazardTimer.addEventListener(TimerEvent.TIMER, this.spawnHazards);
			//this.addEventListener(Event.DEACTIVATE, pauseLevel);
			//this.addEventListener(Event.ACTIVATE, resumeLevel);
			
			//inititalize the timers for each level;
			for(var i:int = 0; i < timerArr.length; i++)
			{
				timerArr[i] = 60 + (i > 3? 30: (levelArr[i] - levelArr[0]) * 5);
			}
			
			prev = getTimer();
			cLevel = 0;
			cooldown = 0;
			
			isActive = false;
		}
		
		public function start(e:Event = null)
		{
			trace("Start Game");
			this.isActive = true;
			player.activate();
			clock.startGame();			
		}
		
		public function end(e:Event)
		{
			this.isActive = false;
			player.deactivate();
			
			trace("Game Over");
		}
		
		public function attachClock(tm:TimerManager)
		{
			this.clock = tm;
		}
		
		public function getClock():TimerManager
		{
			return this.clock;
		}
		
		public function attachPlayer(p:MovementManager):void	
		{
			this.player = p;
			this.player.setLocations(kids);
			
			for (var i:int = 0; i < hazards.length; i++)
			{
				hazards[i].attachPlayer(p);
			}
		}
		
		public function pauseLevel():void
		{
			isActive = false;
		}
		
		public function resumeLevel():void
		{
			isActive = true;
		}
		
		public function getRows():Number
		{
			return rows;
		}
		
		public function getCols():Number
		{
			return cols;
		}
		
		public function getColArray():Array
		{
			return xArr;
		}

		public function getRowArray():Array
		{
			return yArr;
		}

		//Basically, it resets the level to fit new conditions.
		public function populate(n:int, stage_w:Number=550, stage_h:Number = 400, stage_x = 0, stage_y = 0):void
		{			
			var h:int, i:int, j:int;
			trace("Populating2");
			
			//cap the array index
			n = (n >= levelArr.length ? levelArr.length - 1 : n);
			
			//figure out how many rows and columns to distrubte in			
			//divide the number to arrange by rows and colums
			if(levelArr[n] % 3 == 0)
			{
				rows = levelArr[n]/3;
			}
			else
			{
				rows = levelArr[n]/4;
			}			
			cols = levelArr[n] / rows;
			
			//2(actual number) + 1
			rows = (2*rows)+1;
			cols = (2*cols)+1;
			
			//used for image scaling AND for balancing purposes (especially hazard spawning)
			cell_w = stage_w/cols;
			cell_h = stage_h/rows;
			
			//2 arrays of all possible points for areas.
			yArr = new Array(rows);
			xArr = new Array(cols);

			/*//clear the stage first
			for (h = 0; h < kids.length; h++)
			{
				removeChild(kids[h]);
			}
			
			for (h = 0; h < hazards.length; h++)
			{
				removeChild(hazards[h]);
			}*/
			
			//fill the vector with as many kids as the level needs
			while (kids.length < levelArr[n])
			{
				kids.push(new Desk());
			}
			
			trace("Rows: "+ rows  + ", Columns: " + cols);
			
			/*
				Store the locations in each part of the array.
			*/
			for(i = 0; i < rows; i++)
			{
				yArr[i] = i*stage_h/rows + stage_y;// + ((stage_h/rows)/2);
				trace(yArr[i]);
			}
			
			for(j= 0; j < cols; j++)
			{
				xArr[j] = j*stage_w/cols + stage_x;// + ((stage_w/cols)/2);
				trace(xArr[j]);
			}
			
			
			//initialize and then reposition them.
			for (var k:int = 0; k < kids.length; k++)
			{
				kids[k].reset();				
				//addChild(kids[i]);
			
				//determine their positions
				kids[k].x = xArr[(k%(cols >> 1))*2+1];
				kids[k].y = yArr[2*(int)(k/((cols)>>1)) + 1];
				
				trace(kids[k].x  + ", " + kids[k].y);
			}
	
			for (i = 0; i < xArr.length; i++)
			{
				for(j = (i+1)%2; j < yArr.length; j+=2)
				{
					hazards.push(new Hazard(i,j));
					hazards[hazards.length-1].x = xArr[i];// + (this.getCellWidth()/2) - hazards[hazards.length-1].width;
					hazards[hazards.length-1].y = yArr[j];// + (this.getCellHeight()/2) - hazards[hazards.length-1].height;
				}
			}
			//trace("Number of Hazards: " + hazards.length);
			
			//Todo: create a lookup table.
			
			//finally initialize the level
			cLevel = n;
			timer = timerArr[cLevel];
			
			clock.SetTimer(timer);
			
			hazardTimer.delay = HAZARD_CONST - (cLevel*50);
			hazardTimer.start();
			
			trace("Populated");
			trace(kids.length);
		}

		public function getDesks():Vector.<Desk>
		{
			return kids;
		}
		
		public function getHazards():Vector.<Hazard>
		{
			return hazards;
		}
		
		public function getCellWidth():Number
		{
			return cell_w;
		}

		public function getCellHeight():Number
		{
			return cell_h;
		}
		
		//clears the Vector of all desks
		public function reset():void
		{
			kids = kids.splice(0,0);
			hazards = hazards.splice(0,0);
		}
		
		private function spawnHazards(t:TimerEvent)
		{
			//picking a random row/col:
			//(row/col + 2) % (the number of rows/cols - the offset).
			
			if(!clock || !this.isActive)
				return;
			
			var spawns:int, r:int, c:int, index:int;
			
			var rand_spawn:Number = Math.random()*5 + this.cLevel*(1 - (clock.getSeconds()/clock.getMaxSecs()));
			
			spawns = 1 + (int)(Math.floor(rand_spawn/4) > 2 ? 2: Math.floor(rand_spawn/4));
			
			for(var i:int = 0; i < spawns; i++)
			{				
				var min = this.getRows()/2;
				var max = hazards.length - min;
			
				/*
				r = (int) (player.getY() + 2 + Math.random()*(player.getY() + this.getRows() - 2))% this.getRows();
				c = (int) (player.getX() + 2 + Math.random()*(player.getX() + this.getCols() - 2))% this.getCols();
				
				index = (int)(c*this.getRows()/2 + (r/2)) + (c%2);
				*/
				
				//approximate the nun's location so that we can avoid it
				var exc = (int) (player.getX()*this.getRows()/2 + player.getY()/2) + player.getX()%2;
				index = Math.floor((max-min+1)*Math.random()) + min;
								
				if(index >= hazards.length || index == exc)
				{
					continue;
				}
				else if(hazards[index].getState() == Hazard.STATE_IDLE)
				{
					//trace("HI");
					hazards[index].activate();
				}
			}
			//hazardTimer.delay = HAZARD_CONST + 500*(1 - (clock.getSeconds()/clock.getMaxSecs())) + 200*Math.random() - (200 + 100*(1 - (clock.getSeconds()/clock.getMaxSecs())))*Math.random();
		}
		
		
		public static function playSound(url:String)
		{
			var sound:Sound = new Sound();
			var myChannel:SoundChannel = new SoundChannel();
			sound.load(new URLRequest(url));
			myChannel = sound.play();
		}
		
		//updates all the Desks at once.
		public function update(e:Event):void
		{			
			//trace("hi");
			
			//stop the updating if the game is in a different state.
			if(!isActive)
				return;
			
			//var kidFlag = 0, 
			var nActive = 0, i:int;
			
			readyKids.length = 0;
						
			//trace("Timer updated: " + timer);
			
			var rand: int = (int)(Math.random()*kids.length);
			
			for (i = 0; i < kids.length; i++)
			{
				if(kids[i].getState() != Desk.IDLE)
				{
					nActive++;
				}
			}
			
			if(nActive < (kids.length / 2))
			{
				for (i = 0; i < kids.length; i++)
				{
					//!kids[(i+rand)%kids.length].isReady() &&
					if(kids[(i+rand)%kids.length].isReady())
					{
						trace("hi kid");
						kids[(i+rand)%kids.length].setTimer(this.clock.getSeconds()/timerArr[cLevel], 5)
					}
					if(nActive < (kids.length / 2)) break;
				}
			}
			/*
			for (i = 0; i < kids.length; i++)
			{				
				kids[i].subCD(deltaTime);
			
				//count the kids
				if(kids[i].getState() != Desk.IDLE)
				{
					nActive++;
				}
				else if (kids[i].getCD() < 0.1)
				{
					//push the index onto the vector
					readyKids.push(i);
					kids[i].clearCD();
					
					//flag it with a bitwise OR.
					kidFlag |= 1 << i;
				}
			}
			
			for(i = 0; i < hazards.length; i++)
			{
				//update each hazard with the location of the playerr
			}
			
			if(nActive < (kids.length / 2))
			{
				trace("activating a kid");
				//we cap the number of kids active to less than the amount of kids in the class.
				var n = 1 + (Math.random()*((kids.length / 2) - nActive));
				var index:int;
				
				while(n > 0)
				{
					//random choose the index in the vector index
					index = (int)(Math.random()*readyKids.length);
					
					//trace("Chosen indexa: "+ index);
					//trace("Chosen indexb: "+ readyKids[index]);
					
					//trace(kidFlag && (1 << readyKids[index]));
					//check if we flagged the value at the chosen bit
					if((kidFlag & 1 << readyKids[index]) != 0)
					{
						//trace("activating reached");
						//deflag from the bitmask by ANDing it with the inverse of that index's bit
						kidFlag &= ~(1 << readyKids[index]);
						kids[index].activate(timer/timerArr[cLevel], (nActive+n)/10);
					}
					
					//decrement regardless in case of a failure. Worse that could happen is that no kids are activated.
					n--;
				}
			}
			*/
		}

	}

}