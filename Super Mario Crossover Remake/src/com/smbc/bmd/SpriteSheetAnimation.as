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
		private var m_manualUpdate:Boolean = false;
		private var m_sameFrame:Boolean = false;
		public var m_maxFrame:int = 0;
		public var m_initFrame:int = 0;
		public var m_frameDelay:int = 1;
			
		public function SpriteSheetAnimation(bitmapDataClass:BitmapData, BMwidth:int = 18, BMheight:int = 18, Xsprites:int = 1, Ysprites:int = 1, updateB:Boolean = false, viaFrame:Boolean = false, delayF:int = 2) 
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
			m_sameFrame = viaFrame;
			m_frameDelay = delayF;
			addEventListener(Event.ADDED_TO_STAGE, init);
			m_manualUpdate = updateB;
			m_maxFrame = (Ysprites * Xsprites) - 1;
		}
		
		public function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (!m_sameFrame)
			{
				animationTimer = new Timer(1000 / 18);
				animationTimer.addEventListener(TimerEvent.TIMER, update);
				animationTimer.start();
			}
			addEventListener(Event.ENTER_FRAME, performAll);
		}
		
		public function updateRender(Independent:Boolean = true, delayFrame:int = 2):void 
		{
			animationTimer.removeEventListener(TimerEvent.TIMER, update);
			removeEventListener(Event.ENTER_FRAME, performAll);
			if (Independent) m_sameFrame = false;
			else 
			{
				m_sameFrame = true;
				m_frameDelay = delayFrame;
			}
			init();
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
		
		public function getBMDFrame(frame:int):BitmapData 
		{
			return sprites[frame];
		}
		
		public function update(e:Event = null):void 
		{
			if (m_manualUpdate) return;
			currentFrame++
			if (currentFrame > m_maxFrame){
				currentFrame = m_initFrame;
			}
			refreshAnimation();
		}
		
		public function performAll(e:Event = null):void 
		{
			if (!m_sameFrame || m_manualUpdate) return;
			if ((Main.Root.m_level.m_frameInstance) %m_frameDelay == 0)
			{
				currentFrame = m_initFrame + (Main.Root.m_level.m_frameInstance / m_frameDelay) % (m_maxFrame - m_initFrame) - 1;
				update();
			}
		}
		
		public function setCurrentFrame(frame:int = 0):void 
		{
			currentFrame = frame;
			refreshAnimation();
		}
		
		public function getCurrentFrame():int 
		{
			return currentFrame;
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
		
		public function set manualAnimation(value:Boolean):void 
		{
			m_manualUpdate = value;
		}
	}

}