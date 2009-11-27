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
		public var plotMode:String;
		
		
		public var mainWindow:MainWindow;
		
		public function Diagram(m:MainWindow){
			mainWindow = m;
			mainWindow.addChild(this);
			
			x = 340;
			y = 460;
		}
		
		public function get up():MainWindow{
			return mainWindow;
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
		
		protected function setWordsVector():void{
			var i:Number = 0;
			var j:Number = 0;
			var k:Number = 0;
			var tempValue:Number;
			var tempWord:Word;
			
			var stepNumber:Number = (endYear-beginYear)-(interval-1);
			var strArray:Array = wordsData.wordsArray;
			
			wordsData.createWordsVector();
			
			for(i=0;i<strArray.length;i++){
				tempWord = new Word(strArray[i]);
				tempWord.setLabel();
				wordsData.WORDS_VECTOR.push(tempWord);
				
				trace("Diagram.setWordsVector:\n\tNew word: "+tempWord.label);
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
		
		public function scaleAndPlotDiagram():void{
			
			trace("Diagram.children: "+this.numChildren);
			
			while(this.numChildren>0){
				this.removeChildAt(0);
				trace("Diagram.removeChild...");
			}
			
			graphics.beginFill(0xFFFFFF,1);
			graphics.drawRect(-30,30,470,-470);
			
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
			
//			var inAxisValuesArray:Array = getAxisValuesArray(inMax,inMin);
//			trace("\t\tinAxisValuesArray: "+inAxisValuesArray);
//			var outAxisValuesArray:Array = getAxisValuesArray(outMax,outMin);
//			trace("\t\toutAxisValuesArray: "+outAxisValuesArray);
			
			var inAxisValuesArray:Array = UNSCALED_AXIS;
			trace("\t\tinAxisValuesArray: "+inAxisValuesArray);
			var outAxisValuesArray:Array = UNSCALED_AXIS;
			trace("\t\toutAxisValuesArray: "+outAxisValuesArray);
			
			tempRatioX = (outAxisValuesArray[1]-outAxisValuesArray[0])*(outAxisValuesArray.length-1)/400;
			tempRatioY = (inAxisValuesArray[1]-inAxisValuesArray[0])*(inAxisValuesArray.length-1)/400;
			
			for(step=0;step<stepNumber;step++){
				graphsVector.push(new Sprite());
				tempContainer = graphsVector[graphsVector.length-1];
				
				tempIntervalField = new TextField();
				with(tempIntervalField){
					text = (beginYear+step).toString()+" - "+(beginYear+step+interval).toString();
					setTextFormat(new TextFormat("Arial",60,0xEFEFEF,true,true));
					selectable = false;
					autoSize = TextFieldAutoSize.LEFT;
					x = 20;
					y = -400;
				}
				
				tempContainer.addChild(tempIntervalField);
				
				with(tempContainer.graphics){
					lineStyle(1,0x000000);
					moveTo(0,-420);
					lineTo(0,0);
					lineTo(420,0);
				}
				
				tempLength = inAxisValuesArray.length;
				for(i=0;i<tempLength;i++){
					tempTField = new DiagramTextField();
					tempTField.text = roundToString(inAxisValuesArray[i]);
					tempTField.refresh();
					tempTField.x = i*400/(tempLength-1);
					tempTField.y = 0;
					tempContainer.addChild(tempTField);
					with(tempContainer.graphics){
						moveTo(i*400/(tempLength-1),0);
						lineTo(i*400/(tempLength-1),5);
					}
				}
				
				tempLength = outAxisValuesArray.length;
				for(i=0;i<tempLength;i++){
					tempTField = new DiagramTextField();
					tempTField.autoSize = TextFieldAutoSize.RIGHT;
					tempTField.text = roundToString(outAxisValuesArray[i]);
					tempTField.refresh();
					tempTField.x = -1*tempTField.width;
					tempTField.y = -1*i*400/(tempLength-1);
					tempContainer.addChild(tempTField);
					with(tempContainer.graphics){
						moveTo(0,-1*i*400/(tempLength-1));
						lineTo(-5,-1*i*400/(tempLength-1));
					}
				}
				
				for (i=0;i<wordsData.WORDS_VECTOR.length;i++){
					if(wordsData.WORDS_VECTOR[i].occurences[step]==0) continue;
					
					tempWordSprite = plotWord();
					with(tempWordSprite){
						x = ((wordsData.WORDS_VECTOR[i].outProxValues[step]-outAxisValuesArray[0])/tempRatioX);
						y = -1*((wordsData.WORDS_VECTOR[i].inProxValues[step]-inAxisValuesArray[0])/tempRatioY);
					}
					
					tempTField = new DiagramTextField();
					tempTField.autoSize = TextFieldAutoSize.CENTER;
					tempTField.text = wordsData.WORDS_VECTOR[i].label;
					tempTField.refresh();
					tempTField.x = tempWordSprite.x-tempTField.width/2;
					tempTField.y = tempWordSprite.y-tempTField.height/2;
					
					tempContainer.addChild(tempWordSprite);
					tempContainer.addChild(tempTField);
				}
			}
			
			if(optionsInterface==null) optionsInterface = new OptionsInterface(this);
			else optionsInterface.reset();
			
			indexOfImage = 0;
			addChild(graphsVector[0]);
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
		
		public function get LAST_FRAME():Boolean{
			return (indexOfImage==graphsVector.length-1);
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
		
		public function plotWord():Sprite{
			var tempSprite:Sprite = new Sprite();
			tempSprite.graphics.beginFill(0x446688,1);
			tempSprite.graphics.drawCircle(0,0,10);
			tempSprite.graphics.beginFill(0x446688,0.3);
			tempSprite.graphics.drawCircle(0,0,15);
			
			return(tempSprite);
		}
		
		public function getAxisValuesArray(max:Number,min:Number):Array{
			var difference:Number = max - min;
			var order:int = Math.round((Math.log(difference)/Math.LN10));
			var infMin:Number = Math.floor(min*Math.pow(10,(-1)*order))*Math.pow(10,order);
			var resultArray:Array = new Array();
			var tempToAdd:Number = Math.pow(10,order);
			var tempResult:Number = infMin-tempToAdd;
			
			var i:int = 0;
			resultArray.push(tempResult);
			
			while(tempResult<max+tempToAdd){
				tempResult = infMin+i*tempToAdd;
				resultArray.push(round(tempResult,-order));
				i++;
			}
			
			return(resultArray);
		}
		
		public function round(num:Number,p:int):Number{ 
			return(Math.round(num*Math.pow(10,p))/Math.pow(10,p));
		}
		
		public function roundToString(num:Number):String{ 
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
		
		public function roundToString2(num:Number):String{ 
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
		
		protected function printVector(vector:Vector.<Number>):void{
			for (var i:Number = 0;i<vector.length;i++){
				trace("\t\tColomn n°"+i+": value: "+vector[i]);
			}
		}
	}
}