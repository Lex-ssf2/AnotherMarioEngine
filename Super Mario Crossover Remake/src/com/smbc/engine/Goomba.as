package com.smbc.engine 
{
	import com.smbc.bmd.SpriteSheetLoader;
	import com.smbc.engine.Level;
	import com.smbc.bmd.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Goomba extends interactiveSprite 
	{
		
		public function Goomba(levelData:Level) 
		{
			super(levelData);
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
			m_animation.x -= 16 / 2;
			m_animation.y -= 16 / 2;
			addChild(m_animation);
			m_XSpeed = 1;
			m_facingRight = true;
			update();
		}
		
		override public function update():void
		{
			super.update();
			state();
			m_animation.performAll();
			if (m_isDead) {
				m_vx = 0;
				return;
			}
			m_vx = m_facingRight ? m_XSpeed : -m_XSpeed;
			for (var i:int = 0; i < LEVELDATA.m_CharacterList.length; i++) 
			{
				hitObj(LEVELDATA.m_CharacterList[i])
			}
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
		
		public function hitObj(objClass:*, overlap:Number = 4):uint
		{
			if (objClass.m_isDead) return NaN;
			if ((this.hitTestPoint(objClass.x,objClass.y + objClass.height/2) || this.hitTestPoint(objClass.x + objClass.width/2,objClass.y + objClass.height/2) || this.hitTestPoint(objClass.x - objClass.width/2,objClass.y + objClass.height/2)) && objClass.y + objClass.height/2 < y) 
			{
				if (objClass.m_up) objClass.setySpeed(-15);
				else objClass.setySpeed( -5);
				m_isDead = true;
				return 1;
			}
			if (this.hitTestPoint(objClass.x + objClass.width / 2, objClass.y) || this.hitTestPoint(objClass.x - objClass.width / 2, objClass.y) || this.hitTestPoint(objClass.x, objClass.y - height / 2))
			{
				objClass.setySpeed(-15);
				objClass.m_isDead = true;
				objClass.m_ignoreTerrain = true;
				return 0;
			}
			return NaN;
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