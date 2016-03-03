package 
{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;

	public class TestMain extends MovieClip
	{
		public function TestMain()
		{
			// constructor code
			var myPlayer:Player = new Player();
			var myDetector:Detector = new Detector();
			
			var myManager = new LevelManager();
			var myState:StateManager = new StateManager();
			
			myManager.populate(0,stage.width,stage.height);
			
			addChild(myPlayer);
			myPlayer.attachDetector(myDetector);
			
			this.addEventListener("FAILURE", myState.subScore);
			//myState.addEventListener("FAILURE", myState.subScore);						
			
			var rects: Vector.<Rectangle> = new Vector.<Rectangle>();
			var temp: Desk;
			
			for(var i:int = 0; i < myManager.getDesks().length; i++)
			{
				temp = myManager.getDesks()[i];
				rects.push(new Rectangle(temp.x, temp.y, temp.width, temp.height));
				addChild(temp);				
			}
			
			myPlayer.setLocations(rects);
			//stage.focus = myPlayer;
		}
	}

}