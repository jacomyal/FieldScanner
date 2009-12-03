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

package com.fieldscanner.y2009.graphics {
	
	import com.fieldscanner.y2009.data.Data;
	import com.fieldscanner.y2009.data.Word;
	import com.fieldscanner.y2009.text.DiagramTextField;
	import com.fieldscanner.y2009.ui.MainWindow;
	import com.fieldscanner.y2009.ui.OptionsInterface;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Diagram extends Sprite{
		
		public static const SCALED:String = "Scaled mode.";
		public static const UNSCALED:String = "Unscaled mode.";
		public static const UNSCALED_AXIS:Array = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
		
		public var wordsData:Data;
		public var graphsVector:Vector.<Sprite>;
		public var beginYear:Number;
		public var endYear:Number;
		public var interval:Number;
		public var alphaValue:Number;
		public var indexOfImage:Number;
		public var optionsInterface:OptionsInterface;
		public var displayMode:int;
		public var diagramSize:Number;
		
		public var mainWindow:MainWindow;
		
		public function Diagram(m:MainWindow){
			mainWindow = m;
			mainWindow.addChild(this);
			
			diagramSize = 400;
			
			displayMode = 0;
			indexOfImage = 0;
			
			x = (diagramSize-60);
			y = (diagramSize+60);
		}
		
		public function get up():MainWindow{
			return mainWindow;
		}
		
		public function get LAST_FRAME():Boolean{
			return (indexOfImage==graphsVector.length-1);
		}
		
		public function get MODE():int{
			return displayMode;
		}
		
		public function changeDisplayMode(index:int):void{
			displayMode = index;
			trace("New display index: "+displayMode);
			process(wordsData,beginYear,endYear,interval,alphaValue);
		}
		
		public function resetPlayer():void{
			indexOfImage = 0;
		}
		
		public function goNextFrame():Boolean{
			var res:Boolean = false;
			
			if(indexOfImage!=graphsVector.length-1){
				removeChild(graphsVector[indexOfImage]);
				indexOfImage+=1;
				addChild(graphsVector[indexOfImage]);
				
				res=true;
			}else{
				res=false;
			}
			
			return res;
		}
		
		public function goFrame(i:Number):Boolean{
			var res:Boolean = false;
			
			if(i<graphsVector.length){
				removeChild(graphsVector[indexOfImage]);
				indexOfImage = i;
				addChild(graphsVector[indexOfImage]);
				
				res=true;
			}else{
				res=false;
			}
			
			return res;
		}
		
		public function goFirstFrame():void{
			removeChild(graphsVector[indexOfImage]);
			indexOfImage=0;
			addChild(graphsVector[0]);
		}
		
		public function process(newWordsData:Data,newBY:Number,newEY:Number,newI:Number,newAlp:Number):void{
			beginYear = newBY;
			endYear = newEY;
			interval = newI;
			alphaValue = newAlp;
			wordsData = newWordsData;
			graphsVector = new Vector.<Sprite>();
			
			setWordsVector();
		}
		
		private function setWordsVector():void{
			var i:Number = 0;
			var j:Number = 0;
			var k:Number = 0;
			var tempValue:Number;
			var tempWord:Word;
			
			var stepNumber:Number = (endYear-beginYear)-(interval-1);
			var strArray:Array = wordsData.wordsArray;
			
			if(wordsData.WORDS_VECTOR==null){
				wordsData.createWordsVector();
				
				for(i=0;i<strArray.length;i++){
					tempWord = new Word(strArray[i]);
					tempWord.setLabel();
					wordsData.WORDS_VECTOR.push(tempWord);
					
					trace("Diagram.setWordsVector:\n\tNew word: "+tempWord.label);
				}
			}
			
			for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
				wordsData.WORDS_VECTOR[i].inProxValues = new Vector.<Number>();
				wordsData.WORDS_VECTOR[i].outProxValues = new Vector.<Number>();
				wordsData.WORDS_VECTOR[i].occurences = new Vector.<Number>();
				
				for(j=0;j<stepNumber;j++){
					
					tempValue = 0;
					wordsData.WORDS_VECTOR[i].inProxValues.push(wordsData.getIn(i,j));
					wordsData.WORDS_VECTOR[i].outProxValues.push(wordsData.getOut(i,j));
					
					for(k=0;k<interval;k++){
						tempValue += wordsData.getWordOcc(i,i,j+k);
					}
					
					wordsData.WORDS_VECTOR[i].occurences.push(tempValue);
				}
			}
			
			trace("Diagram.setWordsVector:\n\tWords all set.");
			
			scaleAndPlotDiagram();
		}
		
		private function scaleAndPlotDiagram():void{
			trace("Diagram.children: "+this.numChildren);
			
			while(this.numChildren>0){
				this.removeChildAt(0);
				trace("Diagram.removeChild...");
			}
			
			graphics.beginFill(0xFFFFFF,1);
			graphics.drawRect(-30,30,(diagramSize+70),-(diagramSize+70));
			
			trace("Diagram.scaleAndPlotDiagram:\n\tPlot the diagrams...");
			var i:Number = 0;
			var tempLength:Number;
			var tempValue:Number;
			var tempTField:DiagramTextField;
			var tempWordSprite:Sprite;
			var tempRatioX:Number;
			var tempRatioY:Number;
			
			var step:Number = 0;
			var stepNumber:Number = wordsData.WORDS_VECTOR[0].occurences.length;
			
			var tempContainer:Sprite;
			var tempIntervalField:TextField;
			var inMin:Number = wordsData.WORDS_VECTOR[0].inProxValues[step];
			var inMax:Number = wordsData.WORDS_VECTOR[0].inProxValues[step];
			var outMin:Number = wordsData.WORDS_VECTOR[0].outProxValues[step];
			var outMax:Number = wordsData.WORDS_VECTOR[0].outProxValues[step];
			
			var inAxisValuesArray:Array;
			var outAxisValuesArray:Array;
			
			if(displayMode!=2){
				for(step=0;step<stepNumber;step++){
					for (i=1;i<wordsData.WORDS_VECTOR.length;i++){
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] < inMin)
							inMin = wordsData.WORDS_VECTOR[i].inProxValues[step];
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] > inMax)
							inMax = wordsData.WORDS_VECTOR[i].inProxValues[step];
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] < outMin)
							outMin = wordsData.WORDS_VECTOR[i].outProxValues[step];
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] > outMax)
							outMax = wordsData.WORDS_VECTOR[i].outProxValues[step];
					}
				}
				
				trace("\t\tinMax: "+roundToString2(inMax)+", inMin: "+roundToString2(inMin));
				trace("\t\toutMax: "+roundToString2(outMax)+", outMin: "+roundToString2(outMin));
			}
			
			if(displayMode==0){
				inAxisValuesArray = UNSCALED_AXIS;
				trace("\t\tinAxisValuesArray: "+inAxisValuesArray);
				outAxisValuesArray = UNSCALED_AXIS;
				trace("\t\toutAxisValuesArray: "+outAxisValuesArray);
				
				tempRatioX = (inAxisValuesArray[1]-inAxisValuesArray[0])*(inAxisValuesArray.length-1)/400;
				tempRatioY = (outAxisValuesArray[1]-outAxisValuesArray[0])*(outAxisValuesArray.length-1)/400;
			}else if(displayMode==1){
				inAxisValuesArray = getAxisValuesArray(inMax,inMin,outMax,outMin)[0];
				trace("\t\tinAxisValuesArray: "+inAxisValuesArray);
				outAxisValuesArray = getAxisValuesArray(inMax,inMin,outMax,outMin)[1];
				trace("\t\toutAxisValuesArray: "+outAxisValuesArray);
				
				tempRatioX = (inAxisValuesArray[1]-inAxisValuesArray[0])*(inAxisValuesArray.length-1)/400;
				tempRatioY = (outAxisValuesArray[1]-outAxisValuesArray[0])*(outAxisValuesArray.length-1)/400;
			}
			
			for(step=0;step<stepNumber;step++){
				graphsVector.push(new Sprite());
				tempContainer = graphsVector[graphsVector.length-1];
				
				if(displayMode==2){
					inMin = wordsData.WORDS_VECTOR[0].inProxValues[step];
					inMax = wordsData.WORDS_VECTOR[0].inProxValues[step];
					outMin = wordsData.WORDS_VECTOR[0].outProxValues[step];
					outMax = wordsData.WORDS_VECTOR[0].outProxValues[step];
					
					for (i=1;i<wordsData.WORDS_VECTOR.length;i++){
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] < inMin)
							inMin = wordsData.WORDS_VECTOR[i].inProxValues[step];
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] > inMax)
							inMax = wordsData.WORDS_VECTOR[i].inProxValues[step];
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] < outMin)
							outMin = wordsData.WORDS_VECTOR[i].outProxValues[step];
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] > outMax)
							outMax = wordsData.WORDS_VECTOR[i].outProxValues[step];
					}
					
					inAxisValuesArray = getAxisValuesArray(inMax,inMin,outMax,outMin)[0];
					outAxisValuesArray = getAxisValuesArray(inMax,inMin,outMax,outMin)[1];
					
					tempRatioX = (inAxisValuesArray[1]-inAxisValuesArray[0])*(inAxisValuesArray.length-1)/diagramSize;
					tempRatioY = (outAxisValuesArray[1]-outAxisValuesArray[0])*(outAxisValuesArray.length-1)/diagramSize;
				}
				
				tempContainer = displayMapKey(tempContainer,inAxisValuesArray,outAxisValuesArray);
				tempContainer = displayDiagram(tempContainer,step,[inAxisValuesArray[0],outAxisValuesArray[0],tempRatioX,tempRatioY]);
			}
			
			if(optionsInterface==null) optionsInterface = new OptionsInterface(this);
			else optionsInterface.reset();
			
			addChild(graphsVector[indexOfImage]);
		}
		
		private function displayMapKey(s:Sprite,inAxis:Array,outAxis:Array):Sprite{
			var l:int;
			var i:int;
			var tf:DiagramTextField;
			
			with(s.graphics){
				lineStyle(1,0x000000);
				moveTo(0,-(diagramSize+20));
				lineTo(0,0);
				lineTo((diagramSize+20),0);
			}
			
			l = inAxis.length;
			for(i=0;i<l;i++){
				tf = new DiagramTextField();
				tf.text = roundToString(inAxis[i]);
				tf.refresh();
				tf.x = i*diagramSize/(l-1);
				tf.y = 0;
				s.addChild(tf);
				with(s.graphics){
					moveTo(i*diagramSize/(l-1),0);
					lineTo(i*diagramSize/(l-1),5);
				}
			}
			
			l = outAxis.length;
			for(i=0;i<l;i++){
				tf = new DiagramTextField();
				tf.autoSize = TextFieldAutoSize.RIGHT;
				tf.text = roundToString(outAxis[i]);
				tf.refresh();
				tf.x = -1*tf.width;
				tf.y = -1*i*diagramSize/(l-1);
				s.addChild(tf);
				with(s.graphics){
					moveTo(0,-1*i*diagramSize/(l-1));
					lineTo(-5,-1*i*diagramSize/(l-1));
				}
			}
			
			return(s);
		}
		
		private function displayDiagram(s:Sprite,step:int,ref:Array):Sprite{
			var tf:TextField = new TextField();
			var w:DisplayWord;
			var i:int;
			
			var inMin:Number = ref[0];
			var outMin:Number = ref[1];
			var inRatio:Number = ref[2];
			var outRatio:Number = ref[3];
			
			with(tf){
				text = (beginYear+step).toString()+" - "+(beginYear+step+interval).toString();
				setTextFormat(new TextFormat("Arial",60,0xDEDEDE,true,true));
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 20;
				y = -diagramSize;
			}
			
			s.addChild(tf);
			
			for (i=0;i<wordsData.WORDS_VECTOR.length;i++){
				if(wordsData.WORDS_VECTOR[i].occurences[step]==0) continue;
				w = new DisplayWord(wordsData.WORDS_VECTOR[i]);
				
				with(w){
					plot();
					x = ((wordsData.WORDS_VECTOR[i].inProxValues[step]-inMin)/inRatio);
					y = -1*((wordsData.WORDS_VECTOR[i].outProxValues[step]-outMin)/outRatio);
				}
				
				s.addChild(w);
			}
			
			return(s);
		}
		
		private function getAxisValuesArray(xMax:Number,xMin:Number,yMax:Number,yMin:Number):Array{
			var xDifference:Number = xMax - xMin;
			var yDifference:Number = yMax - yMin;
			var order:int = -1;

			var xInfMin:Number = Math.floor(xMin*Math.pow(10,(-1)*order))*Math.pow(10,order);
			var yInfMin:Number = Math.floor(yMin*Math.pow(10,(-1)*order))*Math.pow(10,order);
			
			var xResultArray:Array = new Array();
			var yResultArray:Array = new Array();
			
			var tempToAdd:Number = Math.pow(10,order);
			var tempResult:Number;
			
			var i:int = 0;
			
			tempResult = xInfMin-tempToAdd;
			xResultArray.push(tempResult);
			
			while(tempResult<xMax+tempToAdd){
				tempResult = xInfMin+i*tempToAdd;
				xResultArray.push(round(tempResult,-order));
				i++;
			}
			
			i = 0;
			
			tempResult = yInfMin-tempToAdd;
			yResultArray.push(tempResult);
			
			while(tempResult<yMax+tempToAdd){
				tempResult = yInfMin+i*tempToAdd;
				yResultArray.push(round(tempResult,-order));
				i++;
			}
			
			var res:Array = new Array();
			res.push(xResultArray);
			res.push(yResultArray);
			
			return(res);
		}
		
		private function round(num:Number,p:int):Number{ 
			return(Math.round(num*Math.pow(10,p))/Math.pow(10,p));
		}
		
		private function roundToString(num:Number):String{ 
			var i:int = 0;
			var tempStr:String = num.toString();
			var tempChar:String = tempStr.charAt(i);
			var resultStr:String = tempChar;
			
			while(tempChar=="0" || tempChar=="," || tempChar=="." || tempChar=="-"){
				i++;
				tempChar=tempStr.charAt(i);
				resultStr += tempChar;
			}
			
			i++;
			
			if(tempChar!="0"){
				tempChar=tempStr.charAt(i);
				resultStr += tempChar;
			}
			
			return(resultStr);
		}
		
		private function roundToString2(num:Number):String{ 
			var i:int = 0;
			var tempStr:String = num.toString();
			var tempChar:String = tempStr.charAt(i);
			var resultStr:String = tempChar;
			
			while(tempChar=="0" || tempChar=="," || tempChar=="." || tempChar=="-"){
				i++;
				tempChar=tempStr.charAt(i);
				resultStr += tempChar;
			}
			
			i++;
			tempChar=tempStr.charAt(i);
			resultStr += tempChar;
			
			i++;
			tempChar=tempStr.charAt(i);
			resultStr += tempChar;
			
			return(resultStr);
		}
		
		private function printVector(vector:Vector.<Number>):void{
			for (var i:Number = 0;i<vector.length;i++){
				trace("\t\tColomn n°"+i+": value: "+vector[i]);
			}
		}
	}
}