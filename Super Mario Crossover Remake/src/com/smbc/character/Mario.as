package com.smbc.character 
{
	import com.smbc.character.Character;
	import com.smbc.bmd.*;
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.MarioSkins;
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
	public dynamic class Mario extends Character 
	{
		
		public function Mario(levelData:Level) 
		{
			super(levelData);
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
			m_currentSheet = new SpriteSheetLoader(MarioSkins.getBitmap(0), 16, 16, 18, 1);
			if(m_animation == null) m_animation = new SpriteSheetAnimation(m_currentSheet.getSprites(),16,16,18,1);
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();
			m_collision.visible = false;
			m_animation.x -= 16 / 2;
			m_animation.y -= 16 / 2;
			addChild(m_animation);
			addChild(m_collision); //Divi DCD
			setPaletteSwap([0xFF4491be, 0xFF29587c], [0, 0]);
			update();
		}
		
		override public function update():void 
		{
			super.update();
			setPaletteSwap([0xFF4491be,0xFF29587c,0xFFb23226], [0,0,changeColor()]);
		}
	}

}