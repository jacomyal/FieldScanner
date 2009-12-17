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
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.fieldscanner.y2009.data.Data;
	
	public class GSCalculator extends EventDispatcher{
		
		public static const IN_OUT_FINISH:String = "Words analyse finish for one steps";
		public static const IN_OUT_FINISH_ALL:String = "Words analyse finish for all steps";
		public static const ALERT:String = "Alert";
		
		public var expressionsIndex:Vector.<String>;
		public var focusParameter:Number;
		public var beginYear:Number;
		public var endYear:Number;
		public var interval:Number;
		public var wordsData:Data;
		public var alertString:String;
		
		private var stepCounter:Number;
		private var initialString:String;
		
		public function GSCalculator(newWordsData:Data,bY:Number,eY:Number){
			wordsData = newWordsData;
			
			alertString = new String();
			
			beginYear = bY;
			endYear = eY;
		}
		
		public function launch(newInt:Number,tempAlpha:Number):void{
			stepCounter = 0;
			expressionsIndex = new Vector.<String>();
			
			interval = newInt;
			focusParameter = tempAlpha;
			
			addEventListener(GSCalculator.IN_OUT_FINISH, onResultsFoundHandler);
			onResultsFoundHandler(null);
		}
		
		public function launchAlert(str:String):void{
			alertString = str;
			dispatchEvent(new Event(ALERT));
		}
		
		public function launchNextStep():void{
			stepCounter++;
			
			if(stepCounter<(endYear-beginYear-interval+1)){
				var localBegin:Number = beginYear+stepCounter;
				var localEnd:Number = beginYear+stepCounter+interval;
				dispatchEvent(new Event(IN_OUT_FINISH));
			}
			
			else {
				dispatchEvent(new Event(IN_OUT_FINISH_ALL));
			}
		}
		
		public function P(A:Number,i1:Number,i2:Number):Number{
			
			var cooc:Number = 0;
			var oc1:Number = 0;
			var oc2:Number = 0;
			var res:Number;
			
			if(i1==i2) return(0);
			
			for(var i:Number=0;i<interval;i++){
				cooc += wordsData.getWordOcc(i1,i2,stepCounter+i);
				oc1 += wordsData.getWordOcc(i1,i1,stepCounter+i);
				oc2 += wordsData.getWordOcc(i2,i2,stepCounter+i);
			}
			
			if((oc1>0)&&(oc2>0)){
				res = Math.pow((Math.pow((cooc/oc1),A))*(Math.pow((cooc/oc2),(1/A))),Math.min(A,1/A));
			}else{
				res = 0;
			}
			
			return(res);
		}
		
		protected function onResultsFoundHandler(evt:Event):void{
			var i:Number = 0;
			for(i=0;i<wordsData.getArrayLength();i++){
				setInProx(i);
				setOutProx(i);
			}
			
			launchNextStep();
		}
		
		protected function setInProx(wordIndex:Number):void{
			var word:String = wordsData.getWord(wordIndex);
			var inProc:Number = 0;
			var i:Number = 0;
			var iMax:Number = wordsData.getArrayLength();
			
			var min:Number = Math.min(focusParameter,1/focusParameter);
			var max:Number = Math.max(focusParameter,1/focusParameter);
			
			for (i=0;i<iMax;i++){
				inProc += P(max,wordIndex,i);
			}
			
			var res:Number = inProc/(iMax-1);
			
			trace("GSCalculator.setInProx:\n\tIn value"+word+" for step "+stepCounter+" is "+res);
			wordsData.setIn(wordIndex,stepCounter,res);
		}
		
		protected function setOutProx(wordIndex:Number):void{
			var word:String = wordsData.getWord(wordIndex);
			var outProc:Number = 0;
			var i:Number = 0;
			var iMax:Number = wordsData.getArrayLength();
			
			var min:Number = Math.min(focusParameter,1/focusParameter);
			var max:Number = Math.max(focusParameter,1/focusParameter);
			
			for (i=0;i<iMax;i++){
				outProc += P(min,wordIndex,i);
			}
			
			var res:Number = outProc/(iMax-1);
			
			trace("GSCalculator.setOutProx:\n\tOut proximity value of expression "+word+" is "+res);
			wordsData.setOut(wordIndex,stepCounter,res);
		}
	}
}