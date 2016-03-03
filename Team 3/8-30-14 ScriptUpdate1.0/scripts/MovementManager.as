package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class MovementManager 
	{
		private var targetObject:MovieClip;
		private var targetVerifier:MovieClip;
		
		//I only used this as reference, the actual array is never used
		/*private var posX:Array = new Array;
		private var posY:Array = new Array;

		posX[] = {130, 260, 390, 520, 650, 780, 910};
		posY[] = {130, 260, 390, 520, 650};*/
		
		public function MovementManager(targetObject:MovieClip, targetVerifier:MovieClip)
		{
			this.targetObject = targetObject;
			this.targetVerifier = targetVerifier;
			
		}
		
		public function handleKeyDown(keyEvent:KeyboardEvent):void 
		{
			
			var moveDistance:Number = 130;
			
			if (keyEvent.keyCode == Keyboard.UP && this.targetObject.y != 130) 
			{
				this.targetVerifier.modY(-moveDistance);
				if(MoveAvailable(targetVerifier) != false)
				{
					this.targetObject.modY(-moveDistance); 
				}
				else
				{
					this.targetVerifier.modY(moveDistance);
				}
		   	}
			
			else if (keyEvent.keyCode == Keyboard.DOWN && this.targetObject.y != 650) 
			{
				this.targetVerifier.modY(moveDistance);
				if(MoveAvailable(targetVerifier) != false)
				{
					this.targetObject.modY(moveDistance); 
				}
				else
				{
					this.targetVerifier.modY(-moveDistance);
				}
			}
			
			else if (keyEvent.keyCode == Keyboard.LEFT && this.targetObject.x != 130) 
			{ 
				this.targetVerifier.modX(-moveDistance);
				if(MoveAvailable(targetVerifier) != false)
				{
					this.targetObject.modX(-moveDistance); 
				}
				else
				{
					this.targetVerifier.modX(moveDistance);
				}
			}
			
			else if (keyEvent.keyCode == Keyboard.RIGHT && this.targetObject.x != 910) 
			{ 
				this.targetVerifier.modX(moveDistance);
				if(MoveAvailable(targetVerifier) != false)
				{
					this.targetObject.modX(moveDistance); 
				}
				else
				{
					this.targetVerifier.modX(-moveDistance);
				}
			}
			
		}
		
		private function MoveAvailable(target:MovieClip):Boolean
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
	}
}

