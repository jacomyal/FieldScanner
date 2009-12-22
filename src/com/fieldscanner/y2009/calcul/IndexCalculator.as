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
				a = occurencesDerivativeValueLocalIndex();
			}else if(i==2){
				a = normalizedCooccurencesLocalIndex();
			}else if(i==3){
				a = normalizedCooccurencesDerivativeLocalIndex();
			}else if(i==4){
				a = inProxLocalIndex();
			}else if(i==5){
				a = inProxDerivativeValueLocalIndex();
			}else if(i==6){
				a = outProxLocalIndex();
			}else if(i==7){
				a = outProxDerivativeValueLocalIndex();
			}
			
			return a;
		}
		
		public function getClusterIndexValues(i:int):Array{
			var a:Array;
			
			if(i==0){
				a = occurencesAverageValueClusterIndex();
			}else if(i==1){
				a = occurencesDerivativeValueClusterIndex();
			}else if(i==2){
				a = normalizedCooccurencesAverageValueClusterIndex();
			}else if(i==3){
				a = normalizedCooccurencesDerivativeValueClusterIndex();
			}else if(i==4){
				a = inOutProxAverageClusterIndex();
			}else if(i==5){
				a = inOutProxDerivativeValueClusterIndex();
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
		
		private function occurencesDerivativeValueLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var initialMatrix:Array = occurencesLocalIndex()[2];
			var l:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = 1;
			maxValue = 1;
			
			indexMatrix[0] = new Array();
			
			for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
				indexMatrix[0][i] = 1;
			}
				
			for(step=1;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					
					if(initialMatrix[step-1][i]==0){
						tempValue=1;
					}else{
						tempValue=initialMatrix[step][i]/initialMatrix[step-1][i];
					}
					
					if(tempValue<minValue) minValue=tempValue;
					if(tempValue>maxValue) maxValue=tempValue;
					
					indexMatrix[step][i]=tempValue;
				}
			}
			
			return [minValue,maxValue,indexMatrix];
		}
		
		private function normalizedCooccurencesLocalIndex():Array{
			var word:int=0;
			var i:int=0;
			var j:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var l:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = -1;
			maxValue = -1;
			
			for(step=0;step<l;step++){
				indexMatrix[step] = new Array();
				for(word=0;word<wordsData.WORDS_VECTOR.length;word++){
					tempValue = 0;
					
					if(wordsData.WORDS_VECTOR[word].occurences[step]!=0){
						for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
							if(i!=word) tempValue += wordsData.getWordOcc(word,i,step);
						}
						
						tempValue = tempValue/wordsData.WORDS_VECTOR[word].occurences[step];
					}
					
					if(tempValue<minValue||minValue==-1) minValue=tempValue;
					if(tempValue>maxValue||maxValue==-1) maxValue=tempValue;
					
					indexMatrix[step][word]=tempValue;
				}
			}
			
			return [minValue,maxValue,indexMatrix];
		}
		
		private function normalizedCooccurencesDerivativeLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var initialMatrix:Array = normalizedCooccurencesLocalIndex()[2];
			var l:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = 1;
			maxValue = 1;
			
			indexMatrix[0] = new Array();
			
			for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
				indexMatrix[0][i] = 1;
			}
			
			for(step=1;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					
					if(initialMatrix[step-1][i]==0){
						tempValue=1;
					}else{
						tempValue=initialMatrix[step][i]/initialMatrix[step-1][i];
					}
					
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
		
		private function inProxDerivativeValueLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var initialMatrix:Array = inProxLocalIndex()[2];
			var l:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = 1;
			maxValue = 1;
			
			indexMatrix[0] = new Array();
			
			for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
				indexMatrix[0][i] = 1;
			}
			
			for(step=1;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					
					if(initialMatrix[step-1][i]==0){
						tempValue=1;
					}else{
						tempValue=initialMatrix[step][i]/initialMatrix[step-1][i];
					}
					
					if(tempValue<minValue) minValue=tempValue;
					if(tempValue>maxValue) maxValue=tempValue;
					
					indexMatrix[step][i]=tempValue;
				}
			}
			
			return [minValue,maxValue,indexMatrix];
		}
		
		private function outProxDerivativeValueLocalIndex():Array{
			var i:int=0;
			var step:int=0;
			var tempValue:Number;
			var minValue:Number;
			var maxValue:Number;
			var indexMatrix:Array = new Array();
			var initialMatrix:Array = outProxLocalIndex()[2];
			var l:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = 1;
			maxValue = 1;
			
			indexMatrix[0] = new Array();
			
			for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
				indexMatrix[0][i] = 1;
			}
			
			for(step=1;step<l;step++){
				indexMatrix[step] = new Array();
				for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
					
					if(initialMatrix[step-1][i]==0){
						tempValue=1;
					}else{
						tempValue=initialMatrix[step][i]/initialMatrix[step-1][i];
					}
					
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
			var tempAverage:Number;
			var beginArray:Array = new Array();
			var averageArray:Array = new Array();
			var l:int=wordsData.WORDS_VECTOR.length;
			var stepsNumber:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			for(i=0;i<gsCalculator.interval;i++){
				beginArray.push(0);
			}
			
			for(step=0;step<stepsNumber;step++){
				tempAverage = 0;
				
				for(i=0;i<l;i++){
					tempAverage += wordsData.WORDS_VECTOR[i].occurences[step];
				}
				averageArray[step] = tempAverage/l;
			}
			
			return beginArray.concat(averageArray);
		}
		
		private function occurencesDerivativeValueClusterIndex():Array{
			var i:int=0;
			var a:Array=occurencesAverageValueClusterIndex();
			var derivativeArray:Array = [1];
			
			for(i=0;i<gsCalculator.interval;i++){
				derivativeArray.push(1);
			}
			
			for(i=gsCalculator.interval;i<a.length;i++){
				if(a[i-1]==0){
					derivativeArray[i] = 1;
				}else{
					derivativeArray[i] = a[i]/a[i-1];
				}
			}
			
			return derivativeArray;
		}
		
		private function normalizedCooccurencesAverageValueClusterIndex():Array{
			var i:int=0;
			var word:int=0;
			var step:int=0;
			var minValue:Number;
			var maxValue:Number;
			var tempValue:Number;
			var tempAverage:Number;
			var beginArray:Array = new Array();
			var averageArray:Array = new Array();
			var l:int=wordsData.WORDS_VECTOR.length;
			var stepsNumber:int = wordsData.WORDS_VECTOR[0].occurences.length;
			
			minValue = wordsData.WORDS_VECTOR[i].occurences[step];
			maxValue = wordsData.WORDS_VECTOR[i].occurences[step];
			
			for(i=0;i<gsCalculator.interval;i++){
				beginArray.push(0);
			}
			
			for(step=0;step<stepsNumber;step++){
				tempAverage = 0;
				
				for(word=0;word<l;word++){
					tempValue = 0;
					
					if(wordsData.WORDS_VECTOR[word].occurences[step]!=0){
						for(i=0;i<wordsData.WORDS_VECTOR.length;i++){
							if(i!=word) tempValue += wordsData.getWordOcc(word,i,step);
						}
						
						tempValue = tempValue/wordsData.WORDS_VECTOR[word].occurences[step];
					}
					
					tempAverage += tempValue;
				}
				
				tempAverage = tempAverage/l;
				averageArray[step]=tempAverage;
			}
			
			return beginArray.concat(averageArray);
		}
		
		private function normalizedCooccurencesDerivativeValueClusterIndex():Array{
			var i:int=0;
			var a:Array=normalizedCooccurencesAverageValueClusterIndex();
			var derivativeArray:Array = [1];
			
			for(i=0;i<gsCalculator.interval;i++){
				derivativeArray.push(1);
			}
			
			for(i=gsCalculator.interval;i<a.length;i++){
				if(a[i-1]==0){
					derivativeArray[i] = 1;
				}else{
					derivativeArray[i] = a[i]/a[i-1];
				}
			}
			
			return derivativeArray;
		}
		
		private function inOutProxAverageClusterIndex():Array{
			var i:int=0;
			var step:int=0;
			var minValue:Number;
			var maxValue:Number;
			var tempAverage:Number;
			var beginArray:Array = new Array();
			var averageArray:Array = new Array();
			var l:int=wordsData.WORDS_VECTOR.length;
			var stepsNumber:int = wordsData.WORDS_VECTOR[0].inProxValues.length;
			
			minValue = wordsData.WORDS_VECTOR[i].inProxValues[step];
			maxValue = wordsData.WORDS_VECTOR[i].inProxValues[step];
			
			for(i=0;i<gsCalculator.interval;i++){
				beginArray.push(0);
			}
			
			for(step=0;step<stepsNumber;step++){
				tempAverage = 0;
				
				for(i=0;i<l;i++){
					tempAverage += wordsData.WORDS_VECTOR[i].inProxValues[step];
				}
				trace("in: "+(tempAverage/l));
				averageArray[step] = tempAverage/l;
			}
			
			return beginArray.concat(averageArray);
		}		
		
		private function inOutProxDerivativeValueClusterIndex():Array{
			var i:int=0;
			var a:Array=inOutProxAverageClusterIndex();
			var derivativeArray:Array = [1];
			
			for(i=0;i<gsCalculator.interval;i++){
				derivativeArray.push(1);
			}
			
			for(i=gsCalculator.interval;i<a.length;i++){
				if(a[i-1]==0){
					derivativeArray[i] = 1;
				}else{
					derivativeArray[i] = a[i]/a[i-1];
				}
			}
			
			return derivativeArray;
		}
	}
}