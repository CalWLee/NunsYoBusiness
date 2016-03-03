package
{
	import flash.display.MovieClip
	import flash.events.MouseEvent
	import flash.display.SimpleButton
	import flash.display.Scene
	
	public class ReturnBtn extends SimpleButton
	{
		
		public function ReturnBtn()
		{
			addEventListener(MouseEvent.CLICK, GotoGame);
		}
		
		public function GotoGame(e:MouseEvent)
		{
			trace("Click");
			MovieClip(this.root).gotoAndPlay(1, "Start");
		}
	}
}