package 
{
	import com.smbc.bmd.*;
	import com.senocular.utils.KeyObject;
	import com.smbc.bmd.MarioSkins;
	import com.smbc.tiles.Block;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Character extends Sprite 
	{
		private var key:KeyObject;
		private var m_vx:Number = 0;
		private var m_vy:Number = 0;
		private var m_maxTime:int = 10;
		private var m_jumpTime:int = 0;
		private var m_jumpSpeed:Number = 7;
		private var m_shortHopSpeed:Number = 9;
		private var m_XSpeed:Number = 3;
		private var m_animation:SpriteSheetAnimation;
		private var m_currentSheet:SpriteSheetLoader;
		private var m_currentScale:int;
		public var m_isWalking:Boolean = false;
		public var m_gravity:Number = 1.2;
		public var m_isJumping:Boolean = false;
		public var m_pressJump:Boolean = false;
		public var m_floor:int;
		public var m_coyoteTime:int = 4;
		public var m_coyoteCount:int = 0;
		public var m_jumpBuffer:int = 0;
		public var m_jumpBufferMax:int = 6;
		public var m_collision:Sprite;
		public var m_onBlock:int = -1;
		public var m_onGround:Boolean = false;
		public var m_friction:Number = 0.9;
		public var m_overlap:Number = 0.5;
		public var copiedVector:Vector.<BitmapData>
		
		public function Character() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			m_currentSheet = new SpriteSheetLoader(MarioSkins.getBitmap(0), 16, 16, 18, 1);
			if(m_animation == null) m_animation = new SpriteSheetAnimation(m_currentSheet.getSprites(),16,16,18,1);
			m_currentScale = scaleX;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_collision = new Sprite();
			m_collision.graphics.beginFill(0xFF0000);
			m_collision.graphics.drawRect(-16/2, -16/2, 16, 16);
			m_collision.graphics.endFill();
			m_collision.visible = false;
			addChild(m_collision); //Divi DCD
			key = new KeyObject(stage);
			m_animation.x -= 16 / 2;
			m_animation.y -= 16 / 2;
			addChild(m_animation);
			m_floor = stage.stageHeight;
			setPaletteSwap([0xFF4491be, 0xFF29587c], [0, 0]);
			update();
		}
		
		public function removeListener():void 
		{
			m_animation.removeListener();
			m_animation = null;
			parent.removeChild(this);
		}
		
		public function update():void 
		{
			m_animation.performAll();
			if (key.isDown(key.LEFT)){
				if (m_vx > -m_XSpeed) {
					m_vx -= m_XSpeed / 6;
					if (m_onGround){
						if (m_vx > 0) m_animation.setInitFrame(6, 6);
						else if(m_vx < 0 && m_vx > -1) m_isWalking = false;
					}
				}
				else m_vx = -m_XSpeed;
				scaleX = -m_currentScale;
				if (m_onGround && !m_isWalking){
					m_animation.setInitFrame(0, 1);
					m_animation.setCurrentFrame(1);
					m_animation.setTiming(14);
					m_isWalking = true;
				}
			}else if (key.isDown(key.RIGHT)) 
			{
				if (m_vx < m_XSpeed){
					m_vx += m_XSpeed / 6;
					if (m_onGround)
					{
						if (m_vx < 0) m_animation.setInitFrame(6, 6);
						else if(m_vx > 0 && m_vx < 1) m_isWalking = false;					
					}
				}
				else m_vx = m_XSpeed;
				scaleX = m_currentScale;
				if (m_onGround && !m_isWalking){
					m_animation.setInitFrame(0, 1);
					m_animation.setCurrentFrame(1);
					m_animation.setTiming(14);
					m_isWalking = true;
				}
			}else 
			{
				if (m_onGround){
					m_animation.setInitFrame(0, 0);
					if(m_vx > 0 && scaleX > 0) m_vx -= (m_XSpeed - 1)/6;
					else if (m_vx < 0 && scaleX < 0) m_vx += (m_XSpeed - 1)/6;
					else{
						m_vx = 0;
					}
					m_isWalking = false;
				}
				else m_animation.setInitFrame(2, 2);
			}
			if (key.isDown(key.UP)){
				
				 m_jumpBuffer++
				if (m_jumpBuffer < m_jumpBufferMax && m_onGround)
				{
					m_isJumping = true;
					m_isWalking = false;
					m_jumpTime = 0;
					m_onGround = false;
					m_animation.setInitFrame(0, 0);
					/*if (m_animation.SheetBM.compare(MarioSkins.getBitmap(0)) == 0) m_animation.updateSheet(MarioSkins.getBitmap(1));
					else m_animation.updateSheet(MarioSkins.getBitmap(0));*/
					if (m_currentSheet.getSheet().compare(MarioSkins.getBitmap(0)) == 0)
					{
						m_currentSheet.updateSpriteSheet(MarioSkins.getBitmap(1));
						m_animation.updateSheet(m_currentSheet.getSprites());
					}
					else
					{
						m_currentSheet.updateSpriteSheet(MarioSkins.getBitmap(0));
						m_animation.updateSheet(m_currentSheet.getSprites());
					}
				}
				if (m_isJumping)
				{
					
					if (!m_onGround) m_animation.setInitFrame(2, 2);
					if (m_jumpTime < m_maxTime)
					{
						
						m_jumpTime++;
						m_vy = -m_jumpSpeed
					}
					else m_isJumping = false;
				}
			}
			else {
				if (m_isJumping)
				{
					m_isJumping = false;
					m_onGround = false;
				}
				if(!m_onGround) m_animation.setInitFrame(2, 2);
				m_jumpBuffer = 0;
			}
			//Moving
			m_vx *= m_friction;
			m_vy *= m_friction;
			x += m_vx * m_currentScale;
			y += m_vy * m_currentScale;
			
			//Check collisions with ground
			if (y + height/2 != m_floor)
			{
				m_vy += m_gravity;
				if (m_coyoteCount < m_coyoteTime && m_onGround)
				{
					m_coyoteCount++;
				}
				else {
					m_onGround = false;
					m_isWalking = false;
				}
			}else {
				m_vy += m_gravity;
				m_coyoteCount = 0;
			}
			setPaletteSwap([0xFF4491be,0xFF29587c,0xFFb23226], [0,0,changeColor()]);
		}
		
		public function setPaletteSwap(original:Array=null,nColor:Array=null):void
        {
            if (original != null && nColor != null)
            {
                m_animation.replacePalette(m_animation,m_animation.getBMDFrame(m_animation.getCurrentFrame()),original,nColor,true);
            };
        }
		
		public function get currentHeight():Number
		{
			return m_collision.height * m_currentScale;
		}		
		
		public function get currentWidth():Number
		{
			return m_collision.width * m_currentScale;
		}
		
		public function changeColor():uint 
		{
			return Math.random() * 0xFFFFFFFF;
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
	}

}