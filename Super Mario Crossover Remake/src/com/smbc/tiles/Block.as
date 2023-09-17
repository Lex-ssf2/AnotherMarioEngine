package com.smbc.tiles 
{
	import com.smbc.character.Character;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.smbc.bmd.*;
	/**
	 * ...
	 * @author Josned
	 */
	public class Block extends Sprite
	{
		public var m_animation:SpriteSheetAnimation;
		public var m_type:int = 0;
		public var m_PosX:int = 0;
		public var m_PosY:int = 0;
		public var m_nextType:int = 0;
		public var m_collision:Sprite;
		public var m_wasOver:Boolean;
		
		public function Block() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (m_collision == null) m_collision = new Sprite();
			m_collision.graphics.beginFill(0, 1);
			m_collision.graphics.drawRect(-(16) /2 ,-(16)/2 , 16 , 16);
			m_collision.graphics.endFill();
			addChild(m_collision);
			initListener();
			addChild(m_animation);
			this.updateObj();
		}
		
		public function removeListener():void 
		{
			m_animation.removeListener();
			m_animation = null;
			parent.removeChild(this);
		}		
		
		public function initListener():void 
		{
			if (m_animation == null) m_animation = new SpriteSheetAnimation(Main.Root.m_currentLoader.getSprites(), 16, 16, 8, 5, true, true);
			m_animation.x = -16 / 2 ;
			m_animation.y = -16 / 2 ;
			m_animation.manualAnimation = true;
		}
		
		public function PerformAll():void 
		{
			m_animation.performAll();
		}
		
		public function updateObj():void 
		{
			m_animation.manualAnimation = true;
			switch (m_type) 
			{
				case 2:
					m_animation.setCurrentFrame(1);
				break;				
				case 3:
					m_animation.setCurrentFrame(8);
				break;				
				case 4:
					m_animation.setCurrentFrame(8*4);
					m_animation.setInitFrame(8*4, (8*4) + 4);
					m_animation.updateRender(false, 6);
					m_animation.manualAnimation = false;
				break;				
				case 5:
					m_animation.setCurrentFrame(3);
				break;
				default: m_animation.setCurrentFrame(0);
			}
		}
		
		public function blockIteration():void 
		{
			m_animation.manualAnimation = true;
			switch (m_type) 
			{			
				case 4:
					m_animation.setCurrentFrame(3);
				break;				
				case 5:
					trace("Delete Block");
				break;
				default: m_animation.setCurrentFrame(3);
			}
		}
		
		/*public function hitBlock(objClass:*):uint
		{
			if (m_collision.hitTestPoint(objClass.x,objClass.y + objClass.height/2 + Math.max(objClass.getySpeed(),1)) && objClass.y + objClass.height/2 >= y - height)
			{
				objClass.y = y - height / 2 - objClass.height / 2;
				objClass.setOnGround(true);
				objClass.setFloor(y - height);
				if(!objClass.getJumping()) objClass.setySpeed(0);
				return 1;
			}
			if (m_collision.hitTestPoint(objClass.x,objClass.y - objClass.height/2) && objClass.y > y +height/2)
			{
				objClass.y = y + height/2 + objClass.height / 2;
				objClass.setySpeed(4);
				objClass.setJumping(false);
				return 2;
			}
			if (m_collision.hitTestPoint(objClass.x + objClass.width / 2, objClass.y))
			{
				objClass.x = x - width / 2 - objClass.width / 2;
				return 4;
			}
			if (m_collision.hitTestPoint(objClass.x - objClass.width / 2, objClass.y))
			{
				objClass.x = x + width / 2 + objClass.width / 2;
				return 8;
			}
			return NaN;
		}*/
		
	}

}