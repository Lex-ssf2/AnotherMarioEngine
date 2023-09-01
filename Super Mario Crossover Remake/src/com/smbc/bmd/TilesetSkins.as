package com.smbc.bmd 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Josned
	 */
	
	public class TilesetSkins{
		
		[Embed(source="TileSet.png")]
		public static const SMB_TILES:Class;
		
		public static const images:Array = [SMB_TILES];
		
		public static function getBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < images.length){
				return new images[imageNum]().bitmapData;
			}
			return new images[0]().bitmapData;
		}
	}

}