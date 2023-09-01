package com.smbc.bmd 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Josned
	 */
	public class SpriteSheetAnimation extends Sprite
	{
		private var spriteSheetClass:Class;
		
		private var spriteSheetData:BitmapData;
		private var ogSpriteSheetData:BitmapData;
		private var spriteSheet:Bitmap;
		private var spriteWidth:int = 0;
		private var spriteHeight:int = 0;
		private var numXSprites:int = 0;
		private var numYSprites:int = 0;
		private var sprites:Array = [];
		private var currentFrame:int = 0;
		private var animation:Sprite;
		private var animationTimer:Timer;
		public var m_maxFrame:int = 0;
		public var m_initFrame:int = 0;
			
		public function SpriteSheetAnimation(bitmapDataClass:BitmapData,BMwidth:int = 18,BMheight:int = 18,Xsprites:int = 1,Ysprites:int = 1) 
		{
			spriteWidth = BMwidth;
			spriteHeight = BMheight;
			numXSprites = Xsprites;
			numYSprites = Ysprites;
			ogSpriteSheetData = bitmapDataClass;
			spriteSheet = new Bitmap(ogSpriteSheetData);
			animation = new Sprite();
			addChild(animation);
			updateSprites();
			
			animationTimer = new Timer(1000 / 18);
			animationTimer.addEventListener(TimerEvent.TIMER, update);
			animationTimer.start();
			m_maxFrame = (Ysprites * Xsprites) - 1;
		}
		
		public function updateColors(original:Array=null,nColor:Array=null):void 
		{
			spriteSheetData = ogSpriteSheetData.clone();
			if (original != null && nColor != null)
			{
				for (var i:int = 0; i < original.length; i++) 
				{
					spriteSheetData.threshold(spriteSheetData, spriteSheetData.rect, new Point(), "==", original[i], nColor[i], 0xFFFFFFFF, true);
				}
			}
			spriteSheet = new Bitmap(spriteSheetData);
			updateSprites();
		}
		
		public function get SheetBM():BitmapData 
		{
			return ogSpriteSheetData;
		}
		
		public function updateSheet(nSheet:BitmapData):void 
		{
			ogSpriteSheetData = nSheet.clone();
		}

		public function updateSprites():void 
		{
			sprites.splice(0, sprites.length);
			var i:int = 0
			var j:int = 0
			var spriteData:BitmapData
			for (j = 0; j < numYSprites ; j++) 
			{
				for (i = 0; i < numXSprites; i++) 
				{
					spriteData = new BitmapData(spriteWidth, spriteHeight);
					spriteData.copyPixels(spriteSheet.bitmapData, new Rectangle(i * (spriteWidth) + (1 + i), j * (spriteHeight) + (1 + j), spriteWidth, spriteHeight), new Point(0, 0));
					sprites.push(spriteData);
				}
			}
			return;
		}
		
		public function refreshAnimation():void 
		{
			animation.graphics.clear();
			animation.graphics.beginBitmapFill(sprites[currentFrame]);
			animation.graphics.drawRect(0, 0, spriteWidth, spriteHeight);
			animation.graphics.endFill();
		}
		
		public function update(e:Event):void 
		{
			currentFrame++
			if (currentFrame > m_maxFrame){
				currentFrame = m_initFrame;
			}
			refreshAnimation();
		}
		
		public function setCurrentFrame(frame:int = 0):void 
		{
			currentFrame = frame;
			refreshAnimation();
		}		
		
		public function setInitFrame(frame:int = 0,maxFrame:int = 0):void 
		{
			m_initFrame = frame;
			currentFrame = frame;
			m_maxFrame = maxFrame;
			refreshAnimation();
		}
		
		public function setTiming(frame:int = 1):void 
		{
			animationTimer.delay = (1000 / frame);
		}
	}

}