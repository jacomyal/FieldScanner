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
		
		private var indexes:Array;
		private var wordsData:Data;
		
		private var beginYear:Number;
		private var endYear:Number;
		private var diagramSize:Number;
		
		private var interval:Number;
		private var alphaValue:Number;
		
		private var indexOfImage:Number;
		private var indexParams:Array;
		private var displayMode:int;
		private var colorIndex:int;
		private var sizeIndex:int;
		
		private var optionsInterface:OptionsInterface;
		private var graphsVector:Vector.<Sprite>;
		
		public var mainWindow:MainWindow;
		
		public function Diagram(m:MainWindow,newBegin:int,newEnd:int){
			mainWindow = m;
			mainWindow.addChild(this);
			
			beginYear = newBegin;
			endYear = newEnd;
			diagramSize = 400;
			
			displayMode = 0;
			indexOfImage = 0;
			
			indexParams = [0xFFE241,0xBF1111,10,30];
			indexes = ["occurences"];
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
		
		public function get FRAMES_NUMBER():int{
			return graphsVector.length;
		}
		
		public function get FRAME():int{
			return indexOfImage;
		}
		
		public function get COLOR_INDEX():int{
			return colorIndex;
		}
		
		public function get SIZE_INDEX():int{
			return sizeIndex;
		}
		
		public function get INDEX_STATUS():Array{
			return indexParams;
		}
		
		public function get MAX_INTERVAL():int{
			return (endYear-beginYear);
		}
		
		public function get ALPHA():Number{
			return alphaValue;
		}
		
		public function get INTERVAL():int{
			return interval;
		}
		
		public function get START():int{
			return beginYear;
		}
		
		public function get END():int{
			return endYear;
		}
		
		public function get INDEXES():Array{
			return indexes;
		}
		
		public function get DIAGRAM_SIZE():Number{
			return diagramSize;
		}
		
		public function get MODE():int{
			return displayMode;
		}
		
		public function get WORDS():Data{
			return wordsData;
		}
		
		public function setIndexParams(a:Array,c:int,s:int):void{
			indexParams = a;
			colorIndex = c;
			sizeIndex = s;
			process(wordsData,interval,alphaValue);
		}
		
		public function changeDisplayMode(index:int):void{
			displayMode = index;
			trace("New display index: "+displayMode);
			process(wordsData,interval,alphaValue);
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
			
			optionsInterface.drawTimeLineCursor();
			
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
		
			optionsInterface.drawTimeLineCursor();
			return res;
		}
		
		public function goFirstFrame():void{
			removeChild(graphsVector[indexOfImage]);
			indexOfImage=0;
			addChild(graphsVector[0]);
			
			optionsInterface.drawTimeLineCursor();
		}
		
		public function process(newWordsData:Data,newI:Number,newAlp:Number):void{
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
			
			setSize();
			setColor();
			
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
				
				tempContainer = displayMapKey(tempContainer,[inMin,inMax,outMin,outMax]);
				tempContainer = displayDiagram(tempContainer,step,[inMin,inMax,outMin,outMax]);
			}
			
			if(optionsInterface==null) optionsInterface = new OptionsInterface(this);
			else optionsInterface.reset();
			
			setTimeLineForSize();
			setTimeLineForColor();
			
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
		
		private function setSize():void{
			var i:int=0;
			var step:int=0;
			var l:int = wordsData.WORDS_VECTOR.length;
			var indexMatrix:Array;
			var minValue:Number;
			var maxValue:Number;
			
			var minSize:Number = indexParams[2];
			var maxSize:Number = indexParams[3];
			
			if(sizeIndex==0){
				var a:Array = occurencesLocalIndex();
				
				minValue = a[0];
				maxValue = a[1];
				indexMatrix = a[2];
			}
			
			for(step=0;step<wordsData.WORDS_VECTOR[0].occurences.length;step++){
				for(i=0;i<l;i++){
					wordsData.WORDS_VECTOR[i].setDiameter(minSize+(indexMatrix[step][i]-minValue)*(maxSize-minSize)/(maxValue-minValue));
				}
			}
		}
		
		private function setColor():void{
			var i:int=0;
			var step:int=0;
			var l:int = wordsData.WORDS_VECTOR.length;
			var indexMatrix:Array;
			var sizeArray:Array = new Array();
			var minValue:Number;
			var maxValue:Number;
			
			var minColor:uint = indexParams[0];
			var maxColor:uint = indexParams[1];
			
			if(colorIndex==0){
				var a:Array = occurencesLocalIndex();
				
				minValue = a[0];
				maxValue = a[1];
				indexMatrix = a[2];
			}
			
			for(step=0;step<wordsData.WORDS_VECTOR[0].occurences.length;step++){
				for(i=0;i<l;i++){
					wordsData.WORDS_VECTOR[i].setColor(fadeHex(minColor,maxColor,(indexMatrix[step][i]-minValue)/(maxValue-minValue)));
				}
			}
		}
		
		private function setTimeLineForSize():void{
			var i:int=0;
			var step:int=0;
			var l:int = wordsData.WORDS_VECTOR.length;
			var indexMatrix:Array;
			var tempMiddle:Number;
			var resultArray:Array = new Array();
			
			if(sizeIndex==0){
				indexMatrix = occurencesLocalIndex()[2];
			}
			
			for(step=0;step<(endYear-beginYear-interval+1);step++){
				tempMiddle = 0;
				
				for(i=0;i<l;i++){
					tempMiddle += indexMatrix[step][i];
				}
				
				resultArray.push(tempMiddle/l);
			}
			
			optionsInterface.TIME_LINE.addClusterIndex(sizeIndex,resultArray,INDEXES[sizeIndex]+" (average value)",0xca5b46);
			optionsInterface.TIME_LINE.drawIndexes();
		}
		
		private function setTimeLineForColor():void{
			var i:int=0;
			var step:int=0;
			var l:int = wordsData.WORDS_VECTOR.length;
			var indexMatrix:Array;
			var tempMiddle:Number;
			var resultArray:Array = new Array();
			
			if(colorIndex!=sizeIndex){
				if(colorIndex==0){
					indexMatrix = occurencesLocalIndex()[2];
				}
				
				for(step=0;step<wordsData.WORDS_VECTOR[0].occurences.length;step++){
					tempMiddle = 0;
					
					for(i=0;i<l;i++){
						tempMiddle += indexMatrix[step][i];
					}
					
					resultArray.push(tempMiddle/l);
				}
				
				optionsInterface.TIME_LINE.addClusterIndex(colorIndex,resultArray,INDEXES[colorIndex]+" (average value)",0xca5b46);
				optionsInterface.TIME_LINE.drawIndexes();
			}
		}
		
		private function occurencesLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			
			minValue = wordsData.WORDS_VECTOR[i].occurences[step];
			maxValue = wordsData.WORDS_VECTOR[i].occurences[step];
			
			for(step=0;step<wordsData.WORDS_VECTOR[0].occurences.length;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					indexMatrix[step][i]=wordsData.WORDS_VECTOR[i].occurences[step];
					
					if(indexMatrix[step][i]<minValue) minValue=indexMatrix[step][i];
					if(indexMatrix[step][i]>maxValue) maxValue=indexMatrix[step][i];
				}
			}
			
			return [minValue,maxValue,indexMatrix];
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
		
		private function colorNorm(color:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			return ((blueOffset+greenOffset+redOffset)/3);
		}
	}
}