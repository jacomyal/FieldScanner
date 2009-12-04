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
		
		public var INDEXES:Array;
		
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
		public var indexParams:Array;
		public var colorIndex:int;
		public var sizeIndex:int;
		
		public var mainWindow:MainWindow;
		
		public function Diagram(m:MainWindow){
			mainWindow = m;
			mainWindow.addChild(this);
			
			diagramSize = 400;
			
			displayMode = 0;
			indexOfImage = 0;
			
			indexParams = [0xFFE241,0xBF1111,10,30];
			INDEXES = ["occurences"];
			colorIndex = 0;
			sizeIndex = 0;
			
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
		
		public function setIndexParams(a:Array,c:int,s:int):void{
			indexParams = a;
			colorIndex = c;
			sizeIndex = s;
			process(wordsData,beginYear,endYear,interval,alphaValue);
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
			}
			
			graphics.beginFill(0xFFFFFF,1);
			graphics.drawRect(-30,30,(diagramSize+70),-(diagramSize+70));
			
			trace("Diagram.scaleAndPlotDiagram:\n\tPlot the diagrams...");
			var i:Number = 0;
			var tempLength:Number;
			var tempValue:Number;
			var tempTField:DiagramTextField;
			
			var step:Number = 0;
			var stepNumber:Number = wordsData.WORDS_VECTOR[0].occurences.length;
			
			var measures:Array = getMeasuresForLocalDisplay();
			var tempContainer:Sprite;
			var tempIntervalField:TextField;
			var inMin:Number = wordsData.WORDS_VECTOR[0].inProxValues[0];
			var inMax:Number = wordsData.WORDS_VECTOR[0].inProxValues[0];
			var outMin:Number = wordsData.WORDS_VECTOR[0].outProxValues[0];
			var outMax:Number = wordsData.WORDS_VECTOR[0].outProxValues[0];
			
			if(displayMode==0){
				trace("Diagram.scaleAndPlotDiagram:\n\tDisplay mode: Normal view:");
				inMin = 0;
				inMax = 1;
				outMin = 0;
				outMax = 1;
				
			}else if(displayMode==1){
				
				trace("WORDS VECTOR LENGTH: "+wordsData.WORDS_VECTOR.length);
				trace("STEP NUMBER: "+stepNumber);
				for (i=0;i<wordsData.WORDS_VECTOR.length;i++){
					for(step=0;step<stepNumber;step++){
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] < inMin){
							inMin = wordsData.WORDS_VECTOR[i].inProxValues[step];
						}else if(wordsData.WORDS_VECTOR[i].inProxValues[step] > inMax){
							inMax = wordsData.WORDS_VECTOR[i].inProxValues[step];
						}
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] < outMin){
							outMin = wordsData.WORDS_VECTOR[i].outProxValues[step];
						}else if(wordsData.WORDS_VECTOR[i].outProxValues[step] > outMax){
							outMax = wordsData.WORDS_VECTOR[i].outProxValues[step];
						}
					}
				}
				
				trace("Diagram.scaleAndPlotDiagram:\n\tDisplay mode: Scaled view:");
				trace("\t\tinMax: "+roundToString(inMax)+", inMin: "+roundToString(inMin));
				trace("\t\toutMax: "+roundToString(outMax)+", outMin: "+roundToString(outMin));
			}
			
			for(step=0;step<stepNumber;step++){
				graphsVector.push(new Sprite());
				tempContainer = graphsVector[graphsVector.length-1];
				
				if(displayMode==2){
					inMin = wordsData.WORDS_VECTOR[0].inProxValues[step];
					inMax = wordsData.WORDS_VECTOR[0].inProxValues[step];
					outMin = wordsData.WORDS_VECTOR[0].outProxValues[step];
					outMax = wordsData.WORDS_VECTOR[0].outProxValues[step];
					
					for (i=0;i<wordsData.WORDS_VECTOR.length;i++){
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] < inMin)
							inMin = wordsData.WORDS_VECTOR[i].inProxValues[step];
						if(wordsData.WORDS_VECTOR[i].inProxValues[step] > inMax)
							inMax = wordsData.WORDS_VECTOR[i].inProxValues[step];
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] < outMin)
							outMin = wordsData.WORDS_VECTOR[i].outProxValues[step];
						if(wordsData.WORDS_VECTOR[i].outProxValues[step] > outMax)
							outMax = wordsData.WORDS_VECTOR[i].outProxValues[step];
					}
					
					inMin = (inMin+inMax-measures[0])/2;
					outMin = (outMin+outMax-measures[1])/2;
					inMax = (inMin+inMax+measures[0])/2;
					outMax = (outMin+outMax+measures[1])/2;
				}
				
				setSize(step);
				setColor(step);
				
				tempContainer = displayMapKey(tempContainer,[inMin,inMax,outMin,outMax]);
				tempContainer = displayDiagram(tempContainer,step,[inMin,inMax,outMin,outMax]);
			}
			
			if(optionsInterface==null) optionsInterface = new OptionsInterface(this);
			else optionsInterface.reset();
			
			addChild(graphsVector[indexOfImage]);
		}
		
		private function displayMapKey(s:Sprite,borders:Array):Sprite{
			var tf:DiagramTextField;
			var pos:Number;
			var im:Number = borders[0];
			var iM:Number = borders[1];
			var om:Number = borders[2];
			var oM:Number = borders[3];
			
			with(s.graphics){
				lineStyle(1,0x000000);
				moveTo(0,-(diagramSize+20));
				lineTo(0,0);
				lineTo((diagramSize+20),0);
			}
			
			pos = round((Math.floor((im*10)+1))/10,1);

			while(pos<iM){
				tf = new DiagramTextField();
				tf.text = roundToString(pos);
				tf.refresh();
				tf.x = diagramSize*(pos-im)/(iM-im);
				tf.y = 0;
				s.addChild(tf);
				with(s.graphics){
					moveTo(diagramSize*(pos-im)/(iM-im),0);
					lineTo(diagramSize*(pos-im)/(iM-im),5);
				}
				
				pos += 0.1;
				pos = round(pos,1);
			}
			
			pos = round((Math.floor((om*10)+1))/10,1);
			
			while(pos<oM){
				tf = new DiagramTextField();
				tf.autoSize = TextFieldAutoSize.RIGHT;
				tf.text = roundToString(pos);
				tf.refresh();
				tf.x = -1*tf.width;
				tf.y = -1*diagramSize*(pos-om)/(oM-om);
				s.addChild(tf);
				with(s.graphics){
					moveTo(0,-1*diagramSize*(pos-om)/(oM-om));
					lineTo(-5,-1*diagramSize*(pos-om)/(oM-om));
				}
				
				pos += 0.1;
				pos = round(pos,1);
			}
			
			return(s);
		}
		
		private function displayDiagram(s:Sprite,step:int,borders:Array):Sprite{
			var tf:TextField = new TextField();
			var w:DisplayWord;
			var i:int;
			
			var im:Number = borders[0];
			var iM:Number = borders[1];
			var om:Number = borders[2];
			var oM:Number = borders[3];
			
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
					x = diagramSize*(wordsData.WORDS_VECTOR[i].inProxValues[step]-im)/(iM-im);
					y = -1*diagramSize*(wordsData.WORDS_VECTOR[i].outProxValues[step]-om)/(oM-om);
				}
				
				s.addChild(w);
			}
			
			return(s);
		}
		
		private function getMeasuresForLocalDisplay():Array{
			var step:int;
			var i:int;
			
			var inMin:Number;
			var inMax:Number;
			var outMin:Number;
			var outMax:Number;
			
			var inDiffMax:Number = 0;
			var outDiffMax:Number = 0;
			
			for(step=0;step<wordsData.WORDS_VECTOR[0].occurences.length;step++){
				inMin = wordsData.WORDS_VECTOR[0].inProxValues[step];
				inMax = wordsData.WORDS_VECTOR[0].inProxValues[step];
				outMin = wordsData.WORDS_VECTOR[0].outProxValues[step];
				outMax = wordsData.WORDS_VECTOR[0].outProxValues[step];
				
				for (i=1;i<wordsData.WORDS_VECTOR.length;i++){
					if(wordsData.WORDS_VECTOR[i].inProxValues[step] < inMin){
						inMin = wordsData.WORDS_VECTOR[i].inProxValues[step];
					}else if(wordsData.WORDS_VECTOR[i].inProxValues[step] > inMax){
						inMax = wordsData.WORDS_VECTOR[i].inProxValues[step];
					}
					if(wordsData.WORDS_VECTOR[i].outProxValues[step] < outMin){
						outMin = wordsData.WORDS_VECTOR[i].outProxValues[step];
					}else if(wordsData.WORDS_VECTOR[i].outProxValues[step] > outMax){
						outMax = wordsData.WORDS_VECTOR[i].outProxValues[step];
					}
				}
				
				if((inMax-inMin)>inDiffMax) inDiffMax = inMax-inMin;
				if((outMax-outMin)>outDiffMax) outDiffMax = outMax-outMin;
			}
			
			return [inDiffMax,outDiffMax];
		}
		
		private function setSize(step:int):void{
			var i:int;
			var l:int = wordsData.WORDS_VECTOR.length;
			var indexArray:Array = new Array();
			var sizeArray:Array = new Array();
			var minValue:Number;
			var maxValue:Number;
			
			var minSize:Number = indexParams[2];
			var maxSize:Number = indexParams[3];
			
			if(sizeIndex==0){
				minValue = wordsData.WORDS_VECTOR[i].occurences[step];
				maxValue = wordsData.WORDS_VECTOR[i].occurences[step];
				
				for(i=0;i<l;i++){
					indexArray[i]=wordsData.WORDS_VECTOR[i].occurences[step];
					
					if(indexArray[i]<minValue) minValue=indexArray[i];
					if(indexArray[i]>maxValue) maxValue=indexArray[i];
				}
			}
			
			for(i=0;i<l;i++){
				wordsData.WORDS_VECTOR[i].setDiameter(minSize+(indexArray[i]-minValue)*(maxSize-minSize)/(maxValue-minValue));
			}
		}
		
		private function setColor(step:int):void{
			var i:int;
			var l:int = wordsData.WORDS_VECTOR.length;
			var indexArray:Array = new Array();
			var sizeArray:Array = new Array();
			var minValue:Number;
			var maxValue:Number;
			
			var minColor:uint = indexParams[0];
			var maxColor:uint = indexParams[1];
			
			if(colorIndex==0){
				minValue = wordsData.WORDS_VECTOR[i].occurences[step];
				maxValue = wordsData.WORDS_VECTOR[i].occurences[step];
				
				for(i=0;i<l;i++){
					indexArray[i]=wordsData.WORDS_VECTOR[i].occurences[step];
					
					if(indexArray[i]<minValue) minValue=indexArray[i];
					if(indexArray[i]>maxValue) maxValue=indexArray[i];
				}
			}
			
			for(i=0;i<l;i++){
				wordsData.WORDS_VECTOR[i].setColor(fadeHex(minColor,maxColor,(indexArray[i]-minValue)/(maxValue-minValue)));
			}
		}
		
		private function fadeHex(hex:uint, hex2:uint, ratio:Number):uint{
			var r:uint = hex >> 16;
			var g:uint = hex >> 8 & 0xFF;
			var b:uint = hex & 0xFF;
			r += ((hex2 >> 16)-r)*ratio;
			g += ((hex2 >> 8 & 0xFF)-g)*ratio;
			b += ((hex2 & 0xFF)-b)*ratio;
			return(r<<16 | g<<8 | b);
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
	}
}