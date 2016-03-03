package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class DeskManager extends MovieClip
	{
		private var desk1:Desk;
		private var desk2:Desk;
		private var desk3:Desk;
		private var desk4:Desk;
		private var desk5:Desk;
		private var desk6:Desk;
		
		public function DeskManager()
		{
			
		}
		
		public function SetDesks()
		{
			
			this.desk1 = new Desk();
			this.addChild(this.desk1);
			this.desk1.x = 260;
			this.desk1.y = 260;
			
			this.desk2 = new Desk();
			this.addChild(this.desk2);
			this.desk2.x = 520;
			this.desk2.y = 260;
			
			this.desk3 = new Desk();
			this.addChild(this.desk3);
			this.desk3.x = 780;
			this.desk3.y = 260;
			
			this.desk4 = new Desk();
			this.addChild(this.desk4);
			this.desk4.x = 260;
			this.desk4.y = 520;
			
			this.desk5 = new Desk();
			this.addChild(this.desk5);
			this.desk5.x = 520;
			this.desk5.y = 520;
			
			this.desk6 = new Desk();
			this.addChild(this.desk6);
			this.desk6.x = 780;
			this.desk6.y = 520;
		}
	}
}