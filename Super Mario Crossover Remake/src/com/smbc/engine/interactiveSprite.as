package com.smbc.engine 
{
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.SpriteSheetAnimation;
	import com.smbc.bmd.SpriteSheetLoader;
	import com.smbc.character.Character;
	import com.smbc.projectiles.Projectile;
	import com.smbc.tiles.*;
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
		public var m_firedProjectile:Boolean = false;
		public var m_canSlide:int = 0;
		public var m_type:int = 0;
		public var m_PosX:int = 0;
		public var m_PosY:int = 0;
		public var mapX:int = -1;
		public var mapY:int = -1;
		public var m_animationName:String = "idle";
		public var m_frontBlock:*;
		public var m_actualBlock:*;
		public var DecelRate:Number = 0;
		public var AccelRate:Number = 0;
		public var minimunXSpeed:Number = 0;
		public var maxProjectiles:int = 10;
		public var m_projectiles:Vector.<Projectile> = new Vector.<Projectile>();
		public var m_coyoteTime:int = 4;
		public var m_coyoteCount:int = 0;
		public var m_entityNum:int = 0;
		
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
			/*m_vx *= m_friction;*/
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
			if (speed < 0 && getOnGround())
				pushOutOfGround();
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
		
		public function pushOutOfGround():void
        {
            var max:int = 50;
            var i:int;
			m_onGround = false;
            while (i < max && m_actualBlock.m_collision.hitTestPoint(x,y + m_collision.height/2,true))
            {
                y--;
                i++;
            };
            if (i >= max)
            {
                y += i;
            };
			m_onGround = false;
        }
		
		public function hitBlock(currentBlock:*,overlap:int = 0):void
		{
			if (m_ignoreTerrain) {
				SetCollisionNum(0);
				return;
			}
			if (m_isJumping)
				setOnGround(false);
			var j:Number = 0;
			var i:int = 0;
			//Se pega al piso
			if (getOnGround()){
				i = y + 8;
				while (y < i && !currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2,true))
				{
					y = y + 1;
				};
				if (!currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2,true))
				{
					y = (i - 8);
				};
				while (currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2 - 1,true))
				{
					//Que subas el piso despues de estar dentro
					j = 0;
					while (currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2 ,true) && (j < 150))
					{
						y -= 1;
						j += 1;
					};
					y += j - 1;
				}
			}
			if (y + m_collision.height/2 + Math.min(m_gravity + m_jumpSpeed,m_vy) > currentBlock.y - currentBlock.m_collision.height/2)
			{
				//Encuentra el bloque de al frente
				if (currentBlock.m_collision.hitTestPoint(x + m_collision.width + 1, y + m_collision.height / 2 + Math.max(getySpeed(), 1), true) && m_facingRight 
				|| currentBlock.m_collision.hitTestPoint(x - m_collision.width - 1,y + m_collision.height/2 + Math.max(getySpeed(),1),true) && !m_facingRight)
					m_frontBlock = currentBlock;
					
				if (currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2 ,true ))
				{
					//Subir mientras estes atravesando el piso
					while (currentBlock.m_collision.hitTestPoint(x,y + m_collision.height/2,true) && !getOnGround()) 
					{
						y -= 1;
					}
					m_coyoteCount = 0;
					m_actualBlock = currentBlock;
					//Accion cuando le pegan al bloque y estas encima
					if (currentBlock is Block && currentBlock.m_gotHit) {
						blockIteration(currentBlock);
						SetCollisionNum(1);
						return;
					}
					if(!getJumping() && this is Character)
					{
						if(currentBlock is Slopes)
							this.m_canSlide = (currentBlock.m_type > 3) ? 1 : -1;
						else
							this.m_canSlide = 0;
					}
					if (getOnGround() == false && this is Character)
					{
						//Function for touching Grass
					}
					setJumping(false);
					setOnGround(true);
					if (!getJumping()) setySpeed(0);
					SetCollisionNum(1);
					return;
				}
				
			}
			if (currentBlock.m_collision.hitTestPoint(x,y - m_collision.height/2,true) && y > currentBlock.y +currentBlock.m_collision.height/2)
			{
				setySpeed(0);
				if (currentBlock.m_hitable)
				{
					currentBlock.blockIteration(this);
				}
				setySpeed(m_gravity * 1.5);
				setJumping(false);
				SetCollisionNum(2);
				return;
			}
			m_frontBlock = null;
			while ((currentBlock.m_collision.hitTestPoint(x + getxSpeed() + overlap/2, y, true) && currentBlock.m_collisionCheck[0] == 1
			|| currentBlock.m_collision.hitTestPoint(x + getxSpeed() - overlap/2, y, true) && currentBlock.m_collisionCheck[1] == 1
			|| currentBlock.m_collision.hitTestPoint(x + getxSpeed() + overlap/2, y - m_collision.height/2 + overlap, true) && currentBlock.m_collisionCheck[0] == 1
			|| currentBlock.m_collision.hitTestPoint(x + getxSpeed() - overlap/2, y - m_collision.height/2 + overlap, true) && currentBlock.m_collisionCheck[1] == 1
			) && ((getOnGround() && currentBlock.y - currentBlock.m_collision.height/2 <= y - m_collision.height/2) || !getOnGround()))
			{
				//Colision con pared;
				setxSpeed(0);
				SetCollisionNum(m_facingRight ? 4 : 8);
				while (currentBlock.m_collision.hitTestPoint(x, y, true) 
				|| currentBlock.m_collision.hitTestPoint(x, y, true))
				{
					if (currentBlock.x <= x)
						x++;
					else
						x--;
					return;
				}
			}
			SetCollisionNum(0);
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