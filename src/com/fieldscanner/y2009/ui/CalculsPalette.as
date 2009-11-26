package com.fieldscanner.y2009.ui {
	
    import flash.display.Sprite;
    import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	
	public class CalculsPalette extends Sprite{
		
		private var up:OptionsInterface;
		
		private var redoButton:Button;
		private var problemTextField:TextField;
		private var alphaInputTextField:TextField;
		private var intervalInputTextField:TextField;
		
		public function CalculsPalette(newUp:OptionsInterface){
			up = newUp;
			up.addChild(this);
		}
		
		public function setInterface():void{
			var intTF:TextField = new TextField();
			with(intTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 10;
				text = "Interval: ";
			}
			
			intervalInputTextField = new TextField();
			with(intervalInputTextField){
				type = TextFieldType.INPUT;
				x = 50;
				y = 10;
				selectable = true;
				autoSize = TextFieldAutoSize.LEFT;
				text = up.DIAGRAM.interval.toString();
			}
			
			var alpTF:TextField = new TextField();
			with(alpTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 10;
				text = "Alpha: ";
			}
			
			alphaInputTextField = new TextField();
			with(alphaInputTextField){
				type = TextFieldType.INPUT;
				x = 50;
				y = 10;
				selectable = true;
				autoSize = TextFieldAutoSize.LEFT;
				text = up.DIAGRAM.interval.toString();
			}
			
			redoButton = new Button();
			with(redoButton){
				x = 30;
				y = 30;
				width = 70;
				height = 20;
				toggle = true;
				useHandCursor = true;
				label = "Recalculate";
				addEventListener(MouseEvent.CLICK,redoButtonHandler);
			}
			
			problemTextField = new TextField();
			with(problemTextField){
				selectable = false;
				autoSize = TextFieldAutoSize.CENTER;
				x = 10;
				y = 90;
				textColor = 0x770909;
				text = "";
			}
			
			addChild(intTF);
			addChild(intervalInputTextField);
			addChild(alpTF);
			addChild(alphaInputTextField);
			addChild(redoButton);
			addChild(problemTextField);
		}
		
		private function setProblem(s:String):void{
			problemTextField.text = s;
			problemTextField.textColor = 0x770909;
		}
		
		private function redoButtonHandler(e:MouseEvent):void{
			var newInt:int = new int(intervalInputTextField.text);
			var intMax:int = up.DIAGRAM.endYear-up.DIAGRAM.beginYear;
			
			if(newInt>0 && newInt<=intMax){
				up.DIAGRAM.up.reprocess(newInt);
				redoButton.selected = false;
			}else{
				setProblem("Wrong interval value: Must be between 0 and "+intMax+".");
			}
		}
		
	}
	
}