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
    import flash.text.TextFieldAutoSize;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.SimpleButton;
	import com.fieldscanner.y2009.text.InputFormatTextField;
	import com.fieldscanner.y2009.calcul.GSCalculator;
	import com.fieldscanner.y2009.loading.DataLoader;
	import com.fieldscanner.y2009.graphics.Diagram;
	
	public class MainWindow extends Sprite{
		
		private var gsCalculator:GSCalculator;
		private var dataLoader:DataLoader;
		private var diagram:Diagram;
		
		private var alphaValue:Number;
		private var interval:Number;
		private var begin:Number;
		private var end:Number;
		
		public function MainWindow(main:Stage){
			
			main.addChild(this);
			
			if(root.loaderInfo.parameters["alphaValue"]==undefined) alphaValue = 0.1;
			else alphaValue = new Number(root.loaderInfo.parameters["alphaValue"]);
			
			if(root.loaderInfo.parameters["timeInterval"]==undefined) interval = 1;
			else interval = new Number(root.loaderInfo.parameters["timeInterval"]);

			launchFromFile();
		}
		
		public function reprocess(newInt:Number):void{
			interval = newInt;
			gsCalculator.launch(interval,alphaValue);
			gsCalculator.addEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsReprocessedHandler);
		}
		
		protected function launchFromFile():void{
			var path:String;
			if(root.loaderInfo.parameters["path"]==undefined){path = "D:/Text-Mining (stage)/dev/FieldScanner 0.2/bin/field_data2.txt";}
			else{path = root.loaderInfo.parameters["path"];}
			
			dataLoader = new DataLoader();
			dataLoader.addEventListener(DataLoader.ON_COMPLETED, onResultsFoundHandlerFromFile);
			dataLoader.parse(path);
		}
		
		protected function onGSCalculatorFinish(evt:Event):void{
			gsCalculator.removeEventListener(GSCalculator.IN_OUT_FINISH, onGSCalculatorFinish);
			
			trace("MainWindow.onGSCalculatorFinish:\n\tGSCalculator.IN_OUT_FINISH event received");
		}
		
		protected function onResultsFoundHandlerFromFile(evt:Event):void{
			trace(evt.target.wordsData);
			gsCalculator = new GSCalculator(evt.target.wordsData,evt.target.beginYear,evt.target.endYear);
			gsCalculator.addEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsFinishedHandlerFromFile);
			gsCalculator.launch(interval,alphaValue);
		}
		
		protected function onCalculsFinishedHandlerFromFile(evt:Event):void{
			diagram = new Diagram(this);
			gsCalculator.removeEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsFinishedHandlerFromFile);
			diagram.process(gsCalculator.wordsData,dataLoader.beginYear,dataLoader.endYear,interval);
		}
		
		protected function onCalculsReprocessedHandler(evt:Event):void{
			diagram = new Diagram(this);
			gsCalculator.removeEventListener(GSCalculator.IN_OUT_FINISH_ALL,onCalculsReprocessedHandler);
			diagram.process(gsCalculator.wordsData,begin,end,interval);
		}
		
	}
}