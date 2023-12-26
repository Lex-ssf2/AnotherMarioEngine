package com.smbc.items 
{
	import com.smbc.bmd.SpriteSheetAnimation;
	import com.smbc.bmd.SpriteSheetLoader;
	import com.smbc.engine.interactiveSprite;
	import com.smbc.engine.Level;
	import com.smbc.bmd.Items.*;
	import com.smbc.bmd.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.smbc.utils.EntityTypes;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class Mushroom extends interactiveSprite 
	{
		public var m_state:int = 1;
		
		public function Mushroom() 
		{
			m_entityNum = EntityTypes.PowerUps;
			super();
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
			m_currentSheet = new SpriteSheetLoader(ItemSkins.getBitmap(0) , 16, 16, 3, 3);
			if (m_animation == null) m_animation = new SpriteSheetAnimation(m_currentSheet.getSprites(), 16, 16, 3, 3,true);
			m_animation.currentSheet = ItemSkins.images[0];
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();
			m_collision.visible = false;
			addChild(m_collision); //Divi DCD
			addChild(m_animation);
			state();
			update();
		}
		
		override public function update():void
		{
			super.update();
			m_animation.performAll();
			if (LEVELDATA == null) return;
			if (m_vy >= 0 && m_ignoreTerrain)
			{
				m_ignoreTerrain = false;
			};
			m_vx = m_facingRight ? m_XSpeed : -m_XSpeed;
			for (var i:int = 0; i < LEVELDATA.CHARACTERS.length; i++) 
			{
				hitObj(LEVELDATA.CHARACTERS[i]);
			}
		}
		
		public function state():void 
		{
			switch (m_type) 
			{
				case 1:
				m_animation.setCurrentAnimation(m_animation.currentSheet.mushroom);
				m_XSpeed = 1.5;
				m_state = 1;
				break;				
				case 2:
				m_animation.setCurrentAnimation(m_animation.currentSheet.fireFlower);
				m_XSpeed = 0;
				m_state = 2;
				break;
				default:
			}
		}
		
		public function hitObj(objClass:*, overlap:Number = 4):uint
		{
			if (objClass.m_isDead) return NaN;
			if (m_collision == null) return NaN;
			var alreadyThatPowerUp:Boolean = false;
			if (m_collision.hitTestObject(objClass.m_collision))
			{
				LEVELDATA.removeItem(LEVELDATA.m_ItemsList.indexOf(this));
				if (m_state == objClass.m_state) return 0;
				switch (m_state) 
				{
					case 1:
						if (objClass.m_state >= 1) 
						{
							alreadyThatPowerUp = true;
							break;
						}
						objClass.transformBig();
						objClass.m_state = 1;
					break;
					case 2:
						objClass.transformBig();
						objClass.updatePalette("fire");
						objClass.m_state = 2;
					break
					default:
				}
				if (alreadyThatPowerUp) return 0;
				LEVELDATA.m_levelPaused = true;
				objClass.m_transformAnim = 0;
				objClass.addEventListener(Event.ENTER_FRAME, objClass.transformAnimation,false,0,true);
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