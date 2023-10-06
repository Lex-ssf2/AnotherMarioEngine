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
		
		[Embed(source="Items/Particles.png")]
		public static const SMB3_PARTICLES:Class;
		
		public static const images:Array = [SMB_TILES];
		public static const imagesEffects:Array = [SMB3_PARTICLES];
		
		public static function getBitmap(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < images.length){
				return new images[imageNum]().bitmapData;
			}
			return new images[0]().bitmapData;
		}
		
		public static function getBitmapParticles(imageNum:int):BitmapData 
		{
			if (imageNum >= 0 && imageNum < imagesEffects.length){
				return new imagesEffects[imageNum]().bitmapData;
			}
			return new imagesEffects[0]().bitmapData;
		}
	}

}