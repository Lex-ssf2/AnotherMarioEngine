package com.smbc.character 
{
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
	public dynamic class Character extends interactiveSprite 
	{
		private var key:KeyObject;
		public var m_isWalking:Boolean = false;
		public var m_pressJump:Boolean = false;
		public var m_coyoteTime:int = 6;
		public var m_coyoteCount:int = 0;
		public var m_jumpBuffer:int = 0;
		public var m_jumpBufferMax:int = 6;
		public var m_right:Boolean = false;
		public var m_left:Boolean = false;
		public var m_up:Boolean = false;
		public var m_down:Boolean = false;
		
		public function Character(levelData:Level) 
		{
			super(levelData);
		}
		
		override protected function init(e:Event):void 
		{
			key = new KeyObject(stage);
			super.init(e);
		}
		
		override public function update():void
		{
			super.update();
			m_animation.performAll();
			buttonPressed();
			characterMove();
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
		
		private function characterMove():void
		{
			if (m_isDead) 
			{
				m_animation.setCurrentFrame(17);
				return;
			}
			//Walking
			if (m_left && !m_right){
				if (m_vx > -m_XSpeed) {
					m_vx -= m_XSpeed / 6;
					if (m_onGround){
						if (m_vx > 0) {
							m_animation.setInitFrame(6, 6);
							m_animation.setCurrentFrame(6);
						}
						else if(m_vx < 0 && m_vx > -1) m_isWalking = false;
					}
				}
				else m_vx = -m_XSpeed;
				scaleX = -m_currentScale;
				if (m_onGround && !m_isWalking){
					m_animation.setInitFrame(0, 1);
					m_animation.setCurrentFrame(1);
					m_isWalking = true;
				}
			}else if (m_right && !m_left) 
			{
				if (m_vx < m_XSpeed){
					m_vx += m_XSpeed / 6;
					if (m_onGround)
					{
						if (m_vx < 0) {
							m_animation.setInitFrame(6, 6);
							m_animation.setCurrentFrame(6);
						}
						else if(m_vx > 0 && m_vx < 1) m_isWalking = false;					
					}
				}
				else m_vx = m_XSpeed;
				scaleX = m_currentScale;
				if (m_onGround && !m_isWalking){
					m_animation.setInitFrame(0, 1);
					m_animation.setCurrentFrame(1);
					m_isWalking = true;
				}
			}else 
			{
				if (m_onGround){
					m_animation.setCurrentFrame(0);
					m_animation.setInitFrame(0, 0);
					if(m_vx > 0 && scaleX > 0) m_vx -= (m_XSpeed - 1)/6;
					else if (m_vx < 0 && scaleX < 0) m_vx += (m_XSpeed - 1)/6;
					else{
						m_vx = 0;
					}
					m_isWalking = false;
				}
				else {
					m_animation.setInitFrame(2, 2);
					m_animation.setCurrentFrame(2);
				}
			}
			
			//Jump
			if (m_up){
				
				 m_jumpBuffer++
				if (m_jumpBuffer < m_jumpBufferMax && m_onGround)
				{
					m_isJumping = true;
					m_isWalking = false;
					m_jumpTime = 0;
					m_onGround = false;
					m_animation.setInitFrame(0, 0);
					m_animation.setCurrentFrame(0);
				}
				if (m_isJumping)
				{
					if (!m_onGround) m_animation.setInitFrame(2, 2);
					if (m_jumpTime < m_maxTime)
					{
						m_jumpTime++;
						m_vy = -m_jumpSpeed
					}
					else m_isJumping = false;
				}
			}
			else {
				if (m_isJumping)
				{
					m_onGround = false;
				}
				m_isJumping = false;
				if (!m_onGround) 
				{
					m_animation.setInitFrame(2, 2);
					m_animation.setCurrentFrame(2);
				}
				m_jumpBuffer = 0;
			}
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