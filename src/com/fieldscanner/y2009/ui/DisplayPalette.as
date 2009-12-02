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
	
    import fl.controls.ComboBox;
    import fl.data.DataProvider;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
	
	public class DisplayPalette extends Sprite{
		
		public static const MODE_CHANGED:String = "Mode has changed";
		private var up:OptionsInterface;
		private var mode:ComboBox;
		
		public function DisplayPalette(newUp:OptionsInterface){
			up = newUp;
			up.addChild(this);
			
		}
		
		public function setInterface():void{
			var tf:TextField = new TextField();
			with(tf){
				x = 10;
				y = 10;
				text = "Display mode:";
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
			}
			addChild(tf);
			
			var dp:DataProvider = new DataProvider([{label:"Global view", data:1},
													{label:"Scaled view (all diagrams)", data:2},
													{label:"Scaled view (each diagram)", data:3}]);
			
			mode = new ComboBox();
			with(mode){
				x = 10;
				y = 30;
				width = 175;
				dataProvider = dp;
				selectedIndex = 0;
				addEventListener(Event.CHANGE, modeChangeHandler);
			}
			addChild(mode);
			
		}
		
		private function modeChangeHandler(e:Event):void{
			var i:int = mode.selectedIndex;
			
			mode.selectedIndex = i;
			trace("Changing display mode: "+mode.selectedLabel);
			up.DIAGRAM.changeDisplayMode(i);
			
		}
		
	}
	
}