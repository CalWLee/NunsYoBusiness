package
{
	import flash.display.MovieClip
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ResultsManager extends MovieClip
	{
		private var ScoreField:TextField = new TextField();
		private var ReprimendsField:TextField = new TextField();
		private var TrapsField:TextField = new TextField();
		private var GradeField:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		//private var formatGrade:TextFormat = new TextFormat();
		//private var formatScore:TextFormat = new TextFormat();
		private var pass:Pass = new Pass();
		private var fail:Fail = new Fail();
		private var chalkPass:ChalkNunPass = new ChalkNunPass();
		private var chalkFail:ChalkNunFail = new ChalkNunFail();
		
		public function ResultsManager()
		{	
			//private var returnbtn:ReturnBtn = new ReturnBtn(); //pending to verify if here or in main stage
			/*private var ScoreField:TextField = new TextField();
			private var ReprimendsField:TextField = new TextField();
			private var TrapsField:TextField = new TextField();
			private var GradeField:TextField = new TextField();
			private var format:TextFormat = new TextFormat();
			private var pass:Pass = new Pass();
			private var fail:Fail = new Fail();
			private var chalkPass:ChalkNunPass = new ChalkNunPass();
			private var chalkFail:ChalkNunFail = new ChalkNunFail();*/
			
			
			format.color = 0xFFFFFF;
			//format.size = 85;	
		}
		
		//public function ShowResults(Score:Number, Reprimends:Number, Traps:Number):void
		public function ShowResults(Score:Number):void
		{
			MovieClip(this.root).gotoAndPlay(1, "Results");
			trace(Score);
			
			var pass:Pass = new Pass();
			var fail:Fail = new Fail();
			var chalkPass:ChalkNunPass = new ChalkNunPass();
			var chalkFail:ChalkNunFail = new ChalkNunFail();
			
			format.font = "KG Primary Penmanship";
			format.size = 71;
			ScoreField.defaultTextFormat = format;
			ScoreField.x = 430; //pending until results screen is submited
			ScoreField.y = 287; //pending until results screen is submited
			ScoreField.width = 150; //pending until results screen is submited
			stage.addChild(ScoreField);
			ScoreField.text = String(Score);
			
			/*ReprimendsField.defaultTextFormat = format;
			ReprimendsField.x = ???; //pending until results screen is submited
			ReprimendsField.y = ???; //pending until results screen is submited
			ReprimendsField.width = 500???; //pending until results screen is submited
			addChild(ReprimendsField);
			ReprimendsField.text = Reprimends;
			
			TrapsField.defaultTextFormat = format;
			TrapsField.x = ???; //pending until results screen is submited
			TrapsField.y = ???;	//pending until results screen is submited
			TrapsField.width = 500???; //pending until results screen is submited
			addChild(TrapsField);
			TrapsField.text = Traps;*/
			
			format.font = "Drawing Guides";
			format.size = 2000;
			GradeField.defaultTextFormat = format;
			//GradeField.defaultTextFormat.size = 150;
			GradeField.x = 480; //pending until results screen is submited
			GradeField.y = 375;	//pending until results screen is submited
			GradeField.width = 174; //pending until results screen is submited
			stage.addChild(GradeField);
			
			if(Score >= 100)
			{
				GradeField.text = "A+";
			}
			
			else if(Score >= 90)
			{
				GradeField.text = "A";
			}
			
			else if(Score >= 80)
			{
				GradeField.text = "B";
			}
			else if(Score >= 70)
			{
				GradeField.text = "C";
			}
			else if(Score >= 60)
			{
				GradeField.text = "D";
			}
			else
			{
				GradeField.text = "F";
			}
			
			if(Score >= 70)
			{
				pass.x = 750;
				pass.y = 180;
				stage.addChild(pass);
				
				chalkPass.x = 790;
				chalkPass.y = 600;
				stage.addChild(chalkPass);
				
				LevelManager.playSound("Corrected_Sounds/Victory_Noise.mp3");
			}
			
			else
			{
				fail.x = 750;
				fail.y = 180;
				stage.addChild(fail);
				
				chalkFail.x = 790;
				chalkFail.y = 600;
				stage.addChild(chalkFail);
				
				LevelManager.playSound("Corrected_Sounds/Fail_Noise.mp3");
			}
			
		}
	}
}