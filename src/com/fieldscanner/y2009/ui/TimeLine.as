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
	
	import com.fieldscanner.y2009.graphics.Diagram;
	import com.fieldscanner.y2009.text.DiagramTextField;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TimeLine extends Sprite{
		
		private var up:OptionsInterface;
		private var diagram:Diagram;
		private var clusterIndexes:Array;
		private var diagramSize:Number;
		private var beginYear:int;
		private var endYear:int;
		private var timeCursor:Sprite;
		private var currentCursorPos:int;
		
		private var interval:int;
		private var localMouseX:Number;
		
		public function TimeLine(newUp:OptionsInterface,newDiagram:Diagram){
			var i:int;
			var j:int;
			var a:Array;
			
			trace("New TimeLine created.");
			
			diagram = newDiagram;
			up = newUp;
			up.addChild(this);
			
			clusterIndexes = new Array();
			diagramSize = diagram.DIAGRAM_SIZE;
			beginYear = diagram.START;
			endYear = diagram.END;
			
			x = diagramSize-70;
			y = (diagramSize+60)+140;
			
			timeCursor = new Sprite();
			timeCursor.addEventListener(MouseEvent.MOUSE_DOWN,startXDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopXDrag);
			
			displayMapKey();
			
			for(j=0;j<5;j++){
				a = new Array();
				
				for(i=0;i<endYear-beginYear+1;i++){
					a.push(1000*Math.random());
				}
				
				addClusterIndex("Test "+j,a);
			}
		}
		
		public function addClusterIndex(indexName:String,values:Array,indexColor:String="undefined"):Boolean{
			var res:Boolean = true;
			var tempColor:uint;
			var i:int;
			var tempIndex:Object;
			var completeInterval:int = endYear-beginYear;
			var maxValue:Number = 0;
			var labelField:TextField;
			var textFormat:TextFormat;
			
			if(indexColor=="undefined"){
				tempColor = new uint(Math.round( Math.random()*0xFFFFFF));
			}else{
				tempColor = new uint(indexColor);
			}
			
			tempIndex = {iname:indexName, icolor:tempColor};
			clusterIndexes.push(tempIndex);
			
			for(i=0;i<values.length;i++){
				if(values[i]>maxValue) maxValue=values[i];
			}
			
			this.graphics.lineStyle(2,tempColor);
			this.graphics.moveTo(0,-values[0]*80/maxValue);
			
			for(i=0;i<=completeInterval;i++){
				this.graphics.lineTo(diagramSize*i/completeInterval,-values[i]*80/maxValue);
			}
			
			textFormat = new TextFormat("Verdana",12,brightenColor(tempColor,35),true);
			labelField = new TextField();
			labelField.text = indexName;
			labelField.setTextFormat(textFormat);
			labelField.autoSize = TextFieldAutoSize.LEFT;
			labelField.x = diagramSize+2;
			labelField.y = -values[i-1]*80/maxValue-labelField.height/2;
			
			addChild(labelField);
			
			return res;
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
			
			currentCursorPos = currentFrame;
			
			if(!this.contains(timeCursor)) this.addChild(timeCursor);
		}
		
		private function displayMapKey():void{
			var i:int;
			var tf:DiagramTextField;
			var completeInterval:int = endYear-beginYear;
			
			trace("TimeLine.displayMapKey:\n\t"+completeInterval+" steps.");
			
			with(this.graphics){
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
					addChild(tf);
					
					this.graphics.moveTo(diagramSize*i/completeInterval,0);
					this.graphics.lineTo(diagramSize*i/completeInterval,11);
				}else if(i==completeInterval){
					tf = new DiagramTextField("little");
					tf.text = (beginYear+i).toString()+"\n(end year)";
					tf.x = diagramSize*i/completeInterval;
					tf.y = 11;
					tf.refresh();
					addChild(tf);
					
					this.graphics.moveTo(diagramSize*i/completeInterval,0);
					this.graphics.lineTo(diagramSize*i/completeInterval,3);
				}else if(!((i+beginYear)%5)){
					tf = new DiagramTextField("little");
					tf.text = (beginYear+i).toString();
					tf.x = diagramSize*i/completeInterval;
					tf.y = 2;
					tf.refresh();
					addChild(tf);
					
					this.graphics.moveTo(diagramSize*i/completeInterval,0);
					this.graphics.lineTo(diagramSize*i/completeInterval,5);
				}else{
					this.graphics.moveTo(diagramSize*i/completeInterval,0);
					this.graphics.lineTo(diagramSize*i/completeInterval,3);
				}
			}
		}
		
		private function startXDrag(e:MouseEvent):void{
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
			if(this.mouseX-localMouseX < 0){
				timeCursor.x = 0;
			}else if(this.mouseX-localMouseX > diagramSize-interval*diagramSize/(endYear-beginYear)){
				timeCursor.x = diagramSize-interval*diagramSize/(endYear-beginYear);
			}else{
				timeCursor.x = Math.round((this.mouseX-localMouseX)/diagramSize*(endYear-beginYear))*diagramSize/(endYear-beginYear);
			}
			
			diagram.goFrame(Math.round(timeCursor.x/diagramSize*(endYear-beginYear)));
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