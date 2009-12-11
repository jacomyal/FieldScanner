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
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TimeLine extends Sprite{
		
		private var indexesVector:Vector.<Index>;
		private var up:OptionsInterface;
		private var diagram:Diagram;
		private var diagramSize:Number;
		private var beginYear:int;
		private var endYear:int;
		private var timeCursor:Sprite;
		private var indexesCurves:Sprite;
		private var mapKey:Sprite;
		
		private var interval:int;
		private var localMouseX:Number;
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
			
			x = diagramSize-70;
			y = (diagramSize+60)+140;
			
			indexesVector = new Vector.<Index>();
			
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
			
			if(getIndex(diagram.INDEXES[indexIndex])==null){
				if(indexColor=="undefined"){
					tempColor = new uint(Math.round( Math.random()*0xFFFFFF));
				}else{
					tempColor = new uint(indexColor);
				}
				
				if(indexName!=null){
					tempIndex = new Index(indexName,values,indexIndex,tempColor);
				}else{
					tempIndex = new Index(diagram.INDEXES[indexIndex],values,indexIndex,tempColor);
				}
				
				indexesVector.push(tempIndex);
			}
		}
		
		public function drawIndexes():void{
			var i:int;
			var j:int;
			var k:int;
			var completeInterval:int = endYear-beginYear;
			var maxValue:Number = 0;
			var labelField:TextField;
			var textFormat:TextFormat;
			var xTo:Number;
			var yTo:Number;
			var tempIndex:Index;
			var values:Array;
			var tempColor:uint;
			var indexName:String;
			var tempMiddle:Number;
			
			indexesCurves.graphics.clear();
			
			while(indexesCurves.numChildren>0){
				indexesCurves.removeChildAt(0);
			}
			for(i=0;i<indexesVector.length;i++){
				tempIndex = indexesVector[i];
				values = tempIndex.VALUES;
				tempColor = tempIndex.COLOR;
				indexName = tempIndex.NAME;
				xTo = 0;
				
				for(j=0;j<values.length;j++){
					if(values[j]>maxValue) maxValue=values[j];
				}
				
				indexesCurves.graphics.lineStyle(2,tempColor);
				indexesCurves.graphics.moveTo(0,-values[0]*80/maxValue);
				
				j = 0;
				
				if(frame!=0){
					while(xTo<timeCursor.x-0.001){
						xTo += diagramSize/completeInterval;
						yTo = -values[j]*80/maxValue;
						indexesCurves.graphics.lineTo(xTo,yTo);
						
						j++;
					}
				}
				
				tempMiddle = 0;
				for(k=0;k<interval+1;k++){
					tempMiddle += values[j+k-1];
				}
				tempMiddle = tempMiddle/(interval+1);
				
				yTo = -tempMiddle*80/maxValue;
				
				indexesCurves.graphics.lineStyle(3,tempColor);
				indexesCurves.graphics.moveTo(xTo,yTo);
				
				xTo += interval*diagramSize/(endYear-beginYear);
				
				indexesCurves.graphics.lineTo(xTo,yTo);
				indexesCurves.graphics.lineStyle(2,tempColor);
				
				j += interval-1;
				yTo = -values[j]*80/maxValue;
				indexesCurves.graphics.moveTo(xTo,yTo);
				j++;
				
				while(j<values.length){
					xTo += diagramSize/completeInterval;
					yTo = -values[j]*80/maxValue;
					indexesCurves.graphics.lineTo(xTo,yTo);
					
					j++;
				}
				
				indexesCurves.graphics.lineStyle(1,tempColor,0.8);
				
				while(xTo+2<diagramSize){
					indexesCurves.graphics.moveTo(xTo+1,yTo);
					indexesCurves.graphics.lineTo(xTo+2,yTo);
					
					xTo += 2;
				}
				
				textFormat = new TextFormat("Verdana",12,brightenColor(tempColor,35),true);
				labelField = new TextField();
				labelField.text = indexName;
				labelField.setTextFormat(textFormat);
				labelField.autoSize = TextFieldAutoSize.LEFT;
				labelField.selectable = false;
				labelField.x = diagramSize+2+diagramSize/completeInterval;
				labelField.y = -values[j-1]*80/maxValue-labelField.height/2;
				
				with(labelField) playButton = null;
				
				indexesCurves.addChild(labelField);
			}
		}
		
		public function drawCursor(newInterval:int,currentFrame:int):void{
			var yearsNumber:int = endYear-beginYear;
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
			var completeInterval:int = endYear-beginYear;
			
			trace("TimeLine.displayMapKey:\n\t"+completeInterval+" steps.");
			
			with(mapKey.graphics){
				lineStyle(1,0x000000);
				moveTo(0,-100);
				lineTo(0,0);
				lineTo((diagramSize+20),0);
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
			tempX = Math.round(timeCursor.x/diagramSize*(endYear-beginYear))*diagramSize/(endYear-beginYear);
			tempX = Math.min(tempX,diagramSize-interval*diagramSize/(endYear-beginYear));
			tempX = Math.max(tempX,0);
			timeCursor.x = tempX;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			var oldFrame:int = frame;
			
			if(this.mouseX-localMouseX < 0){
				timeCursor.x = 0;
			}else if(this.mouseX-localMouseX > diagramSize-interval*diagramSize/(endYear-beginYear)){
				timeCursor.x = diagramSize-interval*diagramSize/(endYear-beginYear);
			}else{
				timeCursor.x = Math.round((this.mouseX-localMouseX)/diagramSize*(endYear-beginYear))*diagramSize/(endYear-beginYear);
			}
			
			frame = Math.round(timeCursor.x/diagramSize*(endYear-beginYear));
			
			if(frame!=oldFrame){
				diagram.goFrame(frame);
				up.setTimeSliderFrame(frame);
				drawIndexes();
			}
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