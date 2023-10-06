package com.smbc.bmd 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import com.smbc.controller.GameController;
	/**
	 * ...
	 * @author Josned
	 */
	public class SpriteSheetAnimation extends Sprite
	{
		
		private var spriteWidth:int = 0;
		private var spriteHeight:int = 0;
		private var numXSprites:int = 0;
		private var numYSprites:int = 0;
		private var sprites:Vector.<BitmapData>;
		private var currentFrame:int = 0;
		public var animation:Sprite;
		private var m_manualUpdate:Boolean = false;
		private var m_definedAnimation:Boolean = false;
		private var m_sameFrame:Boolean = false;
		public var m_maxFrame:int = 0;
		public var m_initFrame:int = 0;
		public var m_frameDelay:int = 1;
		public var m_actualFrame:int = 0;
		public var __cachedPalette:Dictionary = new Dictionary(true);
		public var currentSheet:Class;
		private var currentAnimation:Array = [0];
			
		public function SpriteSheetAnimation(spritesArray:Vector.<BitmapData>, BMwidth:int = 18, BMheight:int = 18, Xsprites:int = 1, Ysprites:int = 1,preDefined:Boolean = false, updateB:Boolean = false, viaFrame:Boolean = false, delayF:int = 2) 
		{
			spriteWidth = BMwidth;
			spriteHeight = BMheight;
			numXSprites = Xsprites;
			numYSprites = Ysprites;
			m_sameFrame = viaFrame;
			m_frameDelay = delayF;
			m_manualUpdate = updateB;
			sprites = spritesArray.slice();
			m_definedAnimation = preDefined;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (animation == null) animation = new Sprite();
			addChild(animation);
			m_maxFrame = 0;
			animation.y = -spriteHeight / 2;
			animation.x = -spriteWidth / 2;
		}
		
		public function removeListener():void 
		{
			freeBitmapData();
			if(parent != null) parent.removeChild(this);
		}
		
		public function freeBitmapData():void 
		{
			if(animation != null) animation.graphics.clear();
			animation = null;
			if (m_sameFrame) return;
			for (var i:int = 0; i < sprites.length; i++) 
			{
				if (sprites[i] != null)
				{
					sprites[i].dispose();
					sprites[i] = null;
				}
			}
			sprites.splice(0, sprites.length);
		}
		
		public function updateRender(Independent:Boolean = true, delayFrame:int = 2):void 
		{
			if (Independent) 
			{
				m_sameFrame = false;
			}
			else 
			{
				m_sameFrame = true;
				m_frameDelay = delayFrame;
			}
		}
		
		public function updateDelay(delayFrame:int = 2):void 
		{
			m_frameDelay = delayFrame;
		}
		
		public function refreshAnimation():void 
		{
			animation.graphics.clear();
			if (m_definedAnimation == true) animation.graphics.beginBitmapFill(sprites[currentAnimation[currentFrame]]);
			else animation.graphics.beginBitmapFill(sprites[currentFrame]);
			animation.graphics.drawRect( 0, 0, spriteWidth, spriteHeight);
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
			if (m_manualUpdate) return;
			if (!m_sameFrame) 
			{
				if (m_actualFrame % m_frameDelay == 0)
				{
					m_actualFrame = 1;
					update();
					return;
				}
				m_actualFrame++
				return;
			}
			if ((GameController.currentLevel.m_frameInstance) %m_frameDelay == 0)
			{
				currentFrame = m_initFrame + (GameController.currentLevel.m_frameInstance / m_frameDelay) % (m_maxFrame - m_initFrame) - 1;
				update();
			}
			return;
		}
		
		public function setCurrentFrame(frame:int = 0):void 
		{
			currentFrame = frame;
			refreshAnimation();
		}		
		
		public function setCurrentAnimation(animation:Array):void 
		{
			if (currentAnimation != animation)
			{
				currentFrame = 0;
				currentAnimation = animation;
			}
			m_initFrame = 0;
			m_maxFrame = animation.length - 1;
			refreshAnimation();
		}
		
		public function getCurrentFrame():int 
		{
			if (!m_definedAnimation) return currentFrame;
			return currentAnimation[currentFrame];
		}
		
		public function setInitFrame(frame:int = 0,maxFrame:int = 0):void 
		{
			m_initFrame = frame;
			m_maxFrame = maxFrame;
			refreshAnimation();
		}
		
		public function set manualAnimation(value:Boolean):void 
		{
			m_manualUpdate = value;
		}
		
		public function setTiming(frame:int = 1):void 
		{
			m_actualFrame = frame;
		}
		
		public function replacePalette(currentObj:*,bitmapInput:BitmapData,original:Array=null,nColor:Array=null, cacheOriginal:Boolean=false):void
        {
            var i:int;
            var bitmap:BitmapData = bitmapInput;
            if (original && nColor || cacheOriginal)
            {
				if (cacheOriginal)
				{
					if (((!(currentObj.__cachedPalette)) || (!(currentObj.__cachedPalette[bitmap]))))
					{
						currentObj.__cachedPalette = ((currentObj.__cachedPalette) || (new Dictionary(true)));
						currentObj.__cachedPalette[bitmap] = bitmap.clone();
					}
					else
					{
						bitmap.copyPixels(currentObj.__cachedPalette[bitmap], new Rectangle(0, 0, currentObj.__cachedPalette[bitmap].width, currentObj.__cachedPalette[bitmap].height), new Point())
					};
				};
				if (original && nColor)
				{
					replacePaletteHelper(bitmap,original,nColor);
				};
            };
        }

        public function replacePaletteHelper(bitmapData:BitmapData, original:Array=null,nColor:Array=null):void
        {
            var i:int;
            while (i < nColor.length)
            {
                if (nColor[i] != original[i])
                {
                    bitmapData.threshold(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point() , "==", original[i], nColor[i], 0xFFFFFFFF, true);
                };
                i++;
            };
        }
		
		public function updateSheet(input:Vector.<BitmapData>, BMwidth:int = 18, BMheight:int = 18, Xsprites:int = 1, Ysprites:int = 1):void 
		{
			spriteWidth = BMwidth;
			spriteHeight = BMheight;
			numXSprites = Xsprites;
			numYSprites = Ysprites;
			for (var i:int = 0; i < input.length; i++) 
			{
				sprites[i] = input[i].clone();
			};
		}
		
		/*public function updateColors(original:Array=null,nColor:Array=null):void 
		{
			spriteSheetData = ogSpriteSheetData.clone();
			if (original != null && nColor != null)
			{
				for (var i:int = 0; i < original.length; i++) 
				{
					spriteSheetData.threshold(spriteSheetData, spriteSheetData.rect, new Point(), "==", original[i], nColor[i], 0xFFFFFFFF, true);
				}
			}
			if (spriteSheet.bitmapData != null)
			{
				spriteSheet.bitmapData.dispose();
				spriteSheet.bitmapData = null;
			}
			spriteSheet = null;
			spriteSheet = new Bitmap(spriteSheetData);
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
			for (j = 0; j < numYSprites ; j++) 
			{
				for (i = 0; i < numXSprites; i++) 
				{
					sprites[(numXSprites * j) + i] = new BitmapData(spriteWidth, spriteHeight);
					sprites[(numXSprites * j) + i].copyPixels(spriteSheet.bitmapData, new Rectangle(i * (spriteWidth) + (1 + i), j * (spriteHeight) + (1 + j), spriteWidth, spriteHeight), new Point(0, 0));
				}
			}
			return;
		}*/
	}

}