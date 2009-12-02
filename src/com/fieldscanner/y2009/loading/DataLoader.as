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

package com.fieldscanner.y2009.loading {
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import com.fieldscanner.y2009.data.Data;
	
	public class DataLoader extends EventDispatcher{
		
		public static const ON_COMPLETED:String = "Vectors and Matrixes completed";
		public static const ON_COMPLETED_ONE_YEAR:String = "Vectors and Matrix completed for one step";
		public static const ALERT:String = "Alert";
		
		public var wordsData:Data;
		public var beginYear:Number;
		public var endYear:Number;
		
		private var fileLoader:URLLoader;
		private var fileRequest:URLRequest;
		
		private var rawData:String;
		private var wordsVector:Vector.<String>;
		
		public function DataLoader(){
			wordsVector = new Vector.<String>;
		}
		
		public function parse(str:String):void{
			fileRequest = new URLRequest(str);
			fileLoader = new URLLoader();
			
			fileLoader.addEventListener(Event.COMPLETE, whenCompleted);
			fileLoader.load(fileRequest);
		}
		
		private function whenCompleted(e:Event):void{
			var i:int = 0;
			var arrayCounter:int = 0;
			var parsed:String = '';
			var rawWordsString:String = "";
			rawData = e.target.data;
			
			while(rawData.charAt(i)!='\n'){
				rawWordsString = rawWordsString+rawData.charAt(i);
				i++;
			}
			
			i++;
			while(rawData.charAt(i)!='\n'){
				if(rawData.charAt(i)=='§'){
					if(arrayCounter==0){
						beginYear = new Number(parsed);
						trace("Begin year set: "+beginYear);
					}
					parsed = "";
					arrayCounter++;
				}else if(rawData.charAt(i)==';'){
					endYear = new Number(parsed);
					trace("End year set: "+endYear);
					parsed = "";
					arrayCounter++;
				}else{
					parsed = parsed+rawData.charAt(i);
				}
				i++;
			}
			
			rawData = rawData.substr(i+1);
			setWordsVector(rawWordsString);
		}
		
		private function setWordsVector(s:String):void{
			var pos:Number = 0;
			var posMax:Number = s.length;
			var tempWord:String = new String();
			trace('DataLoader.setWordsVector:\n\tInitial string: "'+s+'"');
			
			for(pos=0;pos<posMax;pos++){
				if((s.charAt(pos) == "§")||(s.charAt(pos) == ";")){
					if(tempWord.charAt(0)==" "){
						tempWord = tempWord.slice(1);
					}
					if(tempWord.charAt(tempWord.length-1)==" "){
						tempWord = tempWord.slice(0,tempWord.length-1);
					}
					if(tempWord!=""){
						wordsVector.push(clean(tempWord));
					}
					tempWord = "";
				} else if(s.charAt(pos) == " "){
					tempWord+=" ";
				} else {
					tempWord+=s.charAt(pos);
				}
			}
			
			trace("DataLoader.setWordsVector:\n\tWords vector set:");
			wordsVector.sort(compareString);
			for(var i:Number=0;i<wordsVector.length;i++){
				trace("\t\tWord n°"+i+": "+wordsVector[i]);
			}
			
			wordsData = new Data(wordsVector,beginYear);
			
			readFile();
			
		}
		
		private function readFile():void{
			var tempArray:Array = new Array();
			var tempStr:String = '';
			var counter:int = 0;
			var ng1:Number;
			var ng2:Number;
			var oc:Number;
			var year:Number;
			
			while(1){
				tempArray = readLine(rawData.substr(counter));
				if(tempArray==null) break;
				ng1 = wordsVector.indexOf(tempArray[0]);
				ng2 = wordsVector.indexOf(tempArray[1]);
				year = tempArray[2];
				oc = tempArray[3];
				
				wordsData.setWordOcc(ng1,ng2,year,oc);
				
				counter += tempArray[4];
			}
			
			dispatchEvent(new Event(ON_COMPLETED));
		}
		
		private function readLine(s:String):Array{
			if(s.toUpperCase()==s.toLowerCase()) return null;
			
			var counter:int = 0;
			var arrayCounter:int = 0;
			var res:Array = new Array();
			var parsed:String = '';
			
			while(arrayCounter<4){
				if(s.charAt(counter)=='§'){
					if(arrayCounter<2) res.push(clean(parsed));
					else res.push(new Number(parsed));
					parsed = "";
					arrayCounter++;
				}else if(s.charAt(counter)==';'){
					res.push(new Number(parsed));
					parsed = "";
					arrayCounter++;
				}else{
					parsed = parsed+s.charAt(counter);
				}
				counter++;
			}
			
			if(s.charAt(counter)==' ') counter++;
			if(s.charAt(counter)=='\n') counter++;
			
			res.push(counter);
			return res;
		}
		
		private function clean(s0:String):String{
			var t:Boolean = true;
			var s:String = s0;
			var a:Array = ["\n"," ","\t","\r"];
			
			while(t){
				if(a.indexOf(s.charAt(0))>=0) s = s.substr(1);
				else if(a.indexOf(s.charAt(s.length-1))>=0) s = s.substr(0,s.length-1);
				else t = false;
			}
			
			return s;
		}
		
		private function compareString(S1:String, S2:String):int{
			var s1:String = S1.toLowerCase();
			var s2:String = S2.toLowerCase();
			
			return(s1.localeCompare(s2));
		}
		
	}
}