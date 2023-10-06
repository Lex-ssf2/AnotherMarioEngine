package com.smbc.bmd.Characters.Luigi 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Josned
	 */
	public class SmallSMB3_Luigi
	{
		[Embed(source="LuigiSmall.png")]
		public static const imageSrc:Class
		public static const idle:Array = [0];
		public static const walk:Array = [0,1];
		public static const jump:Array = [3];
		public static const turn:Array = [2];
		public static const dead:Array = [13];
		public static const ogPalette:Array = [0xFF29587c, 0xFF4491be, 0xFFb23226, 0xFFfecec7,0xFF000000];
		public static const regular:Array = [0, 0, 0xFF62e240, 0xFFfecec7,0xFF000000];
		public static const fire:Array = [0, 0, 0xFFe89d34, 0xFFfecec7, 0xFFb23226];
		public static const m_coords:Point = new Point( -8, -10);
		public static const BMwidth:int = 18;
		public static const BMheight:int = 18;
		public static const Xsprites:int = 4;
		public static const Ysprites:int = 4;
	}

}