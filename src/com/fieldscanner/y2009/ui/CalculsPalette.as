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
	
    import fl.controls.Button;
    
    import flash.display.Sprite;
	import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
	
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
				text = "Interval: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 10;
				y = 10;
			}
			
			intervalInputTextField = new TextField();
			with(intervalInputTextField){
				type = TextFieldType.INPUT;
				text = up.DIAGRAM.INTERVAL.toString();
				setTextFormat(up.INPUT_FORMAT);
				x = 80;
				y = 10;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				addEventListener(Event.CHANGE,up.inputHandler);
			}
			
			var alpTF:TextField = new TextField();
			with(alpTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "Alpha: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 10;
				y = 30;
			}
			
			alphaInputTextField = new TextField();
			with(alphaInputTextField){
				type = TextFieldType.INPUT;
				text = up.DIAGRAM.ALPHA.toString();
				setTextFormat(up.INPUT_FORMAT);
				x = 80;
				y = 30;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				addEventListener(Event.CHANGE,up.inputHandler);
			}
			
			redoButton = new Button();
			with(redoButton){
				x = 10;
				y = 50;
				width = 110;
				height = 20;
				toggle = true;
				useHandCursor = true;
				label = "Recalculate";
				setStyle('textFormat',up.TITLE_FORMAT);
				addEventListener(MouseEvent.CLICK,redoButtonHandler);
			}
			
			problemTextField = new TextField();
			with(problemTextField){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 90;
				setTextFormat(up.ERROR_FORMAT);
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
			problemTextField.setTextFormat(up.ERROR_FORMAT);
		}
		
		private function clearProblem():void{
			problemTextField.text = "";
			problemTextField.setTextFormat(up.ERROR_FORMAT);
		}
		
		private function redoButtonHandler(e:MouseEvent):void{
			clearProblem();
			var newInt:int = new int(intervalInputTextField.text);
			var newAlp:Number = new Number(alphaInputTextField.text);
			var intMax:int = up.DIAGRAM.MAX_INTERVAL;
			
			if(newInt<=0 || newInt>intMax){
				setProblem("Wrong interval value: Must be between 0 and "+intMax+".");
			}else if(!(newInt is int)){
				setProblem("Wrong interval value: Must be an integer value.");
			}else if(newAlp<=0){
				setProblem("Wrong alpha value: Must be over 0.");
			}else{
				up.DIAGRAM.up.reprocess(newInt,newAlp);
				redoButton.selected = false;
			}
		}
	}
}