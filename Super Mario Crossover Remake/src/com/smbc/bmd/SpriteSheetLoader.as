package com.smbc.bmd 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Josned
	 */
	public class SpriteSheetLoader 
	{
		private var m_loadedBitmap:BitmapData;
		private var spriteSheet:Bitmap;
		private var spriteWidth:int = 0;
		private var spriteHeight:int = 0;
		private var numXSprites:int = 0;
		private var numYSprites:int = 0;
		private var m_sprites:Vector.<BitmapData>;
		
		public function SpriteSheetLoader(LoadedBitmap:BitmapData, BMwidth:int = 18, BMheight:int = 18, Xsprites:int = 1, Ysprites:int = 1)
		{
			m_loadedBitmap = LoadedBitmap;
			spriteHeight = BMheight;
			spriteWidth = BMwidth;
			numXSprites = Xsprites;
			numYSprites = Ysprites;
			m_sprites = new Vector.<flash.display.BitmapData>(numXSprites * numYSprites,true);
			init();
		}
		
		private function init():void 
		{
			if (spriteSheet == null) spriteSheet = new Bitmap(m_loadedBitmap);
			updateSprites();
		}		
		
		public function deInit():void 
		{
			if (m_loadedBitmap != null)
			{
				m_loadedBitmap.dispose();
				m_loadedBitmap = null;
			}
			if (spriteSheet != null)
			{
				spriteSheet.bitmapData.dispose();
				spriteSheet.bitmapData = null
				spriteSheet = null;
			}
			for (var i:int = 0; i < m_sprites.length; i++) 
			{
				m_sprites[i].dispose();
				m_sprites[i] = null;
			}
			m_sprites.splice(0, m_sprites.length);
		}
		
		public function updateSprites():void 
		{
			var i:int = 0
			var j:int = 0
			for (j = 0; j < numYSprites ; j++) 
			{
				for (i = 0; i < numXSprites; i++) 
				{
					if(m_sprites[(numXSprites * j) + i] == null) m_sprites[(numXSprites * j) + i] = new BitmapData(spriteWidth, spriteHeight);
					m_sprites[(numXSprites * j) + i].copyPixels(spriteSheet.bitmapData, new Rectangle(i * (spriteWidth) + (1 + i), j * (spriteHeight) + (1 + j), spriteWidth, spriteHeight), new Point(0, 0));
				}
			}
			return;
		}

		public function updateSpriteSheet(input:BitmapData):void 
		{
			spriteSheet.bitmapData = input;
			updateSprites();
		}
		
		public function getSprites():Vector.<BitmapData>
		{
			return m_sprites;
		}
		
		public function getSheet():BitmapData 
		{
			return spriteSheet.bitmapData;
		}
		
	}

}