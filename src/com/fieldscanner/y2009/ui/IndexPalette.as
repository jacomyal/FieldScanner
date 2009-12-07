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
		
		private var colorIndexComboBox:ComboBox;
		private var sizeIndexComboBox:ComboBox;
		private var minColorPicker:ColorPicker;
		private var maxColorPicker:ColorPicker;
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
				text = "Index settings:";
				setTextFormat(up.TITLE_FORMAT);
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
			}
			addChild(iTF);
			
			var minTF:TextField = new TextField();
			with(minTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "Low color border: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 15;
				y = 30;
			}
			addChild(minTF);
			
			minColorPicker = new ColorPicker();
			with(minColorPicker){
				x = 150;
				y = 30;
				height = 15;
				selectedColor = up.DIAGRAM.INDEX_STATUS[0];
			}
			addChild(minColorPicker);
			
			var maxTF:TextField = new TextField();
			with(maxTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "High color border: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 15;
				y = 50;
			}
			addChild(maxTF);
			
			maxColorPicker = new ColorPicker();
			with(maxColorPicker){
				x = 150;
				y = 50;
				height = 15;
				selectedColor = up.DIAGRAM.INDEX_STATUS[1];
			}
			addChild(maxColorPicker);
			
			var minSTF:TextField = new TextField();
			with(minSTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "Low size border: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 15;
				y = 70;
			}
			addChild(minSTF);
			
			minSizeTF = new TextField();
			with(minSizeTF){
				type = TextFieldType.INPUT;
				text = up.DIAGRAM.INDEX_STATUS[2].toString();
				setTextFormat(up.INPUT_FORMAT);
				x = 150;
				y = 70;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				addEventListener(Event.CHANGE,up.inputHandler);
			}
			addChild(minSizeTF);
			
			var maxSTF:TextField = new TextField();
			with(maxSTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "High size border: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 15;
				y = 90;
			}
			addChild(maxSTF);
			
			maxSizeTF = new TextField();
			with(maxSizeTF){
				type = TextFieldType.INPUT;
				text = up.DIAGRAM.INDEX_STATUS[3].toString();
				setTextFormat(up.INPUT_FORMAT);
				x = 150;
				y = 90;
				selectable = true;
				background = true;
				autoSize = TextFieldAutoSize.LEFT;
				addEventListener(Event.CHANGE,up.inputHandler);
			}
			addChild(maxSizeTF);
			
			var sizeIndexTF:TextField = new TextField();
			with(sizeIndexTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "Size index: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 15;
				y = 115;
			}
			addChild(sizeIndexTF);
			
			sizeIndexComboBox = new ComboBox();
			with(sizeIndexComboBox){
				x = 100;
				y = 115;
			}
			for(var i:int=0;i<up.DIAGRAM.INDEXES.length;i++) sizeIndexComboBox.addItem({label:up.DIAGRAM.INDEXES[i]});
			sizeIndexComboBox.selectedIndex = up.DIAGRAM.SIZE_INDEX;
			addChild(sizeIndexComboBox);
			
			var colorIndexTF:TextField = new TextField();
			with(colorIndexTF){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "Color index: ";
				setTextFormat(up.BASIC_FORMAT);
				x = 15;
				y = 140;
			}
			addChild(colorIndexTF);
			
			colorIndexComboBox = new ComboBox();
			with(colorIndexComboBox){
				x = 100;
				y = 140;
			}
			for(var j:int=0;j<up.DIAGRAM.INDEXES.length;j++) colorIndexComboBox.addItem({label:up.DIAGRAM.INDEXES[j]});
			colorIndexComboBox.selectedIndex = up.DIAGRAM.COLOR_INDEX;
			addChild(colorIndexComboBox);
			
			redoButton = new Button();
			with(redoButton){
				x = 15;
				y = 165;
				width = 120;
				height = 20;
				toggle = true;
				useHandCursor = true;
				label = "Apply changes";
				setStyle("textFormat",up.TITLE_FORMAT);
				addEventListener(MouseEvent.CLICK,reprocessHandler);
			}
			addChild(redoButton);
		}
		
		private function reprocessHandler(e:Event):void{
			var sizeMin:Number = new Number(minSizeTF.text);
			var sizeMax:Number = new Number(maxSizeTF.text);
			var colorMin:uint = minColorPicker.selectedColor;
			var colorMax:uint = maxColorPicker.selectedColor;
			var newColorIndex:int = colorIndexComboBox.selectedIndex;
			var newSizeIndex:int = sizeIndexComboBox.selectedIndex;
			
			redoButton.selected = false;
			up.DIAGRAM.setIndexParams([colorMin,colorMax,sizeMin,sizeMax],newColorIndex,newSizeIndex);
		}
	}
}