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
			m_animation = new SpriteSheetAnimation(TilesetSkins.getBitmap(0), 16, 16, 8, 4);
			m_animation.x = -16 / 2 ;
			m_animation.y = -16 / 2 ;
			addChild(m_animation);
			this.updateObj();
		}
		
		public function updateObj():void 
		{
			switch (m_type) 
			{
				case 2:
					m_animation.setInitFrame(1, 1);
				break;				
				case 3:
					m_animation.setInitFrame(8, 8);
				break;				
				case 4:
					m_animation.setInitFrame(22, 22);
				break;				
				case 5:
					m_animation.setInitFrame(3, 3);
				break;
				default: m_animation.setInitFrame(0, 0);
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
		public function hitBlock(objClass:Character,strongRect:Rectangle, weakRect:Rectangle, tolerance:uint = 2, overlap:Number = 0):uint
		{
			var overlapRect:Rectangle = strongRect.intersection(weakRect);
			if (overlapRect.width <= tolerance && overlapRect.height <= tolerance) return 0;
			if (overlapRect.width >= overlapRect.height)
			{
				if (Math.abs(weakRect.x -strongRect.x) < strongRect.width / 2)
				{
					if (weakRect.y - weakRect.height/2 < strongRect.y - strongRect.height/2)
					{
						objClass.y -= overlapRect.height - overlap; 
						objClass.m_onGround = true;
						objClass.m_floor = strongRect.y - strongRect.height/2;
						objClass.setySpeed(0);
						return 1; 
						
					} else{
						objClass.y += overlapRect.height - overlap;
						objClass.setySpeed(4);
						objClass.m_isJumping = false;
						return 2;
					}
				}
				
			} else{
				if (weakRect.x - weakRect.width/2 < strongRect.x - strongRect.width/2)
				{
					objClass.x -= overlapRect.width - overlap; 
					return 4;
				} else{
					objClass.x += overlapRect.width - overlap; 
					return 8;
				}
			}
			return NaN;
		}
		
	}

}