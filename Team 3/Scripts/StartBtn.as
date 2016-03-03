package
{
	import flash.display.MovieClip
	import flash.events.MouseEvent
	import flash.display.SimpleButton
	import flash.display.Scene
	import flash.media.Sound
	import flash.net.URLRequest
	import flash.net.URLLoader
	
	public class StartBtn extends SimpleButton
	{
		
		public function StartBtn()
		{
			addEventListener(MouseEvent.CLICK, GotoGame);
			
		}
		
		/*public function CurrentScn():Scene
		{	
			var scene:Scene;
			scene = MovieClip.(this.root).currentScene();
			return scene;
			
		}
		*/
		public function GotoGame(e:MouseEvent)
		{
			var sound:Sound = new Sound(new URLRequest("../Corrected_Sounds/Button_Sound.mp3"));
			sound.play();
			trace("Click");
			MovieClip(this.root).gotoAndPlay(1, "In-Game");
			//trace(MovieClip.(this.root).currentScene());

		}
	}
}
