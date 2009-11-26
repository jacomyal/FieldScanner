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
	
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.display.Sprite;
	
	/**
	 * Cette classe InputFormatTextField me permet d'utiliser la version normalisée
	 * de champ de textes de type INPUT.
	 */
	public class InputFormatTextField extends TextField{

		public var inputFormat:TextFormat;
		
		public function InputFormatTextField(){
			
			inputFormat = new TextFormat();
			inputFormat.font = "Verdana";
			inputFormat.italic = true;
			inputFormat.size = 10;
			
			type = TextFieldType.INPUT;
			selectable = true;
			autoSize = TextFieldAutoSize.LEFT;
			background = true;
			textColor = 0x888800;
		}
		
		public function setText(str:String):void{
			text = str;
		}
		
		public function actualize():void{
			setTextFormat(inputFormat);
		}
		
		public function clearText():void{
			text = "";
		}
	}
	
}