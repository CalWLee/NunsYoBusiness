

package {
	
	import flash.display.*;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Renderable {
		
		public static const BITMAP:int = 1;
		public static const MOVIECLIP:int = 2;
		
		private var baseClip:MovieClip; // primary movie clip that all others attach to
		private var parentClip:MovieClip; // parent of the base clip
		private var assetGraphic:Bitmap; // used to load external assets		
		private var assetClip:MovieClip; // used to load external assets		
				
		public function Renderable(argParentClip:MovieClip, argAssetPath:String, type:int = BITMAP) {	
			this.parentClip = argParentClip;
			
			// Create the base clip on the parent
			this.baseClip = new MovieClip();
			this.parentClip.addChild(this.baseClip);
			
			// Create a loader and load the provided asset path
			var loader:Loader = new Loader();
			loader.load(new URLRequest(argAssetPath));
			if(type == BITMAP)
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completedExternalAssetLoad);
			}
			else
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completedExternalAssetLoad2);
			}
		}
		
		private function completedExternalAssetLoad(event:Event):void {
			// Assign the movie clip for the asset and center it on the base clip	
			this.assetGraphic = Bitmap(event.target.content);
			this.baseClip.addChildAt(this.assetGraphic,0);
			this.assetGraphic.x =0;
			this.assetGraphic.y =0;
			this.assetGraphic.width = 1210;
			this.assetGraphic.visible = false;
			
			this.hideGraphic(null);
			//this.baseClip.addEventListener("GAME_START", showGraphic);
			//this.baseClip.addEventListener("GAME_END", hideGraphic);
			
			// Remove the event listener that triggered this call back
			event.target.removeEventListener(Event.COMPLETE, this.completedExternalAssetLoad);
		}
		
		private function completedExternalAssetLoad2(event:Event):void {
			// Assign the movie clip for the asset and center it on the base clip	
			this.assetClip = MovieClip(event.target.content);
			this.baseClip.addChildAt(this.assetClip,0)
			this.assetClip.x = 730;
			this.assetClip.y = 40;			
			this.assetClip.visible = false;
			
			this.hideClip(null);
			//this.baseClip.addEventListener("GAME_START", showClip);
			//this.baseClip.addEventListener("GAME_END", hideClip);
			
			// Remove the event listener that triggered this call back
			event.target.removeEventListener(Event.COMPLETE, this.completedExternalAssetLoad2);
		}
		
		public function showClip(e:Event)
		{
			this.assetClip.visible = true;
		}
		
		public function hideClip(e:Event)
		{
			this.assetClip.visible = false;
		}
		
		public function showGraphic(e:Event)
		{
			this.assetGraphic.visible = true;
		}
		
		public function hideGraphic(e:Event)
		{
			this.assetGraphic.visible = false;
		}
	}
	
}
