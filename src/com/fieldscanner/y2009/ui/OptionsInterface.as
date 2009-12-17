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
	
	import com.fieldscanner.y2009.graphics.Diagram;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class OptionsInterface extends Sprite{
		
		private var displayPalette:DisplayPalette;
		private var calculsPalette:CalculsPalette;
		private var indexPalette:IndexPalette;
		private var infoPalette:InfoPalette;
		private var timePalette:TimePalette;
		private var timeLine:TimeLine;
		
		private var basicTextFormat:TextFormat;
		private var titleTextFormat:TextFormat;
		private var inputTextFormat:TextFormat;
		private var errorTextFormat:TextFormat;
		private var diagram:Diagram;
		
		public function OptionsInterface(d:Diagram) {
			diagram = d;
			d.stage.addChild(this);
			x = 10;
			y = 10;
			
			basicTextFormat = new TextFormat("Verdana",11);
			titleTextFormat = new TextFormat("Verdana",12,0x000000,true);
			inputTextFormat = new TextFormat("Verdana",12,0x286777,false,true);
			errorTextFormat = new TextFormat("Verdana",12,0x770909,true);
			
			setPalettes();
		}
		
		public function get BASIC_FORMAT():TextFormat{
			return basicTextFormat;
		}
		
		public function get TITLE_FORMAT():TextFormat{
			return titleTextFormat;
		}
		
		public function get INPUT_FORMAT():TextFormat{
			return inputTextFormat;
		}
		
		public function get ERROR_FORMAT():TextFormat{
			return errorTextFormat;
		}
		
		public function get TIME_LINE():TimeLine{
			return timeLine;
		}
		
		public function get IS_PLAYING():Boolean{
			return timePalette.IS_PLAYING;
		}
		
		public function get DIAGRAM ():Diagram{
			return diagram;
		}
		
		public function inputHandler(e:Event):void{
			var tf:TextField = e.target as TextField;
			tf.setTextFormat(INPUT_FORMAT);
		}
		
		public function setPalettes():void{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x777777);
			
			timePalette = new TimePalette(this);
			with(timePalette){
				x = 10;
				y = 0;
				setButtons();
				setSpeedSlider();
				setTimeSlider();
			}
			
			this.graphics.moveTo(20,120);
			this.graphics.lineTo(150,120);
			
			calculsPalette = new CalculsPalette(this);
			with(calculsPalette){
				x = 0;
				y = 420;
				setInterface();
			}
			
			this.graphics.moveTo(20,420);
			this.graphics.lineTo(150,420);
			
			displayPalette = new DisplayPalette(this);
			with(displayPalette){
				x = 0;
				y = 320;
				setInterface();
			}
			
			this.graphics.moveTo(20,320);
			this.graphics.lineTo(150,320);
			
			indexPalette = new IndexPalette(this);
			with(indexPalette){
				x = 0;
				y = 120;
				setInterface();
			}
			
			this.graphics.moveTo(20,510);
			this.graphics.lineTo(150,510);
			
			timeLine = new TimeLine(this,diagram);
			drawTimeLineCursor();
		}
		
		public function reset():void{
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
			
			stage.removeChild(timeLine);
			
			setPalettes();
		}
		
		public function play():void{
			timePalette.playButtonHandler(null);
		}
		
		public function drawTimeLineCursor():void{
			timeLine.drawCursor(diagram.INTERVAL,diagram.FRAME);
		}
		
		public function stopPlaying():void{
			timePalette.pause();
		}
		
		public function setTimeSliderFrame(f:int):void{
			timePalette.goFrame(f);
		}
	}
}