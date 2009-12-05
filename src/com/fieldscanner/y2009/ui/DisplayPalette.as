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
	
    import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
	
	public class DisplayPalette extends Sprite{
		
		private var up:OptionsInterface;
		private var radioButtons:Vector.<RadioButton>;
		private var rbGroups:RadioButtonGroup;
		
		public function DisplayPalette(newUp:OptionsInterface){
			up = newUp;
			up.addChild(this);
			rbGroups = new RadioButtonGroup("Display mode");
		}
		
		public function setInterface():void{
			var dTF:TextField = new TextField();
			radioButtons = new Vector.<RadioButton>();
			
			with(dTF){
				x = 10;
				y = 10;
				text = "Display mode:";
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				setTextFormat(up.TITLE_FORMAT);
			}
			addChild(dTF);

			radioButtons.push(new RadioButton());
			with(radioButtons[0]){
				x = 10;
				y = 30;
				width = 200;
				setStyle("textFormat",up.BASIC_FORMAT);
				label = "Normal view";
				if(up.DIAGRAM.MODE==0) selected = true;
				group = rbGroups;
				addEventListener(MouseEvent.CLICK,modeChangeHandler);
			}
			addChild(radioButtons[0]);
			
			radioButtons.push(new RadioButton());
			with(radioButtons[1]){
				x = 10;
				y = 50;
				width = 200;
				setStyle("textFormat",up.BASIC_FORMAT);
				label = "Scaled view (global)";
				if(up.DIAGRAM.MODE==1) selected = true;
				group = rbGroups;
				addEventListener(MouseEvent.CLICK,modeChangeHandler);
			}
			addChild(radioButtons[1]);
			
			radioButtons.push(new RadioButton());
			with(radioButtons[2]){
				x = 10;
				y = 70;
				width = 200;
				setStyle("textFormat",up.BASIC_FORMAT);
				label = "Scaled view (local)";
				if(up.DIAGRAM.MODE==2) selected = true;
				group = rbGroups;
				addEventListener(MouseEvent.CLICK,modeChangeHandler);
			}
			addChild(radioButtons[2]);
			
		}
		
		private function modeChangeHandler(e:Event):void{
			var i:int;
			var index:int = -1;
			
			for(i=0;i<3;i++){
				if(radioButtons[i]==(e.target as RadioButton)){
					index = i;
					radioButtons[i].selected = true;
				}else{
					radioButtons[i].selected = false;
				}
			}
			
			trace("Changing display mode: "+index);
			up.DIAGRAM.changeDisplayMode(index);
		}
		
	}
	
}