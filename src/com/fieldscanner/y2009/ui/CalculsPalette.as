/*
# Copyright (c) 2009 Alexis Jacomy <alexis.jacomy@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

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
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				text = up.DIAGRAM.interval.toString();
			}
			
			var alpTF:TextField = new TextField();
			with(alpTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 30;
				text = "Alpha: ";
			}
			
			alphaInputTextField = new TextField();
			with(alphaInputTextField){
				type = TextFieldType.INPUT;
				x = 50;
				y = 30;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				text = up.DIAGRAM.interval.toString();
			}
			
			redoButton = new Button();
			with(redoButton){
				x = 30;
				y = 50;
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
				autoSize = TextFieldAutoSize.LEFT;
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
			problemTextField.appendText(s+"\n");
			problemTextField.textColor = 0x770909;
		}
		
		private function clearProblem():void{
			problemTextField.text = "";
			problemTextField.textColor = 0x770909;
		}
		
		private function redoButtonHandler(e:MouseEvent):void{
			clearProblem();
			var newInt:int = new int(intervalInputTextField.text);
			var newAlp:Number = new Number(alphaInputTextField.text);
			var intMax:int = up.DIAGRAM.endYear-up.DIAGRAM.beginYear;
			
			if(newInt<=0 || newInt>intMax){
				setProblem("Wrong interval value: Must be between 0 and "+intMax+".");
			}else if(newAlp<=0){
				setProblem("Wrong alpha value: Must be over 0.");
			}else{
				up.DIAGRAM.up.reprocess(newInt,newAlp);
				redoButton.selected = false;
			}
		}
	}
}