package com.bitmapData.mario 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Josned
	 */
	public class BigSMB3_Mario
	{
		[Embed(source="BigMario.png")]
		public static const imageSrc:Class
		public static const idle:Array = [0];
		public static const walk:Array = [0,1,2,1];
		public static const jump:Array = [4];
		public static const turn:Array = [9];
		public static const dead:Array = [31];
		public static const slide:Array = [16];
		public static const ogPalette:Array = [0xFF29587c, 0xFF4491be, 0xFFb23226, 0xFFfecec7,0xFF000000];
		public static const regular:Array = [0, 0, 0xFFb23226, 0xFFfecec7,0xFF000000];
		public static const fire:Array = [0, 0, 0xFFe89d34, 0xFFfecec7, 0xFFb23226];
		public static const BMwidth:int = 32;
		public static const BMheight:int = 32;
		public static const Xsprites:int = 6;
		public static const Ysprites:int = 6;
		public static const m_coords:Point = new Point( -16, -19);
	}

}