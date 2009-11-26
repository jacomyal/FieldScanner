﻿/*
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
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
    import flash.display.Sprite;
    import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	public class TimePalette extends Sprite{
		
		private var up:OptionsInterface;
		
		private var playButton:Button;
		private var stopButton:Button;
		private var timeSlider:Slider;
		private var speedSlider:Slider;
		
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
		
		public function setTimeSlider(framesNumber:Number):void{
			var tf:TextField = new TextField();
			with(tf){
				text = "Time slider:";
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 10;
			}
			
			timeSlider = new Slider();
			with(timeSlider){
				minimum = 1;
				maximum = framesNumber;
				value = 0;
				setSize(100,0);
				liveDragging = true;
				x = 10;
				y = 30;
				addEventListener(SliderEvent.CHANGE,timeSliderHandler);
			}
			
			addChild(tf);
			addChild(timeSlider);
		}
		
		public function setSpeedSlider():void{
			var tf:TextField = new TextField();
			with(tf){
				text = "Speed slider:";
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 50;
			}
			
			speedSlider = new Slider();
			with(speedSlider){
				minimum = 0.1;
				maximum = 30;
				value = 8;
				setSize(100,0);
				liveDragging = true;
				x = 10;
				y = 70;
				addEventListener(SliderEvent.CHANGE,speedSliderHandler);
			}
			
			stage.frameRate = speedSlider.value;
			
			addChild(tf);
			addChild(speedSlider);
		}
		
		public function initButtons():void{
			playButton.label = "Play";
			playButton.selected = false;
			stopButton.selected = false;
		}
		
		public function setButtons():void{
			playButton = new Button();
			with(playButton){
				x = 10;
				y = 90;
				width = 50;
				height = 20;
				toggle = true;
				useHandCursor = true;
				label = "Play";
				addEventListener(MouseEvent.CLICK,playButtonHandler);
			}
			addChild(playButton);
			
			stopButton = new Button();
			with(stopButton){
				x = 70;
				y = 90;
				width = 40;
				height = 20;
				toggle = true;
				useHandCursor = true;
				label = "Stop";
				addEventListener(MouseEvent.CLICK,stopButtonHandler);
			}
			addChild(stopButton);
		}
		
		private function playButtonHandler(e:MouseEvent):void{
			if(isPlaying==false){
				isStopped = false;
				isPlaying = true;
				isPaused = false;
				
				if(up.DIAGRAM.LAST_FRAME) goFirstFrame();
					
				addEventListener(Event.ENTER_FRAME,playProcess);
				playButton.label = "Pause";
			}else{
				isStopped = false;
				isPlaying = false;
				isPaused = true;
				
				initButtons();
				playButton.label = "Play";
			}
		}
		
		private function stopButtonHandler(e:MouseEvent):void{
			playButton.label = "Play";
			isStopped = true;
			isPlaying = false;
			isPaused = false;
			goFirstFrame();
			
			initButtons();
		}
		
		private function playProcess(evt:Event):void{
			if(!goNextFrame()||!isPlaying){
				removeEventListener(Event.ENTER_FRAME,playProcess);
				if(!isPaused) goFirstFrame();
				
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
		
		private function goFirstFrame():void{
			timeSlider.value = 0;
			up.DIAGRAM.goFirstFrame();
		}
		
		private function goNextFrame():Boolean{
			timeSlider.value ++;
			return up.DIAGRAM.goNextFrame();
		}
		
		private function goFrame(i:Number):Boolean{
			timeSlider.value = i;
			return up.DIAGRAM.goFrame(i);
		}
		
	}
	
}