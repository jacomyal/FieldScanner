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

package com.fieldscanner.y2009.text {
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DiagramTextField extends TextField{
		
		public var textFormat:TextFormat;
		
		public function DiagramTextField(options:String=""){
			selectable = false;
			autoSize = TextFieldAutoSize.CENTER;
			
			if(options=="little"){
				textFormat = new TextFormat("Verdana",9);
			}else if(options=="word"){
				textFormat = new TextFormat("Verdana");
				textFormat.bold = true;
			}else textFormat = new TextFormat("Verdana");
		}
		
		public function refresh():void{
			setTextFormat(textFormat);
		}
	}
}