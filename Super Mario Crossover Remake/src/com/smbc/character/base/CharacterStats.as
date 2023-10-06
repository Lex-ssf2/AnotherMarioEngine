package com.smbc.character.base 
{
	import com.smbc.bmd.Characters.Mario.*;
	import com.smbc.bmd.Characters.Luigi.*;
	import com.smbc.character.Character;
	/**
	 * ...
	 * @author Josned
	 */
	public class CharacterStats 
	{
		
		public function CharacterStats() 
		{ 
		}
		
		public static function getMario():Object
        {
			var charStats:Object = new Object();
            charStats = {
				"displayName":"Mario",
				"gravity":1.2,
				"jumpSpeed":6.5,
				"shortHopSpeed":9,
				"XSpeed":3,
				"bitmapController":MarioSkins,
				"performAll":BaseMario
			}
			return charStats;
		}		
		
		public static function getLuigi():Object
        {
			var charStats:Object = new Object();
            charStats = {
				"displayName":"Luigi",
				"gravity":1,
				"jumpSpeed":7.5,
				"shortHopSpeed":8,
				"XSpeed":2.8,
				"bitmapController":LuigiSkins,
				"performAll":BaseMario
			}
			return charStats;
		}
		
		public static function BaseMario(curObj:Character):void 
		{
			if (curObj.m_animation == null) return; 
			curObj.m_animation.setCurrentAnimation(curObj.m_animation.currentSheet[curObj.m_animationName]);
			curObj.m_facingRight = curObj.scaleX > 0 ? true : false;
			if (curObj.m_isDead) 
			{
				curObj.m_animationName = "dead";
				return;
			}
			basicWalk(curObj);
			basicJump(curObj);
		}
		
		public static function basicWalk(curObj:Character):void 
		{
			if (curObj.m_left && !curObj.m_right){
				if (curObj.m_vx > -curObj.m_XSpeed) {
					curObj.m_vx -= curObj.m_XSpeed / 6;
					if (curObj.m_onGround){
						if (curObj.m_vx > 0) {
							curObj.m_animationName = "turn";
						}
						else if(curObj.m_vx < 0 && curObj.m_vx > -1) curObj.m_isWalking = false;
					}
				}
				else curObj.m_vx = -curObj.m_XSpeed;
				curObj.scaleX = -curObj.m_currentScale;
				if (curObj.m_onGround && !curObj.m_isWalking){
					curObj.m_animationName = "walk";
					curObj.m_isWalking = true;
				}
			}else if (curObj.m_right && !curObj.m_left) 
			{
				if (curObj.m_vx < curObj.m_XSpeed){
					curObj.m_vx += curObj.m_XSpeed / 6;
					if (curObj.m_onGround)
					{
						if (curObj.m_vx < 0) {
							curObj.m_animationName = "turn";
						}
						else if(curObj.m_vx > 0 && curObj.m_vx < 1) curObj.m_isWalking = false;					
					}
				}
				else curObj.m_vx = curObj.m_XSpeed;
				curObj.scaleX = curObj.m_currentScale;
				if (curObj.m_onGround && !curObj.m_isWalking){
					curObj.m_animationName = "walk";
					curObj.m_isWalking = true;
				}
			}else 
			{
				if (curObj.m_onGround){
					curObj.m_animationName = "idle";
					if(curObj.m_vx > 0 && curObj.scaleX > 0) curObj.m_vx -= (curObj.m_XSpeed - 1)/6;
					else if (curObj.m_vx < 0 && curObj.scaleX < 0) curObj.m_vx += (curObj.m_XSpeed - 1)/6;
					else{
						curObj.m_vx = 0;
					}
					curObj.m_isWalking = false;
				}
				else {
					curObj.m_animationName = "jump";
				}
			}
		}		
		
		public static function basicJump(curObj:Character):void 
		{
			if (curObj.m_up){
				 curObj.m_jumpBuffer++
				if (curObj.m_jumpBuffer < curObj.m_jumpBufferMax && curObj.m_onGround || curObj.m_hitEnemy)
				{
					curObj.m_isJumping = true;
					curObj.m_isWalking = false;
					curObj.m_jumpTime = 0;
					curObj.m_onGround = false;
					curObj.m_hitEnemy = false;
					curObj.m_animationName = "idle";
				}
				if (curObj.m_isJumping)
				{
					if (!curObj.m_onGround) {
						curObj.m_animationName = "jump";
					}
					if (curObj.m_jumpTime < curObj.m_maxTime)
					{
						curObj.m_jumpTime++;
						curObj.m_vy = -curObj.m_jumpSpeed
					}
					else curObj.m_isJumping = false;
				}
			}
			else {
				if (curObj.m_isJumping)
				{
					curObj.m_onGround = false;
				}
				curObj.m_isJumping = false;
				if (!curObj.m_onGround) 
				{
					curObj.m_animationName = "jump";
				}
				curObj.m_jumpBuffer = 0;
			}
		}
		
	}

}