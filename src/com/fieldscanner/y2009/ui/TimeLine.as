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

package com.fieldscanner.y2009.ui{
	
	import com.fieldscanner.y2009.data.Index;
	import com.fieldscanner.y2009.graphics.Diagram;
	import com.fieldscanner.y2009.text.DiagramTextField;
	
	import fl.controls.CheckBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TimeLine extends Sprite{
		
		private var indexesList:Vector.<CheckBox>;
		private var indexesVector:Vector.<Index>;
		private var indexesCurves:Sprite;
		private var up:OptionsInterface;
		private var diagramSize:Number;
		private var localMouseX:Number;
		private var timeCursor:Sprite;
		private var diagram:Diagram;
		private var mapKey:Sprite;
		private var beginYear:int;
		private var interval:int;
		private var endYear:int;
		private var frame:int;
		
		public function TimeLine(newUp:OptionsInterface,newDiagram:Diagram){
			var i:int;
			var j:int;
			var a:Array;
			
			trace("New TimeLine created.");
			
			diagram = newDiagram;
			frame = diagram.FRAME;
			
			up = newUp;
			up.stage.addChild(this);
			
			diagramSize = diagram.DIAGRAM_SIZE;
			beginYear = diagram.START;
			endYear = diagram.END;
			
			x = 690-diagramSize;
			y = (diagramSize+60)+140;
			
			indexesVector = new Vector.<Index>();
			indexesList = new Vector.<CheckBox>();
			
			indexesCurves = new Sprite();
			addChild(indexesCurves);
			
			mapKey = new Sprite();
			addChild(mapKey);
			
			timeCursor = new Sprite();
			timeCursor.addEventListener(MouseEvent.MOUSE_DOWN,startXDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopXDrag);
			
			displayMapKey();
		}
		
		public function getIndex(name:String):Index{
			var i:int;
			var res:Index = null;
			
			for(i=0;i<indexesVector.length;i++){
				if(indexesVector[i].NAME==name){
					res = indexesVector[i];
				}
			}
			
			return res;
		}
		
		public function addClusterIndex(indexIndex:int,values:Array,indexName:String=null,indexColor:String="undefined"):void{
			var tempColor:uint;
			var tempIndex:Index;
			var i:int = indexesList.length;
			var tempCheckBox:CheckBox;
			
			if(getIndex(diagram.CLUSTER_INDEXES[indexIndex])==null){
				if(indexColor=="undefined"){
					tempColor = new uint(Math.round( Math.random()*0xFFFFFF));
				}else{
					tempColor = new uint(indexColor);
				}
				
				if(indexName!=null){
					tempIndex = new Index(indexName,values,indexIndex,tempColor);
				}else{
					tempIndex = new Index(diagram.CLUSTER_INDEXES[indexIndex],values,indexIndex,tempColor);
				}
				
				indexesVector.push(tempIndex);
			}
			
			tempCheckBox = new CheckBox();
			tempCheckBox.label = indexName;
			tempCheckBox.setStyle("textFormat",new TextFormat("Verdana",10,brightenColor(tempColor,30)));
			tempCheckBox.width = 200;
			tempCheckBox.x = -this.x+20;
			tempCheckBox.y = -70 + i*18;
			tempCheckBox.addEventListener(Event.CHANGE,onChangeCheckBox);
			
			if(i==0){
				tempCheckBox.selected = true;
			}else{
				tempCheckBox.selected = false;
			}
			
			addChild(tempCheckBox);
			indexesList.push(tempCheckBox);
			
			drawIndexes();
		}
		
		public function drawIndexes():void{
			var i:int;
			var j:int;
			var k:int;
			var completeInterval:int = endYear-beginYear+1;
			var maxValue:Number;
			var xTo:Number;
			var yTo:Number;
			var tempIndex:Index;
			var values:Array;
			var tempColor:uint;
			var indexName:String;
			var tempMiddle:Number;
			var selectedIndexes:Array = new Array();
			
			for(i=0;i<indexesList.length;i++){
				if(indexesList[i].selected){
					selectedIndexes.push(up.DIAGRAM.CLUSTER_INDEXES.indexOf(indexesList[i].label));
				}
			}
			
			indexesCurves.graphics.clear();
			
			while(indexesCurves.numChildren>0){
				indexesCurves.removeChildAt(0);
			}
			
			for(i=0;i<selectedIndexes.length;i++){
				tempIndex = indexesVector[selectedIndexes[i]];
				values = tempIndex.VALUES;
				tempColor = tempIndex.COLOR;
				indexName = tempIndex.NAME;
				maxValue = 0;
				xTo = 0;
				yTo = 0;
				
				for(j=0;j<values.length;j++){
					if(values[j]>maxValue) maxValue=values[j];
				}
				
				indexesCurves.graphics.lineStyle(2,tempColor);
				indexesCurves.graphics.moveTo(0,-values[0]*80/maxValue);
				
				j = 0;
				
				indexesCurves.graphics.lineStyle(1,tempColor,0.8);
				
				while(xTo+2<interval*diagramSize/completeInterval){
					indexesCurves.graphics.moveTo(xTo+1,yTo);
					indexesCurves.graphics.lineTo(xTo+2,yTo);
					
					xTo += 2;
				}
				
				xTo = interval*diagramSize/completeInterval;
				yTo = -values[j]*80/maxValue;
				
				indexesCurves.graphics.lineStyle(2,tempColor);
				
				while(j<values.length){
					xTo += diagramSize/completeInterval;
					yTo = -values[j]*80/maxValue;
					indexesCurves.graphics.lineTo(xTo,yTo);
					
					j++;
				}
				
				xTo = timeCursor.x;
				yTo = -values[frame-1]*80/maxValue;
				indexesCurves.graphics.lineStyle(2,brightenColor(tempColor,30));
				
				indexesCurves.graphics.moveTo(xTo,yTo);
				indexesCurves.graphics.lineTo(xTo+interval*diagramSize/completeInterval,yTo);
				indexesCurves.graphics.lineTo(xTo+interval*diagramSize/completeInterval-3,yTo+3);
				indexesCurves.graphics.moveTo(xTo+interval*diagramSize/completeInterval,yTo);
				indexesCurves.graphics.lineTo(xTo+interval*diagramSize/completeInterval-3,yTo-3);
			}
		}
		
		public function drawCursor(newInterval:int,currentFrame:int):void{
			var yearsNumber:int = endYear-beginYear+1;
			interval = newInterval;
			
			timeCursor.graphics.clear();
			timeCursor.graphics.beginFill(0x32b7d8,0.1);
			timeCursor.graphics.lineStyle(3,0x1b5b6b);
			timeCursor.graphics.drawRoundRect(0,0,interval*diagramSize/yearsNumber,95,5,5);
			timeCursor.x = currentFrame*diagramSize/yearsNumber;
			timeCursor.y = -90;
			
			frame = currentFrame;
			
			if(!this.contains(timeCursor)) this.addChild(timeCursor);
			
			drawIndexes();
		}
		
		private function displayMapKey():void{
			var i:int;
			var tf:DiagramTextField;
			var completeInterval:int = endYear-beginYear+1;
			
			trace("TimeLine.displayMapKey:\n\t"+completeInterval+" steps.");
			
			with(mapKey.graphics){
				lineStyle(1,0x000000);
				moveTo(0,0);
				lineTo(0,-100);
				moveTo(0,0);
				lineTo((diagramSize+20),0);
				
				lineStyle(2,0x000000);
				moveTo(-5,-92);
				lineTo(0,-100);
				lineTo(5,-92);
				moveTo(diagramSize+12,-5);
				lineTo(diagramSize+20,0);
				lineTo(diagramSize+12,5);
				
				lineStyle(1,0x000000);
			}
			
			for(i=0;i<=completeInterval;i++){
				if(i==0){
					tf = new DiagramTextField("little");
					tf.text = (beginYear+i).toString()+"\n(start year)";
					tf.x = diagramSize*i/completeInterval;
					tf.y = 11;
					tf.refresh();
					mapKey.addChild(tf);
					
					mapKey.graphics.moveTo(diagramSize*i/completeInterval,0);
					mapKey.graphics.lineTo(diagramSize*i/completeInterval,11);
				}else if(i==completeInterval){
					tf = new DiagramTextField("little");
					tf.text = (beginYear+i).toString()+"\n(end year)";
					tf.x = diagramSize*i/completeInterval;
					tf.y = 11;
					tf.refresh();
					mapKey.addChild(tf);
					
					mapKey.graphics.moveTo(diagramSize*i/completeInterval,0);
					mapKey.graphics.lineTo(diagramSize*i/completeInterval,3);
				}else if(!((i+beginYear)%5)){
					tf = new DiagramTextField("little");
					tf.text = (beginYear+i).toString();
					tf.x = diagramSize*i/completeInterval;
					tf.y = 2;
					tf.refresh();
					mapKey.addChild(tf);
					
					mapKey.graphics.moveTo(diagramSize*i/completeInterval,0);
					mapKey.graphics.lineTo(diagramSize*i/completeInterval,5);
				}else{
					mapKey.graphics.moveTo(diagramSize*i/completeInterval,0);
					mapKey.graphics.lineTo(diagramSize*i/completeInterval,3);
				}
			}
		}
		
		private function startXDrag(e:MouseEvent):void{
			up.stopPlaying();
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			localMouseX = this.mouseX - timeCursor.x;
		}
		
		private function stopXDrag(event:MouseEvent):void{
			var tempX:int;
			
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			tempX = Math.round(timeCursor.x/diagramSize*(endYear-beginYear+1))*diagramSize/(endYear-beginYear+1);
			tempX = Math.min(tempX,diagramSize-interval*diagramSize/(endYear-beginYear+1));
			tempX = Math.max(tempX,0);
			timeCursor.x = tempX;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			var oldFrame:int = frame;
			
			if(this.mouseX-localMouseX < 0){
				timeCursor.x = 0;
			}else if(this.mouseX-localMouseX > diagramSize-interval*diagramSize/(endYear-beginYear+1)){
				timeCursor.x = diagramSize-interval*diagramSize/(endYear-beginYear+1);
			}else{
				timeCursor.x = Math.round((this.mouseX-localMouseX)/diagramSize*(endYear-beginYear+1))*diagramSize/(endYear-beginYear+1);
			}
			
			frame = Math.round(timeCursor.x/diagramSize*(endYear-beginYear+1));
			
			if(frame!=oldFrame){
				diagram.goFrame(frame);
				up.setTimeSliderFrame(frame);
				drawIndexes();
			}
		}
		
		private function onChangeCheckBox(e:Event):void{
			drawIndexes();
		}
		
		private function brightenColor(color:Number, perc:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			if(perc > 50 && perc <= 100) {
				factor = ( ( perc-50 ) / 50 );
				
				redOffset += ( 255 - redOffset ) * factor;
				blueOffset += ( 255 - blueOffset ) * factor;
				greenOffset += ( 255 - greenOffset ) * factor;
			}
			else if( perc < 50 && perc >= 0 ){
				factor = ( ( 50 - perc ) / 50 );
				
				redOffset -= redOffset * factor;
				blueOffset -= blueOffset * factor;
				greenOffset -= greenOffset * factor;
			}
			
			return (redOffset<<16|greenOffset<<8|blueOffset);
		}
	}
}