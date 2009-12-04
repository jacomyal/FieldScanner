package com.fieldscanner.y2009.ui{
	
	import fl.controls.Button;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class IndexPalette extends Sprite{
		
		private var minColorPicker:ColorPicker;
		private var maxColorPicker:ColorPicker;
		private var indexComboBox:ComboBox;
		private var colorIndex:TextField;
		private var sizeIndex:TextField;
		private var minSizeTF:TextField;
		private var maxSizeTF:TextField;
		private var up:OptionsInterface;
		private var redoButton:Button;
		
		public function IndexPalette(newUp:OptionsInterface){
			up = newUp;
			up.addChild(this);
		}
		
		public function setInterface():void{
			var iTF:TextField = new TextField();
			
			with(iTF){
				x = 10;
				y = 10;
				text = "Indexes:";
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
			}
			addChild(iTF);
			
			var minTF:TextField = new TextField();
			with(minTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 30;
				text = "Low color border: ";
			}
			addChild(minTF);
			
			minColorPicker = new ColorPicker();
			with(minColorPicker){
				x = 100;
				y = 30;
				selectedColor = up.DIAGRAM.indexParams[0];
			}
			addChild(minColorPicker);
			
			var maxTF:TextField = new TextField();
			with(maxTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 60;
				text = "High color border: ";
			}
			addChild(maxTF);
			
			maxColorPicker = new ColorPicker();
			with(maxColorPicker){
				x = 100;
				y = 60;
				selectedColor = up.DIAGRAM.indexParams[1];
			}
			addChild(maxColorPicker);
			
			var minSTF:TextField = new TextField();
			with(minSTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 90;
				text = "Low size border: ";
			}
			addChild(minSTF);
			
			minSizeTF = new TextField();
			with(minSizeTF){
				type = TextFieldType.INPUT;
				x = 100;
				y = 90;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				text = up.DIAGRAM.indexParams[2].toString();
			}
			addChild(minSizeTF);
			
			var maxSTF:TextField = new TextField();
			with(maxSTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 110;
				text = "High size border: ";
			}
			addChild(maxSTF);
			
			maxSizeTF = new TextField();
			with(maxSizeTF){
				type = TextFieldType.INPUT;
				x = 100;
				y = 110;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				text = up.DIAGRAM.indexParams[3].toString();
			}
			addChild(maxSizeTF);
			
			var indexTF:TextField = new TextField();
			with(indexTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 10;
				y = 130;
				text = "Index: ";
			}
			addChild(indexTF);
			
			indexComboBox = new ComboBox();
			with(indexComboBox){
				x = 50;
				y = 130;
			}
			for(var i:int=0;i<up.DIAGRAM.INDEXES.length;i++) indexComboBox.addItem({label:up.DIAGRAM.INDEXES});
			indexComboBox.selectedIndex = up.DIAGRAM.indexIndex;
			addChild(indexComboBox);
			
			redoButton = new Button();
			with(redoButton){
				x = 10;
				y = 160;
				width = 90;
				height = 20;
				toggle = true;
				useHandCursor = true;
				label = "Apply changes";
				addEventListener(MouseEvent.CLICK,reprocessHandler);
			}
			addChild(redoButton);
		}
		
		private function reprocessHandler(e:Event):void{
			var sizeMin:Number = new Number(minSizeTF.text);
			var sizeMax:Number = new Number(maxSizeTF.text);
			var colorMin:uint = minColorPicker.selectedColor;
			var colorMax:uint = maxColorPicker.selectedColor;
			var newIndex:int = indexComboBox.selectedIndex;
			
			redoButton.selected = false;
			up.DIAGRAM.setIndexParams([colorMin,colorMax,sizeMin,sizeMax],newIndex);
		}
	}
}