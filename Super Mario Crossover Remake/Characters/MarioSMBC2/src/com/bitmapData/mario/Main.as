package com.bitmapData.mario
{
	import flash.display.Sprite;

    public dynamic class Main extends Sprite 
    {

        public function Main()
        {
        }

		public function getCharacter():Object
        {
			var charStats:Object = new Object();
            charStats = {
				"displayName":"Mario",
				"statsName":"mario",
				"gravity":1.2,
				"jumpSpeed":6.5,
				"shortHopSpeed":9,
				"XSpeed":3,
				"decel_rate":0.3,
				"accel_rate":0.5,
				"minimum_x_speed":0.5,
				"bitmapController":MarioSkins,
				"performAll":BaseMario
			}
			return charStats;
		}
		
		public function BaseMario(curObj:*):void
        {
            if (curObj.m_animation == null)
            {
                return;
            };
            curObj.m_animation.setCurrentAnimation(curObj.m_animation.currentSheet[curObj.m_animationName]);
            curObj.m_facingRight = ((curObj.scaleX > 0) ? true : false);
            if (curObj.m_isDead)
            {
                curObj.m_animationName = "dead";
                return;
            };
            basicWalk(curObj);
            basicJump(curObj);
        }

        public function basicWalk(curObj:*):void
        {
			curObj.m_isWalking = curObj.m_animationName == "walk" ? true : false;
            if (((curObj.m_left) && (!(curObj.m_right))))
            {
				curObj.m_vx = curObj.m_vx - (curObj.m_vx > -curObj.m_XSpeed ? curObj.AccelRate : 0) 
				curObj.m_vx = curObj.m_vx < -curObj.m_XSpeed ? -curObj.m_XSpeed : curObj.m_vx;
				if (curObj.m_onGround)
				{
					curObj.m_animationName = curObj.m_vx > 0 ? "turn" : "walk";
				};
				curObj.scaleX = -(curObj.m_currentScale)
				return;
            }
            if (((curObj.m_right) && (!(curObj.m_left))))
            {
				curObj.m_vx = curObj.m_vx + (curObj.m_vx < curObj.m_XSpeed ? curObj.AccelRate : 0)
				curObj.m_vx = curObj.m_vx > curObj.m_XSpeed ? curObj.m_XSpeed : curObj.m_vx;
				if (curObj.m_onGround)
				{
					curObj.m_animationName = curObj.m_vx < 0 ? "turn" : "walk";
				};
				curObj.scaleX = curObj.m_currentScale
				return;
            }
			if (curObj.m_onGround)
			{
				curObj.m_animationName = "idle";
				curObj.m_vx = ((curObj.m_vx > 0) ? (curObj.m_vx - Math.abs((curObj.m_vx * curObj.DecelRate))) : (curObj.m_vx + Math.abs((curObj.m_vx * curObj.DecelRate))));
				curObj.m_vx = Math.abs(curObj.m_vx) < curObj.minimunXSpeed ? 0 : curObj.m_vx;
				curObj.m_isWalking = false;
				return;
			}
			else
			{
				curObj.m_animationName = "jump";
				return;
			};
			/*if ((curObj.m_vx > -(curObj.m_XSpeed)))
			{
				curObj.m_vx = (curObj.m_vx - (curObj.m_XSpeed / 6));
				if (curObj.m_onGround)
				{
					if ((curObj.m_vx > 0))
					{
						curObj.m_animationName = "turn";
					}
					else
					{
						if (((curObj.m_vx < 0) && (curObj.m_vx > -1)))
						{
							curObj.m_isWalking = false;
						};
					};
				};
			}
			else
			{
				curObj.m_vx = -(curObj.m_XSpeed);
			};
			curObj.scaleX = -(curObj.m_currentScale);
			if (((curObj.m_onGround) && (!(curObj.m_isWalking))))
			{
				curObj.m_animationName = "walk";
				curObj.m_isWalking = true;
			};*/
        }

        public function basicJump(curObj:*):void
        {
			if (!curObj.m_up)
			{
                curObj.m_isJumping = false;
				curObj.m_animationName = !curObj.m_onGround ? "jump" : curObj.m_animationName;
                curObj.m_jumpBuffer = 0;
				return;
			}
			curObj.m_jumpBuffer++;
			if ((curObj.m_jumpBuffer < curObj.m_jumpBufferMax && curObj.m_onGround) || curObj.m_hitEnemy)
			{
				curObj.m_isJumping = true;
				curObj.m_isWalking = false;
				curObj.m_jumpTime = 0;
				curObj.m_onGround = false;
				curObj.m_hitEnemy = false;
				curObj.m_animationName = "idle";
			};
			if (!curObj.m_isJumping) return;
			curObj.m_animationName = "jump"
			if (curObj.m_jumpTime > curObj.m_maxTime)
			{
				curObj.m_isJumping = false;
				return;
			}
			curObj.m_jumpTime++;
			curObj.m_vy = -(curObj.m_jumpSpeed);
        }

    }
}