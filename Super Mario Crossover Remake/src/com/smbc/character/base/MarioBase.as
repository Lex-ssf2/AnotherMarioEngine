package com.smbc.character.base 
{
	import com.smbc.character.Character;
	import com.smbc.bmd.*;
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.Characters.Mario.MarioSkins;
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
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class MarioBase extends Character 
	{
		
		public var frameAnim:int = 0;
		public var currentPallete:Array;
		public var m_currentSkin:int = 0;
		public var m_classID:Class;
		public var m_characterID:int = -1;
		public var m_MoveFunction:Function = null;
		
		public function MarioBase(characterSettings:* = null,characterID:String = null) 
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
				m_MoveFunction = characterSettings["get" + characterID]()["performAll"];
			}
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
			m_currentSheet = new SpriteSheetLoader(m_classID.getBitmap(m_currentSkin), m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			if (m_animation == null) m_animation = new SpriteSheetAnimation(m_currentSheet.getSprites(), m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites, true);
			m_animation.currentSheet = m_classID.images[m_currentSkin];
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();
			m_collision.visible = false;
			addChild(m_collision); //Divi DCD
			addChild(m_animation);
			currentPallete = m_animation.currentSheet.regular;
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			update();
			m_animation.animation.x = m_classID.images[m_currentSkin].m_coords.x;
			m_animation.animation.y = m_classID.images[m_currentSkin].m_coords.y;
			if(LEVELDATA != null) m_characterID = LEVELDATA.m_CharacterList.indexOf(this);
		}
		
		override public function update():void 
		{
			super.update();
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			if (LEVELDATA == null) return;
			if (LEVELDATA.m_frameInstance % 1 == 0) frameAnim++;
			if (frameAnim > 3) frameAnim = 0;
			//setPaletteSwap([0xFF4491be, 0xFF29587c, 0xFFb23226, 0xFFfecec7, 0xFF000000], [0, 0, starManAnimation(frameAnim, 1), starManAnimation(frameAnim, 2), starManAnimation(frameAnim, 3)]);
		}
				
		override public function gotHit():void 
		{
			LEVELDATA.m_levelPaused = true;
			m_transformAnim = 0;
			m_invincibleFrames = 30 * 3;
			addEventListener(Event.ENTER_FRAME, transformAnimation, false, 0, true);
			if (m_state != 0)
			{
				addEventListener(Event.ENTER_FRAME, invicibilityFrames, false, 0, true);
			}
			switch (m_state) 
			{
				case 1:
					m_state = 0;
					transformSmall();
				break;
				case 2:
					m_state = 1;
					updatePalette("regular");
				break;
				case 0:
					setySpeed( -15);
					m_isDead = true;
					m_ignoreTerrain = true;
				break;
				default:
			}
		}
		
		public function transformBig():void 
		{
			m_collision.graphics.clear();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -13, 16,26);
			m_collision.graphics.endFill();
			m_animation.currentSheet = m_classID.bigImages[m_currentSkin];
			m_currentSheet.updateSpriteSheet(m_classID.getBigBitmap(m_currentSkin),m_classID.bigImages[m_currentSkin].BMwidth, m_classID.bigImages[m_currentSkin].BMheight, m_classID.bigImages[m_currentSkin].Xsprites, m_classID.bigImages[m_currentSkin].Ysprites);
			m_animation.updateSheet(m_currentSheet.getSprites(), m_classID.bigImages[m_currentSkin].BMwidth, m_classID.bigImages[m_currentSkin].BMheight, m_classID.bigImages[m_currentSkin].Xsprites, m_classID.bigImages[m_currentSkin].Ysprites);
			m_animation.animation.x = m_classID.bigImages[m_currentSkin].m_coords.x;
			m_animation.animation.y = m_classID.bigImages[m_currentSkin].m_coords.y;
		}
		
		public function updatePalette(palette:String):void 
		{
			currentPallete = m_animation.currentSheet[palette];
		}
		
		public function transformSmall():void 
		{
			m_collision.graphics.clear();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();
			m_animation.currentSheet = m_classID.images[m_currentSkin];
			m_currentSheet.updateSpriteSheet(m_classID.getBitmap(m_currentSkin),m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			m_animation.updateSheet(m_currentSheet.getSprites(),m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			m_animation.animation.x = m_classID.images[m_currentSkin].m_coords.x;
			m_animation.animation.y = m_classID.images[m_currentSkin].m_coords.y;
		}
		
		override protected function characterMove():void
		{
			if (m_MoveFunction != null)
			{
				m_MoveFunction(this);
			}
		}
		
		/*public function starManAnimation(colorArray:int,frame:int):uint
		{
			return palleteStarMan[colorArray][frame - 1];
		}*/
	}

}