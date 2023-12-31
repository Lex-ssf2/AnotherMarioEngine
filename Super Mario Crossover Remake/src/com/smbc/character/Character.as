package com.smbc.character 
{
	import com.smbc.bmd.*;
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.Characters.Mario.MarioSkins;
	import com.smbc.controller.CharacterData;
	import com.smbc.controller.PlayerSetting;
	import com.smbc.engine.Level;
	import com.smbc.projectiles.Projectile;
	import com.smbc.tiles.Block;
	import com.smbc.utils.Controller;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;
	import com.smbc.engine.interactiveSprite;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import com.smbc.utils.*;
	
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Character extends interactiveSprite 
	{
		private var key:KeyObject;
		public var m_isWalking:Boolean = false;
		public var m_pressJump:Boolean = false;
		public var m_jumpBuffer:int = 0;
		public var m_jumpBufferMax:int = 6;
		public var m_right:Boolean = false;
		public var m_left:Boolean = false;
		public var m_up:Boolean = false;
		public var m_down:Boolean = false;
		public var m_button1:Boolean = false;
		public var m_button2:Boolean = false;
		public var m_hitEnemy:Boolean = false;
		public var m_transformAnim:int = 0;
		public var m_state:int = 0;
		public var m_invincibleFrames:int;
		public var m_invincible:Boolean = false;
		
		//Mario Base var
		public var frameAnim:int = 0;
		public var currentPallete:Array;
		public var m_currentSkin:int = 0;
		public var m_classID:Class;
		public var m_characterID:int = -1;
		public var m_MoveFunction:Function = null;
		public var m_player:int = -1;
		public var m_key:Controller;
		
		//test
		public var m_graphic:Sprite;
		
		public function Character(characterData:CharacterData = null,characterSettings:PlayerSetting = null) 
		{
			m_entityNum = EntityTypes.Characters;
			super();
			if (characterData == null) m_classID = MarioSkins;
			else {
				m_currentSkin = characterSettings.costume;
				m_classID = characterData.BitmapController;
				m_jumpSpeed = characterData.JumpSpeed;
				m_shortHopSpeed = characterData.ShortHopSpeed;
				m_gravity = characterData.Gravity;
				m_XSpeed = characterData.XSpeed;
				m_MoveFunction = characterData.PerformAll;
				DecelRate = characterData.DecelRate;
				AccelRate = characterData.AccelRate;
				minimunXSpeed = characterData.minimunXSpeed;
				m_player = characterData.PlayerID;
				m_key = getControllerNum(m_player);
			}
		}
		
		override protected function init(e:Event):void 
		{
			var i:int;
			super.init(e);
			//Mario Base
			m_currentSheet = new SpriteSheetLoader(m_classID.getBitmap(m_currentSkin), m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			if (m_animation == null) m_animation = new SpriteSheetAnimation(m_currentSheet.getSprites(), m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites, true);
			m_animation.currentSheet = m_classID.images[m_currentSkin];
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0xFFFF00);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();			
			m_graphic = new Sprite();
			m_graphic.graphics.beginFill(0xFF0000);
			m_graphic.graphics.drawRect(-16/2, -1/2, 16, 1);
			m_graphic.graphics.endFill();
			m_graphic.visible = true;
			m_collision.visible = false;
			addChild(m_collision); //Divi DCD
			addChild(m_animation);
			addChild(m_graphic);
			currentPallete = m_animation.currentSheet.regular;
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			update();
			m_animation.animation.x = m_classID.images[m_currentSkin].m_coords.x;
			m_animation.animation.y = m_classID.images[m_currentSkin].m_coords.y;
			if (LEVELDATA != null) m_characterID = LEVELDATA.CHARACTERS.indexOf(this);
			while (i < maxProjectiles)
            {
                m_projectiles[i] = null;
                i++;
            };
		}
		
		override public function update():void
		{
			m_animation.performAll();
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			if (LEVELDATA == null) return;
			if (LEVELDATA.m_levelPaused) return;
			super.update();
			buttonPressed();
			characterMove();
			//Mario Base
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			if (LEVELDATA.m_frameInstance % 1 == 0) frameAnim++;
			if (frameAnim > 3) frameAnim = 0;
			m_graphic.y = m_animation.y + m_collision.height/2 +  Math.min(m_gravity + m_jumpSpeed,m_vy);
			m_graphic.x = m_animation.x;
			//setPaletteSwap([0xFF4491be, 0xFF29587c, 0xFFb23226, 0xFFfecec7, 0xFF000000], [0, 0, starManAnimation(frameAnim, 1), starManAnimation(frameAnim, 2), starManAnimation(frameAnim, 3)]);
		}
		
		public function updateCharacter(characterData:CharacterData):void 
		{
			m_currentSkin = 0;
			m_classID = characterData.BitmapController;
			m_jumpSpeed = characterData.JumpSpeed;
			m_shortHopSpeed = characterData.ShortHopSpeed;
			m_gravity = characterData.Gravity;
			m_XSpeed = characterData.XSpeed;
			m_MoveFunction = characterData.PerformAll;
			m_animation.currentSheet = m_classID.images[m_currentSkin];
			m_currentSheet.updateSpriteSheet(m_classID.getBitmap(m_currentSkin),m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			m_animation.updateSheet(m_currentSheet.getSprites(), m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			currentPallete = m_animation.currentSheet.regular;
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			m_animation.animation.x = m_classID.images[m_currentSkin].m_coords.x + 16;
			m_animation.animation.y = m_classID.images[m_currentSkin].m_coords.y + 16;
			if (m_animation != null) m_animation.setCurrentAnimation(m_animation.currentSheet.walk);
			visible = true;
		}
		
		public function updateCostume(costume:int):void
		{
			m_currentSkin = costume;
			m_animation.currentSheet = m_classID.images[m_currentSkin];
			m_currentSheet.updateSpriteSheet(m_classID.getBitmap(m_currentSkin),m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			m_animation.updateSheet(m_currentSheet.getSprites(), m_classID.images[m_currentSkin].BMwidth, m_classID.images[m_currentSkin].BMheight, m_classID.images[m_currentSkin].Xsprites, m_classID.images[m_currentSkin].Ysprites);
			currentPallete = m_animation.currentSheet.regular;
			setPaletteSwap(m_animation.currentSheet.ogPalette, currentPallete);
			m_animation.animation.x = m_classID.images[m_currentSkin].m_coords.x + 16;
			m_animation.animation.y = m_classID.images[m_currentSkin].m_coords.y + 16;
			if (m_animation != null) m_animation.setCurrentAnimation(m_animation.currentSheet.walk);
			visible = true;
		}
		
		public function transformAnimation(e:Event):void 
		{
			if (this.m_animation == null) return;
			m_transformAnim++
			if (m_transformAnim <= 2)
			{
				m_animation.performAll();
			}
			if (m_transformAnim % 4 == 0)
			{
				this.m_animation.visible = true;
			}
			else 
			{
				this.m_animation.visible = false;
			}
			if (m_transformAnim >= 10)
			{
				LEVELDATA.m_levelPaused = false;
				this.m_animation.visible = true;
				removeEventListener(Event.ENTER_FRAME, transformAnimation);
			}
		}
		
		public function gotHit():void 
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
					setxSpeed(0);
					m_isDead = true;
					m_ignoreTerrain = true;
				break;
				default:
			}
			return;
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
		
		protected function invicibilityFrames(e:Event = null):void 
		{
			if (this.m_animation == null) return;
			m_invincible = true;
			m_invincibleFrames--
			if (m_invincibleFrames % 4 == 0)
			{
				this.m_animation.visible = true;
			}
			else 
			{
				this.m_animation.visible = false;
			}
			if (m_invincibleFrames <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, invicibilityFrames);
				m_invincibleFrames = 0;
				m_invincible = false;
			}
		}
		
		private function buttonPressed():void 
		{
			if (m_isDead)
			{
				m_up = false;
				m_down = false;
				m_right = false;
				m_left = false;
				m_button1 = false;
				m_button2 = false;
				return;
			}
			if (m_key.IsDown(m_key.m_left)){
				m_right = false;
				m_left = true;
			}else if (m_key.IsDown(m_key.m_right)) 
			{
				m_right = true;
				m_left = false;
			}
			else
			{
				m_right = false;
				m_left = false;
			}
			if (m_key.IsDown(m_key.m_up)){
				m_up = true;
				m_down = false;
			}else if (m_key.IsDown(m_key.m_down)){
				m_down = true;
				m_up = false;
			}		
			else {
				m_down = false;
				m_up = false;
			}
			if (m_key.IsDown(m_key.m_button1)){
				m_button1 = true;
			}else {
				m_button1 = false;
			}
			if (m_key.IsDown(m_key.m_button2)){
				m_button2 = true;
			}else {
				m_button2 = false;
			}
		}
		
		protected function characterMove():void
		{
			/*if (m_button2)
			{
				if (!m_firedProjectile) fireProjectile();
				m_firedProjectile = true;
			}
			else 
			{
				m_firedProjectile = false;
			}*/
			if(m_down)
			{
				if(m_canSlide != 0 && getOnGround()){
					m_vx += m_canSlide;
					m_vx *= 1.25;
				}
				if(m_vx != 0)
					m_animationName = "slide";
			}
			if (m_MoveFunction != null)
			{
				m_MoveFunction(this);
			}
			return;
		}
		
		public function fireProjectile():Projectile	//proj:*, xOverride:Number=0, yOverride:Number=0, absolute:Boolean=false, options:Object=null
        {
			/*	"owner":this,
				"player_id":m_player_id,
				"x_start":m_sprite.x,
				"y_start":m_sprite.y,
				"sizeRatio":m_sizeRatio,
				"facingForward":m_facingForward,
				"chargetime":((options.chargetime) || (m_attack.ChargeTime)),
				"chargetime_max":((options.chargetime_max) || (m_attack.ChargeTimeMax)),
				"frame":(n.StatsName + "_proj"),
				"staleMultiplier":this.totalMoveDecay((n.StatsName + "_proj")),
				"sizeStatus":this.m_sizeStatus,
				"terrains":m_terrains,
				"platforms":m_platforms,
				"team_id":m_team_id,
				"volume_sfx":this.m_characterStats.VolumeSFX,
				"volume_vfx":this.m_characterStats.VolumeVFX
			}, n, STAGEDATA
			*/
			var i:int = 0;
			for (i = 0; i < maxProjectiles; i++) 
			{
				if (m_projectiles[i] != null && !m_projectiles[i].m_isDead)
				{
					if (i != maxProjectiles - 1)
					{
						continue;
					}
					LEVELDATA.removeProjectile(LEVELDATA.PROJECTILES.indexOf(m_projectiles[0]));
					m_projectiles.shift();
				}
					m_projectiles[i] = new Projectile({
					"owner":this,
					"player_id":m_player,
					"x_start":x,
					"y_start":y,
					"scaleRatio":m_currentScale,
					"facingRight":m_facingRight,
					"team_id":m_player
				});
				break;
			}
			return m_projectiles[Math.min(i,m_projectiles.length - 1)];
		}
		
		public function getControllerNum(cnum:int):Controller
        {
            if (cnum > saveData.controllers.length || cnum < 0 || saveData.controllers[cnum] == null)
            {
                return (null);
            };
            return saveData.controllers[cnum] as Controller;
        }
		
		override public function SetCollisionNum(num:uint):void
		{
			m_CollisionNum = num;
			if (!m_onGround && (m_CollisionNum == 4 || m_CollisionNum == 8))
			{
				//tracePared(m_CollisionNum)
			}
		}
		
		public function tracePared(collision:int):void 
		{
			if (collision == 8 && m_facingRight || collision == 4 && !m_facingRight)
			{
				trace("XD");
				return;
			}
			m_vx = 0;
			m_vy = 0;
			switch (collision) 
			{
				case 4:
					m_vx = 1;
					if (m_right == false)
					{
						m_vx = -0.5;
						return;
					}
					if (m_button1)
					{
						setxSpeed( -(m_XSpeed * 1.5));
						setySpeed( -m_jumpSpeed * 2);
					}
				break;
				case 8:
				m_vx = -1;
					if (m_left == false)
					{
						m_vx = 0.5;
						return;
					}
					if (m_button1)
					{
						setxSpeed(m_XSpeed * 1.5);
						setySpeed( -m_jumpSpeed * 2);
					}
				break;
				default:
			}
			if (m_up)
			{
				setySpeed(-2);
				return;
			}			
			if (m_down)
			{
				setySpeed(2);
				return;
			}
		}
		
		override protected function checkGround():void 
		{
			m_vy += m_gravity;
			if (m_coyoteCount < m_coyoteTime && m_onGround)
			{
				m_coyoteCount++;
			}
			else {
				m_coyoteCount = 0;
				m_onGround = false;
				m_isWalking = false;
			}
			/*if (y + height/2 != m_floor)
			{
				m_vy += m_gravity;
				if (m_coyoteCount < m_coyoteTime && m_onGround)
				{
					m_coyoteCount++;
				}
				else {
					m_onGround = false;
					m_isWalking = false;
				}
			}else {
				m_vy = 0;
				y = m_floor;
				m_coyoteCount = 0;
			}*/
		}
		
		/*public function starManAnimation(colorArray:int,frame:int):uint
		{
			return palleteStarMan[colorArray][frame - 1];
		}*/
	}

}