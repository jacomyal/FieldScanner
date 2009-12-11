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
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DisplayWord extends Sprite{
		
		private var labelField:TextField;
		private var textFormat:TextFormat;
		private var toolTip:Sprite;
		private var word:Word;
		private var step:int;
		
		public function DisplayWord(w:Word,s:int){
			textFormat = new TextFormat("Verdana");
			textFormat.bold = true;
			
			step = s;
			word = w;
			
			labelField = new TextField();
			labelField.text = w.label;
			labelField.selectable = false;
			labelField.setTextFormat(textFormat);
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			setToolTip();
		}
		
		public function get WORD():Word{
			return(word);
		}
		
		public function plot():void{
			graphics.clear();
			
			with(graphics){
				graphics.beginFill(word.color[step],0.6);
				graphics.lineStyle(2,brightenColor(word.color[step],80),1);
				graphics.drawCircle(0,0,word.diameter[step]*2/3);
			}
			
			with(labelField){
				autoSize = TextFieldAutoSize.LEFT;
				textColor = brightenColor(word.color[step],30);
				
				x = word.diameter[step];
				y = -height/2;
			}
			
			if(!this.contains(labelField)) addChild(labelField);
		}
		
		private function setToolTip():void{
			toolTip = new Sprite();
			
			toolTip.graphics.beginFill(word.color[step],1);
			toolTip.graphics.drawRect(20,20,word.diameter[step],word.diameter[step]);
		}
		
		private function onMouseOverHandler(e:MouseEvent):void{
			this.parent.addChild(toolTip);
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
		}
		
		private function onMouseOutHandler(e:MouseEvent):void{
			toolTip.parent.removeChild(toolTip);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
		}
		
		private function onMouseMoveHandler(e:MouseEvent):void{
			toolTip.x = this.parent.mouseX;
			toolTip.y = this.parent.mouseY;
		}
		
		private function brightenColor(color:Number, perc:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			if(perc > 50 && perc <= 100) {
				factor = ( ( perc-50 ) / 50 );
				
				redOffset += ( 255 - redOffset ) * factor;
				blueOffset += ( 255 - blueOffset ) * factor;
				greenOffset += ( 255 - greenOffset ) * factor;
			}
			else if( perc < 50 && perc >= 0 ){
				factor = ( ( 50 - perc ) / 50 );
				
				redOffset -= redOffset * factor;
				blueOffset -= blueOffset * factor;
				greenOffset -= greenOffset * factor;
			}
			
			return (redOffset<<16|greenOffset<<8|blueOffset);
		}
	}
}