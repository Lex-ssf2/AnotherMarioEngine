package com.smbc.bmd 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Josned
	 */
	
	public class MarioSkins{
		
		[Embed(source = "SmallMario.png")]
		public static const SMB3_MARIO:Class;
		
		[Embed(source="SmallMario2.png")]
		public static const SMB3Blue_MARIO:Class;
		
		public static const images:Array = [SMB3_MARIO,SMB3Blue_MARIO];
		
		public static function getBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < images.length){
				return new images[imageNum]().bitmapData;
			}
			return new images[0]().bitmapData;
		}
	}

}