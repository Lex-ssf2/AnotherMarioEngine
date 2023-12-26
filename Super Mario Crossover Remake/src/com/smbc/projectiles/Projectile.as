package com.smbc.projectiles 
{
	import com.smbc.engine.interactiveSprite;
	import com.smbc.bmd.*;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Josned
	 */
	public class Projectile extends interactiveSprite 
	{
		
		public function Projectile(parameters:Object) 
		{
			super();
			LEVELDATA.addChild(this);
			x = parameters["x_start"];
			y = parameters["y_start"];
			m_facingRight = parameters["facingRight"];
			LEVELDATA.addProjectile(this);
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
			addChild(m_collision);
			addChild(m_animation);
			update();
			m_XSpeed = 4;
		}
		
		override public function update():void
		{
			super.update();
			m_animation.performAll();
			if (LEVELDATA == null) return;
			m_vx = m_facingRight ? m_XSpeed : -m_XSpeed;
			rotation = m_facingRight ? rotation + 20 : rotation - 20;
			if (m_onGround)
			{
				setySpeed( -4);
				m_onGround = false;
			}
			for (var i:int = 0; i < LEVELDATA.m_EnemiesList.length; i++) 
			{
				hitEnemy(LEVELDATA.m_EnemiesList[i]);
			}
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
		
		public function hitEnemy(objClass:*):uint
		{
			if (objClass.m_isDead || m_collision == null) return NaN;
			if (m_collision.hitTestObject(objClass.m_collision))
			{
				objClass.m_isDead = true;
				m_isDead = true;
				LEVELDATA.removeProjectile(LEVELDATA.PROJECTILES.indexOf(this));
				return 0;
			}
			return NaN;
		}
		
	}

}