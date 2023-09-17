package com.smbc.bmd 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Josned
	 */
	
	public class EnemiesSkins{
		
		[Embed(source="Goomba.png")]
		public static const SMB3_ENEMIES:Class;
		
		public static const images:Array = [SMB3_ENEMIES];
		
		public static function getBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < images.length){
				return new images[imageNum]().bitmapData;
			}
			return new images[0]().bitmapData;
		}
	}

}