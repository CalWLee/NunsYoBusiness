package 
{
	//this is an updated version on the one I already sent
	//in this one the nun can hit the student only if she is facing them
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.*;
	import fl.motion.easing.Back;
	import flash.net.*;
	import flash.media.*;

	public class MovementManager extends EventDispatcher
	{
		public static const STATE_INACTIVE:int = -1, STATE_NORM:int = 0, STATE_SLIP:int = 1, STATE_GUM:int = 2, STATE_SMOKE:int = 3;
		private var currentState:int,lastKeyPressed:uint;

		private var targetObject:Teacher;
		private var targetVerifier:MovieClip;
		private var gridX:Array,gridY:Array,index_x:int,index_y:int;
		private var moveDistance:Point,mapData:Rectangle;
		private var desks: Vector.<Desk> = new Vector.<Desk>();

		private var state_timer:Timer;
		private var aboveSwap:int,belowSwap:int;

		private var soundVector:Vector.<Sound> = new Vector.<Sound>();

		//private var Hit:Boolean = false;

		//I only used this as reference, the actual array is never used
		/*private var posX:Array = new Array;
		private var posY:Array = new Array;
		
		posX[] = {130, 260, 390, 520, 650, 780, 910};
		posY[] = {130, 260, 390, 520, 650};*/

		public function MovementManager(targetObject:Teacher, targetVerifier:MovieClip, gx:Array, gy:Array)
		{
			this.targetObject = targetObject;
			this.targetVerifier = targetVerifier;

			this.setGrid(gx,gy);

			//trace(gridX[index_x] + ", " + gridY[index_y]);
			currentState = STATE_INACTIVE;

			state_timer = new Timer(1);
			state_timer.addEventListener(TimerEvent.TIMER_COMPLETE, activate);
		}

		public function setGrid(gx:Array, gy:Array)
		{
			this.gridX = gx;
			this.gridY = gy;

			this.initLoc();
		}

		private function initLoc():void
		{
			index_x = gridX.length / 2;
			index_y = 0;

			this.targetVerifier.x = this.targetObject.x = gridX[index_x];
			this.targetVerifier.y = this.targetObject.y = gridY[index_y];
		}

		public function changeState(s:int)
		{
			this.currentState = s;

			switch (s)
			{
				case STATE_GUM :
					{
						trace("Stepped on Gum");


						LevelManager.playSound("Corrected_Sounds/Gum_Squish.mp3");


						state_timer.repeatCount = 180;
						break;




					};
				case STATE_SLIP :
					{
						trace("Slipped on a Banana");
						LevelManager.playSound("Corrected_Sounds/Banana_Slip.mp3");
						var nuX = this.getX(),nuY = this.getY();

						switch (lastKeyPressed)
						{
							case Keyboard.UP :
								{
									nuY = 0;
									break;




								};
							case Keyboard.DOWN :
								{
									nuY = gridY.length - 1;
									break;




								};
							case Keyboard.LEFT :
								{
									nuX = 0;
									break;




								};
							case Keyboard.RIGHT :
								{
									nuX = gridX.length - 1;
									break;




							}
						};

						state_timer.repeatCount = 120 + 10*Math.abs(index_x - nuX) + 10*Math.abs(index_y - nuY);

						index_x = nuX;
						index_y = nuY;

						this.targetObject.x = this.gridX[index_x];
						this.targetObject.y = this.gridY[index_y];

						this.syncLocations();

						break;




					};
				case STATE_SMOKE :
					{
						trace("Breathed a Bomb");
						LevelManager.playSound("Corrected_Sounds/Smoke_Bomb.mp3");
						state_timer.repeatCount = 250;
						break;




					};
				default :
					{
						state_timer.repeatCount = -1;
						break;




				}
			};

			if (state_timer.repeatCount > 0)
			{
				state_timer.start();
			}
		}

		private function syncLocations():void
		{
			this.targetVerifier.x = this.targetObject.x;
			this.targetVerifier.y = this.targetObject.y;
		}

		public function setIndices(i:int, j:int)
		{
			index_x = i;
			index_y = j;
		}

		public function activate(e:Event = null):void
		{
			this.currentState = STATE_NORM;
			targetObject.gotoAndStop("Front");
		}

		public function deactivate(e:Event = null):void
		{
			this.currentState = STATE_INACTIVE;
			targetObject.gotoAndStop("Front");
		}

		public function handleKeyDown(keyEvent:KeyboardEvent):void
		{
			//var Hit:Boolean = false;
			trace(targetObject.isAttack());
			this.lastKeyPressed = keyEvent.keyCode;

			if (this.currentState == STATE_INACTIVE || this.currentState == STATE_SLIP || targetObject.isAttack())
			{
				return;
			}
			else if (this.currentState == STATE_GUM)
			{
				if (state_timer.currentCount % 6 != 0)
				{
					targetObject.rotate(this.lastKeyPressed);
					return;
				}
			}
			else if (this.currentState == STATE_SMOKE)
			{
				switch (keyEvent.keyCode)
				{
					case Keyboard.UP :
						{
							this.lastKeyPressed = Keyboard.DOWN;
							break;




						};
					case Keyboard.LEFT :
						{
							this.lastKeyPressed = Keyboard.RIGHT;
							break;




						};
					case Keyboard.DOWN :
						{
							this.lastKeyPressed = Keyboard.UP;
							break;




						};
					case Keyboard.RIGHT :
						{
							this.lastKeyPressed = Keyboard.LEFT;
							break;




					}
				};
				targetObject.rotate(this.lastKeyPressed);
			}
			else
			{
				targetObject.rotate(this.lastKeyPressed);
			}

			if (this.lastKeyPressed == Keyboard.UP && index_y > 0)
			{
				this.syncLocations();

				//this.targetVerifier.modY(-moveDistance.y);
				this.targetVerifier.y = gridY[index_y - 1];

				if (MoveAvailable(targetVerifier) != false)
				{
					this.targetObject.y = gridY[--index_y];
				}
				else
				{
					//this.targetVerifier.modY(moveDistance);
					//Hit = true;
				}

			}
			else if (this.lastKeyPressed == Keyboard.DOWN && index_y < gridY.length-1)
			{
				this.syncLocations();
				//this.targetVerifier.modY(moveDistance.y);

				this.targetVerifier.y = gridY[index_y + 1];

				if (MoveAvailable(targetVerifier) != false)
				{
					//this.targetObject.modY(moveDistance.y); 
					this.targetObject.y = gridY[++index_y];
				}
				else
				{
					//this.targetVerifier.modY(-moveDistance);
					//Hit = true;
				}
			}
			else if (this.lastKeyPressed == Keyboard.LEFT && index_x > 0)
			{
				this.syncLocations();
				/*
				this.targetVerifier.modX(-moveDistance.x);
				if(MoveAvailable(targetVerifier) != false)
				{
				this.targetObject.modX(-moveDistance.x); 
				}
				else
				{
				//this.targetVerifier.modX(moveDistance);
				//Hit = true;
				}*/
				this.targetVerifier.x = gridX[index_x - 1];

				if (MoveAvailable(targetVerifier) != false)
				{
					//this.targetObject.modY(moveDistance.y); 
					this.targetObject.x = gridX[--index_x];
				}
			}
			else if (this.lastKeyPressed == Keyboard.RIGHT && index_x < gridX.length-1)
			{
				this.syncLocations();
				/*
				this.targetVerifier.modX(moveDistance.x);
				if(MoveAvailable(targetVerifier) != false)
				{
				this.targetObject.modX(moveDistance.x); 
				}
				else
				{
				//this.targetVerifier.modX(-moveDistance);
				//Hit = true;
				}*/
				this.targetVerifier.x = gridX[index_x + 1];

				if (MoveAvailable(targetVerifier) != false)
				{
					//this.targetObject.modY(moveDistance.y); 
					this.targetObject.x = gridX[++index_x];
				}
			}
			else if (keyEvent.keyCode == Keyboard.SPACE)
			{
				if (MoveAvailable(targetVerifier, true) == false)
				{
					this.targetObject.attack();
					LevelManager.playSound("Corrected_Sounds/Nun_Slap.mp3");
					this.targetVerifier.x = this.targetObject.x;
					this.targetVerifier.y = this.targetObject.y;
				}
				else
				{
					//trace("Miss");
				}
			}

			//Code to deal with the depth problem

			//trace("Nun Loc: " + this.targetObject.x + ", " + this.targetObject.y);
			//trace("Indexes: " + index_x + ", " + index_y);
		}

		public function setLocations(studentMap:Vector.<Desk>):Boolean
		{
			desks = studentMap;
			if (desks == null)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		public function MoveAvailable(target:MovieClip, isSpacePressed:Boolean = false):Boolean
		{
			var index:Number = MovieClip(this.targetObject.root).getChildIndex(this.targetObject),below:Number,above:Number;

			var tx:Number;

			if (this.lastKeyPressed == Keyboard.LEFT)
			{
				tx = (index_x - 1 < 0? -1 : gridX[index_x-1]);
			}
			else if (this.lastKeyPressed == Keyboard.RIGHT)
			{
				tx = (index_x + 1 > gridX.length-1 ? -1 :gridX[index_x+1]);
			}

			for (var i:int; i < desks.length; i++)
			{
				if (desks[i].x == tx)
				{
					trace("Index: " + index);
					/*trace("Desk Y: " + desks[i].y + " Grid Y Above: " + gridY[(index_y-1 < 0 ? 0 : index_y-1)]
					+ " Grid Y Below: " + gridY[(index_y+1 > gridY.length -1 ? gridY.length-1 : index_y+1)]);
					*/
					if (index_y+1 <= gridY.length - 1 && desks[i].y == gridY[index_y+1])
					{
						below = MovieClip(this.targetObject.root).getChildIndex(desks[i]);
						trace("Below: " + below);

						if (below < index)
						{
							MovieClip(this.targetObject.root).swapChildren(desks[i], this.targetObject);
						}
					}
					else if (index_y-1 >= 0 && desks[i].y == gridY[index_y-1])
					{
						above = MovieClip(this.targetObject.root).getChildIndex(desks[i]);
						trace("Above: " + above);

						if (above > index)
						{
							MovieClip(this.targetObject.root).swapChildren(desks[i], this.targetObject);
						}
					}
				}
				//MovieClip(this.targetObject.root).swapChildren(desks[i],this.targetObject);

				if (target.x == desks[i].x && target.y == desks[i].y)
				{
					if (isSpacePressed)
					{
						//trace("Press Space");
						//this.dispatchEvent(new CollisionEvent(CollisionEvent.COLLIDE, locs[i]));
						desks[i].hitReact();
						//this.dispatchEvent(new Event("BEHAVE",true));
					}
					return false;
				}
			}
			return true;
		}

		public function getY():int
		{
			return this.index_y;
		}

		public function getX():int
		{
			return this.index_x;
		}

		/*
		public function MoveAvailable(target:MovieClip):Boolean
		{
		var canMove:Boolean;
		
		if(target.x == 260 && target.y == 260)
		{
		canMove = false;
		}
		
		else if(target.x == 520 && target.y == 260)
		{
		canMove = false;
		}
		
		else if(target.x == 780 && target.y == 260)
		{
		canMove = false;
		}
		
		else if(target.x ==260 && target.y == 520)
		{
		canMove = false;
		}
		
		else if(target.x == 520 && target.y == 520)
		{
		canMove = false;
		}
		
		else if(target.x == 780 && target.y == 520)
		{
		canMove = false;
		}
		
		else
		{
		canMove = true;
		}
		
		return canMove;
		}
		*/
	}
}