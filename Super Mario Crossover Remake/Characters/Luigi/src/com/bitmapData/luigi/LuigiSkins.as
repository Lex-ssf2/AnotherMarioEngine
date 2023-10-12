package com.bitmapData.luigi
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.bitmapData.luigi.*;
	/**
	 * ...
	 * @author Josned
	 */
	
	public class LuigiSkins{
		
		public static const images:Array = [SmallSMB3_Luigi];
		public static const bigImages:Array = [BigSMB3_Luigi];
		
		public static function getBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < images.length){
				return new images[imageNum].imageSrc().bitmapData;
			}
			return new images[0].imageSrc().bitmapData;
		}
		
		public static function getBigBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < bigImages.length){
				return new bigImages[imageNum].imageSrc().bitmapData;
			}
			return new bigImages[0].imageSrc().bitmapData;
		}
	}

}