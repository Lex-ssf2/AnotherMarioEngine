package com.smbc.character 
{
	import com.smbc.character.Character;
	import com.smbc.bmd.*;
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.Characters.Mario.MarioSkins;
	import com.smbc.character.base.MarioBase;
	import com.smbc.character.base.CharacterStats;
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
	public dynamic class Mario extends MarioBase 
	{
		public function Mario(characterSettings:* = null,characterID:String = null) 
		{
			super();
			if (characterSettings == null) m_classID = MarioSkins;
			else {
				m_currentSkin = 0;
				m_classID = characterSettings["get" + characterID]()["bitmapController"];
				m_jumpSpeed = characterSettings["get" + characterID]()["jumpSpeed"];
				m_shortHopSpeed = characterSettings["get" + characterID]()["shortHopSpeed"];
				m_gravity = characterSettings["get" + characterID]()["gravity"];
				m_XSpeed = characterSettings["get" + characterID]()["XSpeed"];
			}
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
		}
	}

}