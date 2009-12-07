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
	
	import flash.display.Sprite;
	
	public class TimeLine extends Sprite{
		
		private var up:Diagram;
		private var clusterIndexes:Array;
		private var diagramSize:Number;
		private var beginYear:int;
		private var endYear:int;
		private var interval:int;
		
		public function TimeLine(newUp:Diagram){
			trace("New TimeLine created.");
			
			up = newUp;
			up.addChild(this);
			
			diagramSize = up.DIAGRAM_SIZE;
			beginYear = up.START;
			endYear = up.END;
			interval = endYear-beginYear;
			
			displayMapKey();
		}
		
		public function addClusterIndex(indexName:String,values:Array,indexColor:String="undefined"):Boolean{
			var res:Boolean = true;
			var tempColor:uint;
			
			if(indexColor=="undefined"){
				tempColor = new uint(Math.round( Math.random()*0xFFFFFF));
			}else{
				tempColor = new uint(indexColor);
			}
			
			var tempIndex:Object = {iname:indexName, icolor:tempColor};
			clusterIndexes.push(tempIndex);
			drawIndex(values,tempColor);
			
			return res;
		}
		
		private function displayMapKey():void{
			var i:int;
			
			with(this.graphics){
				lineStyle(1,0x000000);
				moveTo(0,-100);
				lineTo(0,0);
				lineTo((diagramSize+20),0);
			}
			
			for(i=0;i<interval;i++){
				this.graphics.moveTo(diagramSize*i/interval,0);
				this.graphics.lineTo(diagramSize*i/interval,5);
			}
		}
		
		private function drawIndex(values:Array,indexColor:uint):Boolean{
			var res:Boolean = true;
			
			with(this.graphics){
				
			}
			
			
			return res;
		}
	}
}