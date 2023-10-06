package com.smbc.bmd.Characters.Mario 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.smbc.bmd.Characters.Mario.*;
	/**
	 * ...
	 * @author Josned
	 */
	
	public class MarioSkins{
		
		public static const images:Array = [SmallSMB3_MARIO, SmallAngrySMB3_Mario];
		public static const bigImages:Array = [BigSMB3_Mario, BigAngrySMB3_Mario];
		
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