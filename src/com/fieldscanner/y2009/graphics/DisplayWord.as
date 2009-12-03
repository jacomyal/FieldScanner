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
				x = 15;
				y = -height/2;
			}
			
			if(!this.contains(labelField)) addChild(labelField);
		} 
	}
}