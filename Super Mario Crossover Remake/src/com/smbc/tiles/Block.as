package com.smbc.tiles 
{
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
		public var m_nextType:int = 0;
		public var m_collision:Sprite;
		public var m_wasOver:Boolean;
		
		public function Block() 
		{
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0, 1);
			m_collision.graphics.drawRect(x -(16) /2 ,y -(16)/2 , 16 , 16 );
			m_collision.graphics.endFill();
			addChild(m_collision);
			addEventListener(Event.ADDED_TO_STAGE, init);

		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_animation = new SpriteSheetAnimation(TilesetSkins.getBitmap(0), 16, 16, 8, 5,true,false);
			m_animation.x = -16 / 2 ;
			m_animation.y = -16 / 2 ;
			m_animation.manualAnimation = true;
			addChild(m_animation);
			this.updateObj();
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
		/*if (objClass.y<y && Math.abs(objClass.x -x) < m_collision.width / 2) //&& !objClass.m_isJumping platforms later
			{
				objClass.m_onGround = true;
				objClass.m_floor = y - m_collision.height / 2;
				objClass.y = y - m_collision.height / 2 - objClass.currentHeight / 2;
				objClass.setySpeed(0);
			}	
			if (objClass.x + objClass.currentWidth / 2 > x - m_collision.width / 2 && objClass.x < x - m_collision.width / 2 + 7 && Math.abs(objClass.y -y) < m_collision.height / 2)
			{
				objClass.x = x - m_collision.width / 2 - objClass.currentWidth / 2;
			}	
			if (objClass.x - objClass.currentWidth / 2 < x + m_collision.width / 2 && objClass.x > x + m_collision.width / 2 - 7 && Math.abs(objClass.y -y) < m_collision.height / 2)
			{
				objClass.x = x + m_collision.width / 2 + objClass.currentWidth / 2;
			}		
			if (objClass.y > y+m_collision.height/2 && Math.abs(objClass.x -x) < m_collision.width / 2)
			{
				objClass.y = y + m_collision.height / 2 + objClass.currentHeight / 2;
				objClass.setySpeed(2);
			}*/
		public function hitBlock(objClass:Character, overlap:Number = 4):uint
		{
			if ((this.hitTestPoint(objClass.x + overlap,objClass.y + objClass.height/2) || this.hitTestPoint(objClass.x - overlap,objClass.y + objClass.height/2)) && !objClass.m_isJumping && objClass.y <= y - overlap)
			{
				objClass.y = y - height/2 - objClass.height / 2; 
				objClass.m_onGround = true;
				objClass.m_floor = y - height/2;
				objClass.setySpeed(0);
				return 1; 
			}
			if (this.hitTestPoint(objClass.x,objClass.y - objClass.height/2) && objClass.y > y +height/2)
			{
				objClass.y = y + height/2 + objClass.height / 2;
				objClass.setySpeed(4);
				objClass.m_isJumping = false;
				return 2;
			}
			if (this.hitTestPoint(objClass.x + objClass.width / 2, objClass.y))
			{
				objClass.x = x - width / 2 - objClass.width / 2;
				return 4;
			}
			if (this.hitTestPoint(objClass.x - objClass.width / 2, objClass.y))
			{
				objClass.x = x + width / 2 + objClass.width / 2;
				return 8;
			}
			//No es por nada pero esta programado muy xd
			return NaN;
		}
		
	}

}