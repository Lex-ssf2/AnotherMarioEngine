package com.smbc.engine 
{
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.SpriteSheetAnimation;
	import com.smbc.bmd.SpriteSheetLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class interactiveSprite extends Sprite 
	{
		protected var LEVELDATA:Level;
		protected var m_animation:SpriteSheetAnimation;
		protected var m_currentSheet:SpriteSheetLoader;
		protected var m_vx:Number = 0;
		protected var m_vy:Number = 0;
		protected var m_currentScale:int;
		protected var m_friction:Number = 0.9;
		protected var m_onGround:Boolean = false;
		protected var m_overlap:Number = 0.5;
		protected var m_collision:Sprite;
		protected var m_floor:int;
		protected var m_gravity:Number = 1.2;
		protected var m_maxTime:int = 10;
		protected var m_jumpTime:int = 0;
		protected var m_jumpSpeed:Number = 7;
		protected var m_shortHopSpeed:Number = 9;
		protected var m_XSpeed:Number = 3;
		protected var m_isJumping:Boolean = false;
		protected var m_CollisionNum:uint;
		protected var m_facingRight:Boolean = true;
		public var m_isDead:Boolean = false;
		public var m_ignoreTerrain:Boolean = false;
		
		public function interactiveSprite(levelData:Level) 
		{
			LEVELDATA = levelData;
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
			LEVELDATA.checkHitboxes(this);
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
		
		public function hitBlock(currentBlock:*):uint
		{
			if (m_ignoreTerrain) return NaN;
			if (currentBlock.hitTestPoint(x,y + height/2 + Math.max(getySpeed(),1)) && y + height/2 >= currentBlock.y - currentBlock.height)
			{
				y = currentBlock.y - currentBlock.height / 2 - height / 2;
				setOnGround(true);
				setFloor(currentBlock.y - currentBlock.height);
				if(!getJumping()) setySpeed(0);
				return 1;
			}
			if (currentBlock.hitTestPoint(x,y - height/2) && y > currentBlock.y +currentBlock.height/2)
			{
				y = currentBlock.y + currentBlock.height/2 + height / 2;
				setySpeed(4);
				setJumping(false);
				return 2;
			}
			if (currentBlock.hitTestPoint(x + width / 2, y))
			{
				x = currentBlock.x - currentBlock.width / 2 - width / 2;
				return 4;
			}
			if (currentBlock.hitTestPoint(x - width / 2, y))
			{
				x = currentBlock.x + currentBlock.width / 2 + width / 2;
				return 8;
			}
			return NaN;
		}
		
	}

}