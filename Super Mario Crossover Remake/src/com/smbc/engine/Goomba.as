package com.smbc.engine 
{
	import com.smbc.bmd.SpriteSheetLoader;
	import com.smbc.engine.Level;
	import com.smbc.bmd.*;
	import com.smbc.tiles.Block;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Goomba extends interactiveSprite 
	{
		public var m_entityNum:int = 2;
		public var m_deadTimer:int = 30;
		
		public function Goomba() 
		{
			super();
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
			m_currentSheet = new SpriteSheetLoader(EnemiesSkins.getBitmap(0) , 16, 16, 3, 1);
			if(m_animation == null) m_animation = new SpriteSheetAnimation(m_currentSheet.getSprites(),16,16,3,1);
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();
			m_collision.visible = false;
			addChild(m_collision); //Divi DCD
			addChild(m_animation);
			m_XSpeed = 1;
			if (LEVELDATA != null && LEVELDATA.m_CharacterList[0].x > x)
			{
				m_facingRight = true;
			}
			else 
			{
				m_facingRight = false;
			}
			update();
		}
		
		override public function update():void
		{
			super.update();
			state();
			m_animation.performAll();
			if (LEVELDATA == null) return;
			if (m_isDead) {
				m_vx = 0;
				m_deadTimer--
				if (m_deadTimer <= 0)
				{
					LEVELDATA.removeEnemies(LEVELDATA.m_EnemiesList.indexOf(this));
				}
				return;
			}
			m_vx = m_facingRight ? m_XSpeed : -m_XSpeed;
			for (var i:int = 0; i < LEVELDATA.m_CharacterList.length; i++) 
			{
				hitObj(LEVELDATA.m_CharacterList[i])
			}			
			for (i = 0; i < LEVELDATA.m_EnemiesList.length; i++) 
			{
				if (i == LEVELDATA.m_EnemiesList.indexOf(this)) continue;
				hitEnemy(LEVELDATA.m_EnemiesList[i]);
			}/*
			if (m_frontBlock != null)
			{
				if (x > m_frontBlock.x && m_facingRight)
				{
					x = m_frontBlock.x;
					m_facingRight = false;
				}
				if(x < m_frontBlock.x && !m_facingRight)
				{
					x = m_frontBlock.x;
					m_facingRight = true;
				}
			}
			Para que no se caiga
			*/
		}
		
		public function state():void 
		{
			if (m_isDead)
			{
				m_animation.setCurrentFrame(2);
				m_animation.setInitFrame(2, 2);
				return;
			}
			m_animation.setInitFrame(0, 1);
			m_animation.updateDelay(5);
		}
		
		public function hitEnemy(objClass:*, overlap:Number = 4):uint
		{
			if (objClass.m_isDead) return NaN;
			if (this.hitTestPoint(objClass.x + objClass.m_collision.width / 2, objClass.y) && !m_facingRight|| this.hitTestPoint(objClass.x - objClass.m_collision.width / 2, objClass.y) && m_facingRight || this.hitTestPoint(objClass.x, objClass.y - height / 2))
			{
				m_facingRight = m_facingRight ? false : true;
				return 0;
			}
			return NaN;
		}		
		
		public function hitObj(objClass:*, overlap:Number = 4):uint
		{
			if (objClass.m_isDead) return NaN;
			if ((this.hitTestPoint(objClass.x,objClass.y + objClass.m_collision.height/2 + objClass.getySpeed()) || this.hitTestPoint(objClass.x + objClass.width/2,objClass.y + objClass.m_collision.height/2 + objClass.getySpeed()) || this.hitTestPoint(objClass.x - objClass.width/2,objClass.y + objClass.m_collision.height/2 + objClass.getySpeed())) && objClass.y + objClass.m_collision.height/2 < y) 
			{
				if (objClass.m_up) objClass.m_hitEnemy = true;
				else objClass.setySpeed( -5);
				m_isDead = true;
				return 1;
			}
			if (this.hitTestPoint(objClass.x + objClass.m_collision.width / 2, objClass.y) || this.hitTestPoint(objClass.x - objClass.m_collision.width / 2, objClass.y) || this.hitTestPoint(objClass.x, objClass.y - height / 2))
			{
				if (objClass.m_invincible) return 0;
				objClass.gotHit();
				return 0;
			}
			return NaN;
		}
		
		override public function blockIteration(obj:Block):void 
		{
			super.blockIteration(obj);
			m_isDead = true;
			return;
		}
		
		override public function SetCollisionNum(num:uint):void
		{
			m_CollisionNum = num;
			switch (m_CollisionNum) 
			{
				case 4:
					m_facingRight = false;
				break;				
				case 8:
					m_facingRight = true;
				break;
				default:
			}
		}
		
	}

}