package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.*;
	import flash.display.Scene;
	
	public class MainStage extends MovieClip
	{
		var strt:StartBtn;
		var rtrn:ReturnBtn;
		var myState:StateManager = new StateManager();
		var deskManager = new LevelManager();
		var listenersAdded: Boolean = false;
		
		var movement:MovementManager;
		var nun:Teacher;
		var verifier:Teacher;
		var clock:TimerManager = new TimerManager();
		
		var bg:Renderable; 
		var bar:Renderable;
		//var once:Number = 0;
		
		public function MainStage()
		{
			addEventListener(Event.ENTER_FRAME,UpdateScene);  //Listener to verify currentScene and establish if "In-Game" can be populated
			var strt:StartBtn = new StartBtn(); //adds the start button instance
			var rtrn:ReturnBtn = new ReturnBtn();
			//These go into the DeskManager Class, still not working from there
			//From the MainStage it works fine, I'll leave them here until we find out
			//what's happening in that other class
			//trace("hi");
			//var bg:Renderable = new Renderable(this, "Art/Classroom1_final2.png");
			//var bar:Renderable = new Renderable(this, "Art/Ruler.swf",Renderable.MOVIECLIP);
			bg = new Renderable(this, "Art/Classroom1_final2.png");
			bar = new Renderable(this, "Art/Ruler.swf",Renderable.MOVIECLIP);
			
			//bg.hideGraphic(null);
			//bar.hideClip(null);
			
			nun = new Teacher();
			
			verifier = new Teacher();
			verifier.width = nun.width;
			verifier.height = nun.height;
			verifier.visible = false;
		}
		
		public function Populate():void //separate into different function when the UpdateScene listener in uncomment
		{
			var i:int;
			//cleanup
			/*
			for(i = 1; i < this.numChildren; i++)
			{
				//trace(this.getChildAt(i).toString());
				this.removeChildAt(i);
			}
			
			
			*/
			//var desks:Vector.<Desk> = new Vector.<Desk>;
			myState.resetGame();
			myState.incLevel();
			
			deskManager.populate(0,stage.width-20,stage.height-260,10,260);
			
			//var rects: Vector.<Rectangle> = new Vector.<Rectangle>();
			var points: Vector.<Point> = new Vector.<Point>();
			
			if(this.contains(myState))
			{
				addChild(myState);   
			}
			
			if(!this.contains(myState.getBar()))
			{
			   addChild(myState.getBar());
			}
			else
			{
				myState.getBar().visible = true;
			}
			
			if(!this.contains(myState.getRM()))
			{
			   addChild(myState.getRM());
			}
			
			var desks = deskManager.getDesks();
			var hazards = deskManager.getHazards();
						
			for(var j:int = 0; j < hazards.length; j++)
			{
				addChild(hazards[j]);
				trace("Hazard " + j + " spawned at " + hazards[j].getX() + ", " + hazards[j].getY());
			}
			
			for(var i:int = 0; i < desks.length; i++)
			{
				//rects.push(new Rectangle(temp.x, temp.y, temp.width, temp.height));
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
				//this.addEventListener("BEHAVE",desks[i].hitReact);
			}
			
			if(!this.contains(nun))
			{
				addChild(nun);
			}
			else
			{
				nun.visible = true;
			}
			
			//Todo: Integrate with the Level Manager and add setTimer with an argument.
			//var myHazard:Hazard = new Hazard();
			
			//End of desks
			//this.nun.scaleX = (this.nun.width < deskManager.getCellWidth() ? deskManager.getCellWidth()/(stage.width/deskManager.getCols()) : 1);
			//this.nun.scaleY = (this.nun.width < deskManager.getCellHeight() ? deskManager.getCellHeight()/(stage.width/deskManager.getRows()) : 1);
			
			if(!this.contains(verifier)) { addChild(verifier); }
			
			if(!this.contains(deskManager.getClock())) 
			{
				addChild(deskManager.getClock());
			}
			else{
				deskManager.getClock().showField();
			}
			//this.nun.x = stage.width/deskManager.getCols();
			//this.nun.y = stage.height/deskManager.getRows();
			//this.deskSetter = new DeskManager();
			
			//SetDesks();
			if(!movement)
			{
				movement = new MovementManager(nun, verifier, deskManager.getColArray(), deskManager.getRowArray());				
			}
			else
			{
				movement.setGrid(deskManager.getColArray(), deskManager.getRowArray());
			}
			
			//have to reattach because traps need to know the location of the player to trigger.
			deskManager.attachPlayer(movement);
			
			//this.movement.setLocations(desks);
			//this.movement.setMapData(deskManager.getCols(), deskManager.getRows(),stage.width/deskManager.getCols(),stage.height/deskManager.getRows());
			//this.movement.setMoveDist(stage.width/deskManager.getCols(), stage.height/deskManager.getRows());
			
			if(!listenersAdded)
			{
				addListeners();
			}
			
			stage.focus = nun;
			stage.focus = null;
			
			deskManager.start();
			//trace("Added LISTENER");
			//stage.addEventListener(Event.ENTER_FRAME, update);
		}
		public function addListeners()
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, movement.handleKeyDown);			
			
			addEventListener("FAILURE", myState.subScore);
			addEventListener("FAILURE2", myState.subScore2);
			addEventListener("SUCCESS", myState.addScore);
			
			stage.addEventListener("GAME_END",deskManager.end);
			stage.addEventListener("GAME_END",myState.stopGame);
			
			stage.addEventListener("CLEANUP", this.cleanScreen);
			
			listenersAdded = true;
		}
		//Function to verify the scene and populate if in "In-Game" Scene
		//Uncomment when movement problem has been resolved
		public function UpdateScene(e:Event):void
		{			
			//trace(this.currentFrame);
			if(MovieClip(this.root).currentScene.name == "In-Game" && MovieClip(this.root).currentFrame == 11)
			{
				Populate();
			}
		}
		
		public function cleanScreen(e:Event = null)
		{
			var i:int;
			nun.visible = false;
			myState.getBar().visible = false;
			
			bg.hideGraphic(null);
			bar.hideClip(null);
			deskManager.getClock().hideField();
			
			for(i=0; i < deskManager.getDesks();i++)
			{
				deskManager.getDesks()[i].visible = false
				this.removeChild(deskManager.getDesks()[i]);
			}
			trace("cleaned desks");
			
			for(i=0; i < deskManager.getHazards();i++)
			{
				this.removeChild(deskManager.getHazards()[i]);
			}
			trace("cleaned hazards");
		}
	}
}
