package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	
	public class TimerManager extends MovieClip
	{
		private var seconds:Number, maxInterval:Number;
		private var myField:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var myTimer:Timer = new Timer(1000);
		
		private var tick1:Sound = new Sound();
		private var tick2:Sound = new Sound();
		private var end:Sound = new Sound();
			
		private var tickChannel:SoundChannel;
		
		public function TimerManager()
		{
			myField.x = 256;
			myField.y = 50;
			myField.width = 500;
			
			format.font = "KG Primary Penmanship Lined";
			format.color = 0xFFFFFF;
			format.size = 43;						
			
			myField.defaultTextFormat = format;
			this.addChild(myField);
			
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, broadcastEnd);
			
			tick1.load(new URLRequest("Corrected_Sounds/Faster_Clock_Tick.mp3"));
			tick2.load(new URLRequest("Corrected_Sounds/Fastest_Clock_Tick.mp3"));
			end.load(new URLRequest("Corrected_Sounds/Class_Bell.mp3"));
		}
		
		public function hideField()
		{
			myField.visible = false;
		}
		
		public function showField()
		{
			myField.visible = false;
		}
		
		public function getSeconds():Number
		{
			return this.seconds;
		}
		
		public function getMaxSecs():Number
		{
			return this.maxInterval;
		}
		
		public function startGame():void
		{
			trace("START");
			myTimer.start();
			this.dispatchEvent(new Event("GAME_START", true));
		}
		
		public function broadcastEnd(t:TimerEvent)
		{
			this.tickChannel.stop();
			
			myTimer.reset();
			this.dispatchEvent(new Event("GAME_END", true));
			
			
			this.tickChannel = end.play();
			
			this.tickChannel.addEventListener(Event.SOUND_COMPLETE, playEnd);
		}
		
		public function SetTimer(s:Number = 60):void
		{		
			trace("Timer Set: " + s);
		
			maxInterval = seconds = s;
			myTimer.repeatCount = maxInterval+1;
			
			//trace("Set");
		}
		
		private function timerListener (e:TimerEvent):void
		{
			trace(myTimer.currentCount);
			myField.text = "Time Left: " + seconds;
			seconds -= 1;
			
			if(seconds == 15)
			{
				this.play1();
			}
		}
		
		private function playEnd(e:Event):void
		{			
			this.dispatchEvent(new Event("GOTO_RESULTS",true));			
		}
		
		private function play1(e:Event = null):void
		{
			this.tickChannel = tick1.play();
			if(this.seconds > 5)
			{
				this.tickChannel.addEventListener(Event.SOUND_COMPLETE, play1) ;
			}
			else 
			{
				this.tickChannel.removeEventListener(Event.SOUND_COMPLETE, play1) ;
				this.tickChannel.addEventListener(Event.SOUND_COMPLETE, play2) ;
			}
		}
		
		private function play2(e:Event = null):void
		{
			this.tickChannel = tick2.play();
			if(this.seconds > 1)
			{
				this.tickChannel.addEventListener(Event.SOUND_COMPLETE, play2) ;
			}
			else{
				this.tickChannel.stop()
			}
		}
	}
	
	
}