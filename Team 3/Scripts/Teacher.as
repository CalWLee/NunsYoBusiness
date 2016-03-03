package 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.Keyboard;

	public class Teacher extends MovieClip
	{
		private var lastLabel:String;
		private var isAttacking:Boolean;
		private var onStage:Boolean;
		
		public function Teacher()
		{			
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			this.stop();
			this.isAttacking = false;
			this.onStage = false;
			/*
			
			attack_f.loadMovie("Art/NunWhack_frontFinal.swf");
			attack_l.loadMovie("Art/NunWhack_leftFinal.swf");
			attack_r.loadMovie("Art/NunWhack_backFinal.swf");*/
		}
		
		public function isAttack():Boolean
		{
			return this.isAttacking;
		}
		
		public function isOnStage():Boolean
		{
			return this.onStage;
		}
		
		private function onAddedToStage(ev:Event):void
		{
			this.onStage = true;
			
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, rotate);
			
			stage.addEventListener(Event.ENTER_FRAME, checkAtk);
			//trace("added teacher listeners");
		}
		
		/*private function rotate(ke:KeyboardEvent):void
		{*/
		public function rotate(keyCode:uint):void
		{
			
			if(keyCode == Keyboard.UP)
			{
				this.gotoAndStop("Back");
			}
			else if(keyCode == Keyboard.DOWN)
			{
				this.gotoAndStop("Front");
			}
			else if(keyCode == Keyboard.LEFT)
			{
				this.gotoAndStop("Left");
			}
			else if(keyCode == Keyboard.RIGHT)
			{
				this.gotoAndStop("Right");
			}
		}
		
		private function checkAtk(e:Event)
		{			
			if(this.currentFrameLabel != null)
			{
				lastLabel = this.currentFrameLabel;
			}
			
			this.isAttacking = (lastLabel.search("Attack") != -1);
			//trace(lastLabel);
		}
		
		public function attack()
		{
			//this.visible = false;
			//trace("ATTACK");
			this.gotoAndPlay(this.currentFrameLabel + "Attack");
			lastLabel = this.currentFrameLabel;
			this.isAttacking = true;
		}

		public function modX(modifier:Number):void
		{
			this.x +=  modifier;
		}

		public function modY(modifier:Number):void
		{
			this.y +=  modifier;
		}

	}
}