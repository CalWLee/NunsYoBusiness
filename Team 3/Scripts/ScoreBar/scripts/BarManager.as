package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class BarManager 
	{
		private var targetObject:MovieClip;
		
		public function BarManager(targetObject:MovieClip)
		{
			this.targetObject = targetObject; //the target is actually the bar inside the ruler symbol
		}
		
		public function changeLength(key:KeyboardEvent):void //In here is where we will put into account the points gained or lost
		{
			if(key.keyCode == Keyboard.SPACE) 
			{
				//trace(this.targetObject.width);
				this.targetObject.bar.width -= 10; 
				//in the .fla file the reference point was moved from the center of the bar to the upper left
				//this was done so that the bar only shrinks from one side and not from the center
			}
			else if(key.keyCode == Keyboard.A)
			{
				//trace(this.targetObject.width);
				this.targetObject.bar.width += 10;
			
			}
		}
	}
}