package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class MainStage extends MovieClip
	{
		private var movement:MovementManager;
		private var nun:Teacher;
		private var verifier:Teacher;
		//private var deskSetter:DeskManager;
		
		private var desk1:Desk;
		private var desk2:Desk;
		private var desk3:Desk;
		private var desk4:Desk;
		private var desk5:Desk;
		private var desk6:Desk;
		
		public function MainStage()
		{
			//These go into the DeskManager Class, still not working from there
			//From the MainStage it works fine, I'll leave them here until we find out
			//what's happening in that other class
			
			this.desk1 = new Desk();
			this.addChild(this.desk1);
			
			this.desk2 = new Desk();
			this.addChild(this.desk2);
			
			this.desk3 = new Desk();
			this.addChild(this.desk3);
			
			this.desk4 = new Desk();
			this.addChild(this.desk4);
			
			this.desk5 = new Desk();
			this.addChild(this.desk5);
			
			this.desk6 = new Desk();
			this.addChild(this.desk6);
			
			//End of desks
			
		
			this.nun = new Teacher();
			this.addChild(this.nun);
			
			this.verifier = new Teacher();
			this.addChild(this.verifier);
			this.verifier.visible = false;
			
			this.nun.x = 520;
			this.nun.y = 130;
			
			this.verifier.x = 520;
			this.verifier.y = 130;
			
			//this.deskSetter = new DeskManager();
			
			SetDesks();
			
			this.movement = new MovementManager(this.nun, this.verifier);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.movement.handleKeyDown);
		}
		
		//This fuction is also from the DeskManager
		//Its here to make the desk appear in position
		//from the MainStage instead until the DeskManager is working correctly
		public function SetDesks()
		{
			
			this.desk1.x = 260;
			this.desk1.y = 260;
			
			
			this.desk2.x = 520;
			this.desk2.y = 260;
			
			
			this.desk3.x = 780;
			this.desk3.y = 260;
			
			
			this.desk4.x = 260;
			this.desk4.y = 520;
			
			
			this.desk5.x = 520;
			this.desk5.y = 520;
			
			
			this.desk6.x = 780;
			this.desk6.y = 520;
		}
	}
}