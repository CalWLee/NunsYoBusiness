package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.*;
	import flash.display.SimpleButton
	import flash.display.Scene
	
	public class MainStage extends MovieClip
	{
		var strt:StartBtn;
		var once:Number = 0;
		private var movement:MovementManager;
		
		public function MainStage()
		{
			strt = new StartBtn();
			
			addEventListener(Event.ENTER_FRAME,UpdateScene);
			//addEventListener(KeyboardEvent.KEY_DOWN, movement.handleKeyDown);	
		}
		
		public function UpdateScene(e:Event):void
		{
			var scene:Scene = MovieClip(this.root).currentScene;
			//trace(scene.name);
			
			if(scene.name == "In-Game" && once == 0)
			{
				Populate();
				once++;
			}
			
			
		}
		
		public function Populate():void
		{
			//var movement:MovementManager;
			var nun:Teacher;
			var verifier:Teacher;
		
			var desks:Vector.<Desk> = new Vector.<Desk>;
			var deskManager:LevelManager = new LevelManager();
			var myState:StateManager = new StateManager();
			var clock:TimerManager = new TimerManager();
			
			deskManager.populate(2,stage.width-20,stage.height-260,10,260);
			
			var points: Vector.<Point> = new Vector.<Point>();
			
			addChild(myState.getBar());
			
			desks = deskManager.getDesks();
			
			for(var i:int = 0; i < desks.length; i++)
			{
				points.push(new Point(desks[i].x, desks[i].y));
				addChild(desks[i]);
				desks[i].addEventListener(Event.ENTER_FRAME,desks[i].Update);
				
				if(desks[i].width < deskManager.getCellWidth())
				{
					desks[i].scaleX = deskManager.getCellWidth()/(stage.width/deskManager.getCols());
				}
				
				if(desks[i].height < deskManager.getCellHeight())
				{
					desks[i].scaleY = deskManager.getCellHeight()/(stage.width/deskManager.getRows());
				}
				
			}
			
			addChild(clock);
			clock.SetTimer();
			
			nun = new Teacher();
			
			addChildAt(nun,desks.length-1);
			
			verifier = new Teacher();
			verifier.width = nun.width;
			verifier.height = nun.height;
			addChild(verifier);
			verifier.visible = false;
			
			
			movement = new MovementManager(nun, verifier, deskManager.getColArray(), deskManager.getRowArray());
			deskManager.attachPlayer(movement);
			//trace("hi")
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, movement.handleKeyDown);			
			//addEventListener(Event.ENTER_FRAME, update);
			
			addEventListener("FAILURE", myState.subScore);
			addEventListener("FAILURE2", myState.subScore2);
			addEventListener("SUCCESS", myState.addScore);
			
		}
	}
}