package com.smbc.character 
{
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
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Character extends interactiveSprite 
	{
		private var key:KeyObject;
		public var m_isWalking:Boolean = false;
		public var m_pressJump:Boolean = false;
		public var m_coyoteTime:int = 3;
		public var m_coyoteCount:int = 0;
		public var m_jumpBuffer:int = 0;
		public var m_jumpBufferMax:int = 6;
		public var m_right:Boolean = false;
		public var m_left:Boolean = false;
		public var m_up:Boolean = false;
		public var m_down:Boolean = false;
		public var m_hitEnemy:Boolean = false;
		public var m_entityNum:int = 4;
		public var m_transformAnim:int = 0;
		public var m_state:int = 0;
		public var m_invincibleFrames:int;
		public var m_invincible:Boolean = false;
		
		public function Character() 
		{
			super();
		}
		
		override protected function init(e:Event):void 
		{
			key = new KeyObject(stage);
			super.init(e);
		}
		
		override public function update():void
		{
			if (LEVELDATA == null)
			{
				m_animation.performAll();
				return;
			}
			if (LEVELDATA.m_levelPaused) return;
			super.update();
			m_animation.performAll();
			buttonPressed();
			characterMove();
		}
		
		public function transformAnimation(e:Event):void 
		{
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
			return;
		}
		
		protected function invicibilityFrames(e:Event = null):void 
		{
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
				return;
			}
			if (key.isDown(key.LEFT)){
				m_right = false;
				m_left = true;
			}else if (key.isDown(key.RIGHT)) 
			{
				m_right = true;
				m_left = false;
			}
			else
			{
				m_right = false;
				m_left = false;
			}
			if (key.isDown(key.UP)){
				m_up = true;
				m_down = false;
			}else {
				m_up = false;
				m_down = false;
			}
		}
		
		protected function characterMove():void
		{
			return;
		}
		
		override protected function checkGround():void 
		{
			m_vy += m_gravity;
			if (y <= m_floor) 
			{
				m_coyoteCount = 0;
				return;
			}
			if (m_coyoteCount < m_coyoteTime && m_onGround)
			{
				m_coyoteCount++;
			}
			else {
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
	}

}