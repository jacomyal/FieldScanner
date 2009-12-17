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

package com.fieldscanner.y2009.calcul {
	
	import com.fieldscanner.y2009.data.Data;
	
	public class IndexCalculator{
		
		private var gsCalculator:GSCalculator;
		private var indexes:Array;
		private var wordsData:Data;
		
		public function IndexCalculator(gs:GSCalculator){
			gsCalculator = gs;
		}
		
		public function SET_WORDS_DATA(wd:Data):void{
			wordsData = wd;
		}
		
		public function getLocalIndexValues(i:int):Array{
			var a:Array;
			
			if(i==0){
				a = occurencesLocalIndex();
			}else if(i==1){
				a = inProxLocalIndex();
			}else if(i==2){
				a = outProxLocalIndex();
			}
			
			return a;
		}
		
		public function getClusterIndexValues(i:int):Array{
			var a:Array;
			
			if(i==0){
				a = occurencesAverageValueClusterIndex();
			}else if(i==1){
				a = inOutProxClusterIndex();
			}
			
			return a;
		}
		
		private function occurencesLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var l:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = wordsData.WORDS_VECTOR[0].occurences[0];
			maxValue = wordsData.WORDS_VECTOR[0].occurences[0];
			
			for(step=0;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					tempValue = wordsData.WORDS_VECTOR[i].occurences[step];
					
					if(tempValue<minValue) minValue=tempValue;
					if(tempValue>maxValue) maxValue=tempValue;
					
					indexMatrix[step][i]=tempValue;
				}
			}
			
			return [minValue,maxValue,indexMatrix];
		}
		
		private function inProxLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var l:int = wordsData.WORDS_VECTOR[0].inProxValues.length;
			
			minValue = wordsData.WORDS_VECTOR[0].inProxValues[0];
			maxValue = wordsData.WORDS_VECTOR[0].inProxValues[0];
			
			for(step=0;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					tempValue = wordsData.WORDS_VECTOR[i].inProxValues[step];
					
					if(tempValue<minValue) minValue=tempValue;
					if(tempValue>maxValue) maxValue=tempValue;
					
					indexMatrix[step][i]=tempValue;
				}
			}
			
			return [minValue,maxValue,indexMatrix];
		}
		
		private function outProxLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var l:int = wordsData.WORDS_VECTOR[0].outProxValues.length;
			
			minValue = wordsData.WORDS_VECTOR[0].outProxValues[0];
			maxValue = wordsData.WORDS_VECTOR[0].outProxValues[0];
			
			for(step=0;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					tempValue = wordsData.WORDS_VECTOR[i].outProxValues[step];
					
					
					if(tempValue<minValue) minValue=tempValue;
					if(tempValue>maxValue) maxValue=tempValue;
					
					indexMatrix[step][i]=tempValue;
				}
			}
			
			return [minValue,maxValue,indexMatrix];
		}
		
		private function occurencesAverageValueClusterIndex():Array{
			var i:int=0;
			var step:int=0;
			var minValue:Number;
			var maxValue:Number;
			var tempAverage:Number;
			var averageArray:Array = new Array();
			var l:int=wordsData.WORDS_VECTOR.length;
			var stepsNumber:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = wordsData.WORDS_VECTOR[i].occurences[step];
			maxValue = wordsData.WORDS_VECTOR[i].occurences[step];
			
			for(step=0;step<stepsNumber;step++){
				tempAverage = 0;
				
				for(i=0;i<l;i++){
					tempAverage += wordsData.WORDS_VECTOR[i].occurences[step];
				}
				averageArray[step] = tempAverage/l;
			}
			
			return averageArray;
		}
		
		private function inOutProxClusterIndex():Array{
			var i:int=0;
			var step:int=0;
			var minValue:Number;
			var maxValue:Number;
			var tempAverage:Number;
			var averageArray:Array = new Array();
			var l:int=wordsData.WORDS_VECTOR.length;
			var stepsNumber:int = wordsData.WORDS_VECTOR[0].inProxValues.length;
			
			minValue = wordsData.WORDS_VECTOR[i].inProxValues[step];
			maxValue = wordsData.WORDS_VECTOR[i].inProxValues[step];
			
			for(step=0;step<stepsNumber;step++){
				tempAverage = 0;
				
				for(i=0;i<l;i++){
					tempAverage += wordsData.WORDS_VECTOR[i].inProxValues[step];
				}
				trace("in: "+(tempAverage/l));
				averageArray[step] = tempAverage/l;
			}
			
			return averageArray;
		}		
	}
}