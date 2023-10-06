package com.smbc.engine 
{
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.SpriteSheetAnimation;
	import com.smbc.bmd.SpriteSheetLoader;
	import com.smbc.tiles.Block;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.smbc.controller.GameController;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class interactiveSprite extends Sprite 
	{
		public var LEVELDATA:Level;
		public var m_animation:SpriteSheetAnimation;
		public var m_currentSheet:SpriteSheetLoader;
		public var m_vx:Number = 0;
		public var m_vy:Number = 0;
		public var m_currentScale:int;
		public var m_friction:Number = 0.9;
		public var m_onGround:Boolean = false;
		public var m_overlap:Number = 0.5;
		public var m_collision:Sprite;
		public var m_floor:int;
		public var m_gravity:Number = 1.2;
		public var m_maxTime:int = 10;
		public var m_jumpTime:int = 0;
		public var m_jumpSpeed:Number = 7;
		public var m_shortHopSpeed:Number = 9;
		public var m_XSpeed:Number = 3;
		public var m_isJumping:Boolean = false;
		public var m_CollisionNum:uint;
		public var m_facingRight:Boolean = true;
		public var m_isDead:Boolean = false;
		public var m_ignoreTerrain:Boolean = false;
		public var m_type:int = 0;
		public var m_PosX:int = 0;
		public var m_PosY:int = 0;
		public var mapX:int = -1;
		public var mapY:int = -1;
		public var m_animationName:String = "idle";
		public var m_frontBlock:*;
		
		public function interactiveSprite() 
		{
			LEVELDATA = GameController.currentLevel;
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void 
		{
			m_currentScale = scaleX;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_floor = stage.stageHeight;
		}
		
		public function removeListener():void 
		{
			m_animation.removeListener();
			m_animation = null;
			m_currentSheet.deInit();
			m_currentSheet = null;
			m_collision.graphics.clear();
			m_collision = null;
			parent.removeChild(this);
		}
		
		public function update():void 
		{
			checkHitboxes();
			currentSpeed();
			checkGround();
		}
				
		protected function checkHitboxes():void 
		{
			if (LEVELDATA == null) return;
			//LEVELDATA.checkHitboxes(this);
		}
				
		protected function currentSpeed():void 
		{
			m_vx *= m_friction;
			m_vy *= m_friction;
			x += m_vx * m_currentScale;
			y += m_vy * m_currentScale;
		}
				
		protected function setPaletteSwap(original:Array=null,nColor:Array=null):void
        {
            if (original != null && nColor != null)
            {
                m_animation.replacePalette(m_animation,m_animation.getBMDFrame(m_animation.getCurrentFrame()),original,nColor,true);
            };
        }
		
		protected function changeColor():uint 
		{
			return Math.random() * 0xFFFFFFFF;
		}
		
		protected function checkGround():void 
		{
			m_vy += m_gravity;
			if (y <= m_floor) return;
			m_onGround = false;
		}
		
		public function get currentHeight():Number
		{
			return m_collision.height * m_currentScale;
		}		
		
		public function get currentWidth():Number
		{
			return m_collision.width * m_currentScale;
		}
	
		public function setxSpeed(speed:Number):void
		{
			m_vx = speed
		}		
		
		public function setySpeed(speed:Number):void
		{
			m_vy = speed
		}		
		
		public function getxSpeed():Number
		{
			return m_vx;
		}		
		
		public function getySpeed():Number
		{
			return m_vy;
		}
		
		public function setFloor(floor:Number):void 
		{
			m_floor = floor;
		}		
		
		public function setOnGround(onGround:Boolean):void 
		{
			m_onGround = onGround;
		}		
		
		public function getOnGround():Boolean 
		{
			return m_onGround;
		}
		
		public function getJumping():Boolean 
		{
			return m_isJumping;
		}
		
		public function setJumping(value:Boolean):void 
		{
			m_isJumping = value;
		}
		
		public function get collision():Sprite
		{
			return m_collision;
		}
		
		public function get CollisionNum():uint
		{
			return m_CollisionNum;
		}
		
		public function SetCollisionNum(num:uint):void
		{
			m_CollisionNum = num;
		}
		
		public function blockIteration(obj:Block):void 
		{
			setySpeed( -5);
			obj.m_gotHit = false;
			return;
		}
		
		public function hitBlock(currentBlock:*):void
		{
			if (m_ignoreTerrain) return;
			if (y + m_collision.height / 2 >= currentBlock.y - currentBlock.m_collision.height)
			{
				if (m_facingRight)
				{
					if (currentBlock.m_collision.hitTestPoint(x + m_collision.width + 1,y + m_collision.height/2 + Math.max(getySpeed(),1)))
					{
						m_frontBlock = currentBlock;
					}
				}
				else 
				{
					if (currentBlock.m_collision.hitTestPoint(x - m_collision.width - 1,y + m_collision.height/2 + Math.max(getySpeed(),1)))
					{
						m_frontBlock = currentBlock;
					}
				}
				if (currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2 + Math.max(getySpeed(),1)))
				{
					if (currentBlock is Block && currentBlock.m_gotHit) {
						blockIteration(currentBlock);
						SetCollisionNum(1);
						return;
					}
					y = currentBlock.y - currentBlock.m_collision.height / 2 - m_collision.height / 2;
					setOnGround(true);
					setFloor(currentBlock.y - currentBlock.m_collision.height/2 - m_collision.height / 2);
					if (!getJumping()) setySpeed(0);
					SetCollisionNum(1);
					return;
				}
			}
			if (currentBlock.m_collision.hitTestPoint(x,y - m_collision.height/2) && y > currentBlock.y +currentBlock.m_collision.height/2)
			{
				y = currentBlock.y + currentBlock.m_collision.height / 2 + m_collision.height / 2;
				if (getOnGround()) return;
				if (currentBlock.m_hitable && !getOnGround())
				{
					currentBlock.blockIteration(this);
				}
				setySpeed(4);
				setJumping(false);
				SetCollisionNum(2);
				return;
			}
			if (currentBlock.m_collision.hitTestPoint(x + m_collision.width / 2, y))
			{
				x = currentBlock.x - currentBlock.width / 2 - m_collision.width / 2;
				SetCollisionNum(4);
				m_frontBlock = null;
				return;
			}
			if (currentBlock.m_collision.hitTestPoint(x - m_collision.width / 2, y))
			{
				x = currentBlock.x + currentBlock.width / 2 + m_collision.width / 2;
				SetCollisionNum(8);
				m_frontBlock = null;
				return;
			}
			return;
		}
		
		public function killEventsEditor():void 
		{
			return;
		}		
		
		public function addEventsEditor():void 
		{
			return;
		}
		
	}

}