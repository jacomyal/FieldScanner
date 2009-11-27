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
	
	import flash.ui.Keyboard;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.SimpleButton;
    import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
    import flash.events.MouseEvent;
    import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import com.fieldscanner.y2009.graphics.Diagram;
	
	public class OptionsInterface extends Sprite{
		
		private var displayPalette:DisplayPalette;
		private var infoPalette:InfoPalette;
		private var timePalette:TimePalette;
		private var calculsPalette:CalculsPalette;
		private var diagram:Diagram;
		
		public function OptionsInterface(d:Diagram) {
			
			diagram = d;
			d.stage.addChild(this);
			x = 10;
			y = 10;
			
			setPalettes();
		}
		
		public function setPalettes():void{
			
			timePalette = new TimePalette(this);
			with(timePalette){
				setButtons();
				setSpeedSlider();
				setTimeSlider(diagram.graphsVector.length);
				x = 0;
				y = 470;
			}
			
			calculsPalette = new CalculsPalette(this);
			with(calculsPalette){
				setInterface();
				x = 0;
				y = 390;
			}
			
			infoPalette = new InfoPalette(this);
			with(infoPalette){
				setInterface();
				x = 0;
				y = 0;
			}
			
			displayPalette = new DisplayPalette(this);
		}
		
		public function reset():void{
			
			while(this.numChildren>0){
				this.removeChildAt(0);
				trace("OptionsInterface.removeChild...");
			}
			
			setPalettes();
		}
		
		public function get DIAGRAM ():Diagram{
			return diagram;
		}
	}
}