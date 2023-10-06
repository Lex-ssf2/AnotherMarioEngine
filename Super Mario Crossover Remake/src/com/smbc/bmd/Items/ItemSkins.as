package com.smbc.bmd.Items 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.smbc.bmd.Characters.Mario.*;
	/**
	 * ...
	 * @author Josned
	 */
	
	public class ItemSkins{
		
		public static const images:Array = [SMB3_ITEMS];
		
		public static function getBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < images.length){
				return new images[imageNum].imageSrc().bitmapData;
			}
			return new images[0].imageSrc().bitmapData;
		}
	}

}