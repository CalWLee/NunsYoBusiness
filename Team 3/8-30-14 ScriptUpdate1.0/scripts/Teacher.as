package
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Teacher extends MovieClip
	{
		public function Teacher()
		{
			
		}
			public function modX(modifier:Number):void 
			{ 
				this.x += modifier; 
			}
			
			public function modY(modifier:Number):void 
			{ 
				this.y += modifier; 
			}
		
	}
}