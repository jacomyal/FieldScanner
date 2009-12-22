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
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class TimePalette extends Sprite{
		
		private var up:OptionsInterface;
		
		private var playButton:Button;
		private var stopButton:Button;
		
		private var isStopped:Boolean;
		private var isPlaying:Boolean;
		private var isPaused:Boolean;
		
		public function TimePalette(newUp:OptionsInterface){
			up = newUp;
			up.addChild(this);
			
			isStopped = false;
			isPlaying = false;
			isPaused = false;
		}
		
		public function get IS_PLAYING():Boolean{
			return isPlaying;
		}
		
		public function initButtons():void{
			playButton.label = "Play";
			playButton.setStyle("textFormat",up.TITLE_FORMAT);
			playButton.selected = false;
			stopButton.selected = false;
		}
		
		public function setButtons():void{
			playButton = new Button();
			with(playButton){
				x = 10;
				y = 0;
				width = 80;
				height = 20;
				toggle = true;
				useHandCursor = true;
				focusEnabled = false;
				label = "Play";
				setStyle("textFormat",up.TITLE_FORMAT);
				addEventListener(MouseEvent.CLICK,playButtonHandler);
			}
			addChild(playButton);
			
			stopButton = new Button();
			with(stopButton){
				x = 100;
				y = 0;
				width = 50;
				height = 20;
				toggle = true;
				useHandCursor = true;
				focusEnabled = false;
				label = "Stop";
				setStyle("textFormat",up.TITLE_FORMAT);
				addEventListener(MouseEvent.CLICK,stopButtonHandler);
			}
			addChild(stopButton);
		}
		
		public function pause():void{
			if(isPlaying==true){
				isStopped = false;
				isPlaying = false;
				isPaused = true;
				
				initButtons();
				playButton.label = "Play";
				playButton.setStyle("textFormat",up.TITLE_FORMAT);
			}
		}
		
		public function goFirstFrame():void{
			up.DIAGRAM.goFirstFrame();
		}
		
		public function goNextFrame():Boolean{
			return up.DIAGRAM.goNextFrame();
		}
		
		public function playButtonHandler(e:MouseEvent):void{
			if(isPlaying==false){
				isStopped = false;
				isPlaying = true;
				isPaused = false;
				
				if(up.DIAGRAM.LAST_FRAME) goFirstFrame();
					
				addEventListener(Event.ENTER_FRAME,playProcess);
				playButton.label = "Pause";
				playButton.setStyle("textFormat",up.TITLE_FORMAT);
			}else{
				isStopped = false;
				isPlaying = false;
				isPaused = true;
				
				initButtons();
				playButton.label = "Play";
				playButton.setStyle("textFormat",up.TITLE_FORMAT);
			}
		}
		
		private function stopButtonHandler(e:MouseEvent):void{
			playButton.label = "Play";
			playButton.setStyle("textFormat",up.TITLE_FORMAT);
			isStopped = true;
			isPlaying = false;
			isPaused = false;
			goFirstFrame();
			
			initButtons();
		}
		
		private function playProcess(evt:Event):void{
			if(!goNextFrame()||!isPlaying){
				removeEventListener(Event.ENTER_FRAME,playProcess);
				if(isStopped) goFirstFrame();
				
				isStopped = false;
				isPlaying = false;
				isPaused = false;
				initButtons();
			}
		}
		
		private function timeSliderHandler(e:SliderEvent):void{
			up.DIAGRAM.goFrame(e.value);
		}
		
		private function speedSliderHandler(e:SliderEvent):void{
			stage.frameRate = e.value;
		}
		
	}
	
}