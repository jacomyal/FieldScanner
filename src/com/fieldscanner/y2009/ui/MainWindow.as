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
	
	import com.fieldscanner.y2009.calcul.GSCalculator;
	import com.fieldscanner.y2009.graphics.Diagram;
	import com.fieldscanner.y2009.loading.DataLoader;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MainWindow extends Sprite{
		
		private var gsCalculator:GSCalculator;
		private var infoTextField:TextField;
		private var dataLoader:DataLoader;
		private var infoButton:InfoButton;
		private var alphaValue:Number;
		private var infoSprite:Sprite;
		private var interval:Number;
		private var diagram:Diagram;
		private var begin:Number;
		private var end:Number;
		
		public function MainWindow(main:Stage){
			main.addChild(this);
			var tf:TextField;
			
			if(root.loaderInfo.parameters["alphaValue"]==undefined) alphaValue = 0.1;
			else alphaValue = new Number(root.loaderInfo.parameters["alphaValue"]);
			
			if(root.loaderInfo.parameters["timeInterval"]==undefined) interval = 3;
			else interval = new Number(root.loaderInfo.parameters["timeInterval"]);

			launchFromFile();
		}
		
		public function get DATA():DataLoader{
			return dataLoader;
		}
		
		public function get GS_CALCULATOR():GSCalculator{
			return gsCalculator;
		}
		
		public function reprocess(newInt:Number,newAlp:Number):void{
			interval = newInt;
			alphaValue = newAlp;
			gsCalculator.addEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsReprocessedHandler);
			gsCalculator.launch(interval,alphaValue);
		}
		
		private function launchFromFile():void{
			var path:String;
			if(root.loaderInfo.parameters["path"]==undefined){
				path = "D:/Text-Mining (stage)/dev/FieldScanner 0.2/bin/field_data.txt";
			}else{
				path = root.loaderInfo.parameters["path"];
			}
			
			dataLoader = new DataLoader();
			dataLoader.addEventListener(DataLoader.ON_COMPLETED, onResultsFoundHandler);
			dataLoader.parse(path);
		}
		
		private function onGSCalculatorFinish(evt:Event):void{
			gsCalculator.removeEventListener(GSCalculator.IN_OUT_FINISH, onGSCalculatorFinish);
			
			trace("MainWindow.onGSCalculatorFinish:\n\tGSCalculator.IN_OUT_FINISH event received");
		}
		
		private function onResultsFoundHandler(evt:Event):void{
			gsCalculator = new GSCalculator(evt.target.wordsData,evt.target.beginYear,evt.target.endYear);
			gsCalculator.addEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsFinishedHandler);
			gsCalculator.launch(interval,alphaValue);
		}
		
		private function onCalculsFinishedHandler(evt:Event):void{
			begin = dataLoader.beginYear;
			end = dataLoader.endYear;
			
			diagram = new Diagram(this,begin,end);
			gsCalculator.removeEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsFinishedHandler);
			diagram.process(gsCalculator.wordsData,interval,alphaValue);
			
			infoButton = new InfoButton();
			with(infoButton){
				x = 220;
				y = 20;
				width = 30;
				height = 30;
				addEventListener(MouseEvent.MOUSE_DOWN,infoDownHandler);
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,infoUpHandler);
			setInfoToolTip();
			addChild(infoButton);
		}
		
		private function onCalculsReprocessedHandler(evt:Event):void{
			gsCalculator.removeEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsReprocessedHandler);
			diagram.resetPlayer();
			diagram.process(gsCalculator.wordsData,interval,alphaValue);
		}
		
		private function infoDownHandler(e:MouseEvent):void{
			this.stage.addChild(infoSprite);
		}
		
		private function infoUpHandler(e:MouseEvent):void{
			if(stage.contains(infoSprite))
				this.stage.removeChild(infoSprite);
		}
		
		private function setInfoToolTip():void{
			infoSprite = new Sprite();
			
			infoSprite.graphics.lineStyle(3,0x909090);
			infoSprite.graphics.beginFill(0xE0E0E0,0.8);
			infoSprite.graphics.drawRoundRect(270,10,stage.stageWidth-290,stage.stageHeight-20,20,20);
			
			infoTextField = new TextField();

			infoTextField.x = 280;
			infoTextField.y = 20;
			infoTextField.width = stage.stageWidth-310;
			infoTextField.height = stage.stageHeight-40;
			infoTextField.multiline = true;
			infoTextField.selectable = false;
			infoTextField.wordWrap = true;
			infoTextField.text = "Lorem ipsum:\n\nDolor sit amet, consectetur adipiscing elit. Morbi iaculis lobortis ultrices. Donec placerat quam ac nisl adipiscing condimentum. Nulla sodales nibh urna, sed dictum mauris. Vestibulum tellus elit, sagittis a semper non, rutrum sit amet sem. Pellentesque id auctor elit. Morbi enim tortor, viverra et tristique non, egestas a lorem. Phasellus tempor tellus in diam tincidunt congue. Morbi euismod facilisis tellus. Donec ullamcorper malesuada iaculis. Sed dictum molestie mauris, at dignissim lacus tempus eu. In in tincidunt libero. Vestibulum vel convallis diam. Phasellus id neque et neque sodales luctus. Nulla molestie, dolor sit amet egestas ornare, lorem augue posuere orci, quis viverra enim diam vitae nunc. Fusce rutrum auctor augue, ac feugiat odio sagittis vel. Donec condimentum rhoncus purus, sit amet egestas sapien iaculis ut. Maecenas quis massa a dui vehicula tincidunt. Vivamus nunc nulla, laoreet et tempor a, ultrices in erat. Duis tempus augue in nisl pulvinar luctus. Vivamus vitae eros nec erat imperdiet fringilla. Nulla quis ipsum est. Aenean et libero vitae risus pulvinar suscipit. Aenean ligula tortor, facilisis eget volutpat posuere, porttitor vel magna. Ut aliquam molestie purus, nec porttitor libero vestibulum ac. Curabitur vel lectus erat. Nullam sagittis imperdiet aliquet. Ut aliquam ultrices ligula ac mollis. In cursus laoreet sagittis. Donec vel sapien velit. Morbi convallis, ipsum a volutpat dignissim, lacus leo gravida mauris, ac pharetra mi nisi nec sem.\n\nIn dictum congue leo, in vehicula turpis euismod et. Nullam rhoncus fermentum cursus. Mauris a risus lorem. In quam nunc, fringilla ac malesuada eget, mollis eu lectus. Pellentesque et mi tellus, a pulvinar libero. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi varius sodales mattis. Proin facilisis fringilla eros, et consequat massa fringilla fermentum. Nullam turpis magna, congue vel ullamcorper vel, mattis non enim. Sed volutpat aliquam urna, sit amet sollicitudin lorem egestas et. In id neque ut urna dictum bibendum quis nec lorem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris id magna orci, eu euismod magna. Phasellus tempor feugiat lectus eget cursus. Phasellus consectetur ante eget leo placerat nec placerat lorem scelerisque. Integer vitae felis ultricies urna adipiscing euismod. Sed in ipsum eu lectus vulputate rutrum. Donec vestibulum dolor eget velit tincidunt tristique. Vivamus turpis metus, feugiat non ullamcorper in, laoreet sit amet velit. Nullam molestie fermentum ligula, non ornare velit feugiat vitae. Duis lacinia dictum lobortis. Integer id tellus est, eu mattis ligula. Pellentesque non turpis lacus, ac condimentum erat. Phasellus odio ipsum, accumsan ac condimentum vel, posuere eget nisl. Praesent massa enim, semper vitae volutpat et, feugiat nec felis. Cras dignissim volutpat libero, et suscipit est laoreet eu. Sed lacinia pharetra odio, vel pharetra sem rhoncus vel. Fusce id placerat lorem.\n\nNam placerat, enim a laoreet ultrices, magna ligula volutpat lectus, eu hendrerit lectus mi vitae velit. Integer sed sagittis tellus. Morbi blandit sem imperdiet est condimentum ultrices accumsan leo imperdiet. Curabitur egestas tempor faucibus. In ut risus in mauris fringilla varius. Mauris sed quam erat. Donec lobortis enim ac metus ullamcorper sodales. Pellentesque ullamcorper consequat dui, eget lacinia orci congue quis. Nullam vitae turpis egestas odio mollis mollis. Aliquam malesuada eros ut odio porta quis mattis sapien pellentesque.";
			infoTextField.setTextFormat(new TextFormat("Verdana",11));
			
			infoSprite.addChild(infoTextField);
			
		}
		
	}
}