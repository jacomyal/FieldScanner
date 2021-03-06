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

package com.fieldscanner.y2009.data {
	
	public class Word{
		
		public var label:String;
		public var inProxValues:Vector.<Number>;
		public var outProxValues:Vector.<Number>;
		public var occurences:Vector.<Number>;
		
		public var color:Array;
		public var diameter:Array;
	
		public function Word(newLabel:String){
			label = newLabel;
			inProxValues = new Vector.<Number>();
			outProxValues = new Vector.<Number>();
			occurences = new Vector.<Number>();
			
			color = new Array();
			diameter = new Array();
		}
		
		public function setColor(c:uint,step:int):void{
			color[step] = c;
		}
		
		public function setDiameter(d:Number,step:int):void{
			diameter[step] = d;
		}
		
		public function setLabel():void{
			while(label.indexOf('"')!=(-1)){
				label = label.replace('"','');
			}
			
			while(label.indexOf('+')!=(-1)){
				label = label.replace('+',' ');
			}
			
			label = label.charAt(0).toUpperCase()+label.substr(1);
		}
	}
}