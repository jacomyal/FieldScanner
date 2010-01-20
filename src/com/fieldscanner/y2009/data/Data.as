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

package com.fieldscanner.y2009.data {
	
	public class Data {
		
		public var wordsArray:Array;
		private var wordsVector:Vector.<Word>;
		private var occMatrixes:Array;
		public var inMatrix:Array;
		public var outMatrix:Array;
		public var beginYear:Number;
		
		public function Data(newWordsVector:Vector.<String>,newBeginYear:Number){
			var i:Number = 0;
			var j:Number = 0;
			
			beginYear = newBeginYear;
			wordsArray = new Array();
			
			/*occMatrixes: D1 and D2 are Words and D3 are Years*/
			occMatrixes = new Array();
			
			/*inMatrix/outMatrix: Lines are Words, Columns are Years*/
			inMatrix = new Array();
			outMatrix = new Array();
			
			for (i=0;i<newWordsVector.length;i++){
				wordsArray.push(newWordsVector[i]);
				occMatrixes.push(new Array());
				inMatrix.push(new Array());
				outMatrix.push(new Array());
				for(j=0;j<newWordsVector.length;j++){
					occMatrixes[i].push(new Array());
				}
			}
		}
		
		public function get WORDS_VECTOR():Vector.<Word>{
			return(wordsVector);
		}
		
		public function createWordsVector():Vector.<Word>{
			wordsVector = new Vector.<Word>();
			return(wordsVector);
		}
		
		public function getWord(wordIndex:Number):String{
			return(wordsArray[wordIndex]);
		}
		
		public function getArrayLength():Number{
			return(wordsArray.length);
		}
		
		public function indexOfString(s:String):int{
			var i:int;
			
			for(i=0;i<wordsVector.length;i++){
				if(s==wordsVector[i].label){
					return i;
				}
			}
			
			return -1;
		}
		
		public function getWordOcc(wordIndex1:Number,wordIndex2:Number,year:Number):Number{
			var res:Number;
			if(year>=1500) res=occMatrixes[wordIndex1][wordIndex2][year-beginYear];
			else res=occMatrixes[wordIndex1][wordIndex2][year];
			
			return(res);
		}
		
		public function printInArray(y:Number):void{
			var i:Number;
			var yMax:Number = Math.max(y,y+beginYear);
			var yMin:Number = Math.min(y,y+beginYear);
			
			for(i=0;i<inMatrix.length;i++){
				trace("\t\Year "+yMax+": value: "+inMatrix[i][yMin]);
			}
		}
		
		public function printOutArray(y:Number):void{
			var i:Number;
			var yMax:Number = Math.max(y,y+beginYear);
			var yMin:Number = Math.min(y,y+beginYear);
			
			for(i=0;i<outMatrix.length;i++){
				trace("\t\Year "+yMax+": value: "+outMatrix[i][yMin]);
			}
		}
		
		public function getMatrixes():Array{
			return(occMatrixes);
		}
		
		public function getIn(wordIndex:Number,year:Number):Number{
			if(year>=1500) return(inMatrix[wordIndex][year-beginYear]);
			else return(inMatrix[wordIndex][year]);
		}
		
		public function getOut(wordIndex:Number,year:Number):Number{
			if(year>=1500) return(outMatrix[wordIndex][year-beginYear]);
			else return(outMatrix[wordIndex][year]);
		}
		
		public function setWordOcc(wordIndex1:Number,wordIndex2:Number,year:Number,newOcc:Number):void{
			if(wordIndex1!=wordIndex2){
				if(year>=1500){
					occMatrixes[wordIndex1][wordIndex2][year-beginYear] = newOcc;
					occMatrixes[wordIndex2][wordIndex1][year-beginYear] = newOcc;
				}else{
					occMatrixes[wordIndex1][wordIndex2][year] = newOcc;
					occMatrixes[wordIndex2][wordIndex1][year] = newOcc;
				}
			}else{
				if(year>=1500) occMatrixes[wordIndex1][wordIndex2][year-beginYear] = newOcc;
				else occMatrixes[wordIndex1][wordIndex2][year] = newOcc;
			}
			
			trace("Data.setWordOcc:\n\tValue "+occMatrixes[wordIndex1][wordIndex2][year-beginYear]+" inserted at "+wordIndex1+"/"+wordIndex2+"/"+(year-beginYear));
		}
		
		public function setIn(wordIndex:Number,year:Number,newIn:Number):void{
			if(year>=1500) inMatrix[wordIndex][year-beginYear] = newIn;
			else inMatrix[wordIndex][year] = newIn;
		}
		
		public function setOut(wordIndex:Number,year:Number,newOut:Number):void{
			if(year>=1800) outMatrix[wordIndex][year-beginYear] = newOut;
			else outMatrix[wordIndex][year] = newOut;
		}
		
	}
	
}