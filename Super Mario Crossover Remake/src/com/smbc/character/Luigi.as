package com.smbc.character 
{
	import com.smbc.character.Character;
	import com.smbc.bmd.*;
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.Characters.Luigi.LuigiSkins;
	import com.smbc.character.base.MarioBase;
	import com.smbc.engine.Level;
	import com.smbc.tiles.Block;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;
	import com.smbc.engine.interactiveSprite;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Luigi extends MarioBase 
	{
		
		public function Luigi() 
		{
			super();
			m_classID = LuigiSkins;
			m_currentSkin = 0;
			m_gravity = 1;
			m_jumpSpeed = 7.5;
			m_XSpeed = 2.8;
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
		}
	}

}