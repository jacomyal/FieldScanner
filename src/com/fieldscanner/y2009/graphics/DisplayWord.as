package com.fieldscanner.y2009.graphics{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class DisplayWord extends Sprite{
		
		private var labelField:TextField;
		private var textFormat:TextFormat;
		
		public function DisplayWord(label:String){
			textFormat = new TextFormat("Verdana");
			
			labelField = new TextField();
			labelField.text = label;
			labelField.setTextFormat(textFormat);
		}
		
		public function plot(color:uint=0x446688,diameter:Number=15):void{
			graphics.clear();
			
			with(graphics){
				graphics.beginFill(0x446688,1);
				graphics.drawCircle(0,0,diameter*2/3);
				graphics.beginFill(0x446688,0.3);
				graphics.drawCircle(0,0,diameter);
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