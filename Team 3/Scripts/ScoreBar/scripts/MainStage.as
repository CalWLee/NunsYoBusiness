package
{
	import flash.display.MovieClip
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	public class MainStage extends MovieClip
	{
		private var changer:BarManager;
		private var ruler:Ruler; //add an instance of the Ruler Symbol that has the bar as child
		
		public function MainStage()
		{
			ruler = new Ruler();
			
			//set the position of where the ruler instance is going to be moved
			ruler.x = 550;
			ruler.y = 400;
			addChild(ruler);
		
			changer = new BarManager(this.ruler);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, changer.changeLength);
			
		}
	}
}
		