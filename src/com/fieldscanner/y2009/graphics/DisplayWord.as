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

package com.fieldscanner.y2009.graphics{
	
	import com.fieldscanner.y2009.data.Word;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DisplayWord extends Sprite{
		
		private var labelField:TextField;
		private var textFormat:TextFormat;
		private var word:Word;
		
		public function DisplayWord(w:Word){
			textFormat = new TextFormat("Verdana");
			
			word = w;
			
			labelField = new TextField();
			labelField.text = w.label;
			labelField.setTextFormat(textFormat);
		}
		
		public function get WORD():Word{
			return(word);
		}
		
		public function plot():void{
			graphics.clear();
			
			with(graphics){
				graphics.beginFill(word.color,1);
				graphics.drawCircle(0,0,word.diameter*2/3);
				graphics.beginFill(word.color,0.3);
				graphics.drawCircle(0,0,word.diameter);
			}
			
			with(labelField){
				autoSize = TextFieldAutoSize.LEFT;
				x = word.diameter;
				y = -height/2;
			}
			
			if(!this.contains(labelField)) addChild(labelField);
		} 
	}
}