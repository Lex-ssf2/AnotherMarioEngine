package com.smbc.tiles 
{
	import com.smbc.character.Character;
	import com.smbc.engine.Level;
	import com.smbc.items.Mushroom;
	import com.smbc.utils.Particles;
	import fl.transitions.TweenEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.smbc.bmd.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import com.smbc.controller.GameController;
	/**
	 * ...
	 * @author Josned
	 */
	public class Block extends Sprite
	{
		public var m_animation:SpriteSheetAnimation;
		public var m_type:int = 0;
		public var m_entityNum:int = 1;
		public var m_PosX:int = 0;
		public var m_PosY:int = 0;
		public var m_nextType:int = 0;
		public var m_collision:Sprite;
		public var m_wasOver:Boolean;
		public var m_hitable:Boolean = false;
		public var m_tweenGoesUp:Tween;
		public var m_tweenGoesDown:Tween;
		public var m_isActived:Boolean = false;
		public var m_gotHit:Boolean = false;
		public var currentPos:Point;
		private var m_frameAnimation:int = 3;
		public var size:int = 1;
		public var LEVELDATA:Level;
		public var m_particlesArray:Array;
		public var m_Item:int = 0;
		public var m_ItemSprite:Mushroom = null;
		
		public function Block()
		{
			LEVELDATA = GameController.currentLevel;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (m_collision == null) m_collision = new Sprite();
			m_collision.graphics.beginFill(0, 1);
			m_collision.graphics.drawRect(-(16) /2 ,-(16)/2 , 16 , 16);
			m_collision.graphics.endFill();
			addChild(m_collision);
			m_collision.visible = false;
			initListener();
			addChild(m_animation);
			this.updateObj();
			currentPos = new Point(this.m_animation.x, this.m_animation.y);
		}
		
		public function removeListener():void 
		{
			parent.removeChild(this);
			m_animation.removeListener();
			if(m_ItemSprite != null) m_ItemSprite.removeListener();
			m_animation = null;
			m_tweenGoesUp = null;
			m_tweenGoesDown = null;
		}
		
		public function updatePowerUp(e:Mushroom,type:int):void 
		{
			if (m_ItemSprite != null)
			{
				m_ItemSprite.removeListener();
			}
			m_ItemSprite = e;
			m_ItemSprite.m_type = type;
			addChild(m_ItemSprite);
		}
		
		public function killEventsEditor():void 
		{
			return;
		}		
		
		public function addEventsEditor():void 
		{
			return;
		}
		
		public function initListener():void 
		{
			if (m_animation == null) m_animation = new SpriteSheetAnimation(Main.Root.m_currentLoader.getSprites(), 16, 16, 8, 5,false, true, true);
			m_animation.manualAnimation = true;
		}
		
		public function PerformAll():void 
		{
			if (m_animation == null) return;
			m_animation.performAll();
		}
		
		public function updateObj():void 
		{
			m_animation.visible = true;
			m_animation.manualAnimation = true;
			switch (m_type) 
			{
				case 2:
					m_animation.setCurrentFrame(1);
					m_hitable = true;
				break;
				case 3:
					m_animation.setCurrentFrame(8);
				break;				
				case 4:
					m_animation.setCurrentFrame(8*4);
					m_animation.setInitFrame(8*4, (8*4) + 4);
					m_animation.updateRender(false, 6);
					m_animation.manualAnimation = false;
					m_hitable = true;
				break;				
				case 5:
					m_animation.setCurrentFrame(3);
				break;
				default: m_animation.setCurrentFrame(0);
			}
		}
		
		public function blockIteration(curObj:* = null):void 
		{
			m_gotHit = true;
			if (m_isActived) return;
			m_animation.manualAnimation = true;
			m_tweenGoesUp = new Tween(this.m_animation, "y", Regular.easeOut, this.currentPos.y, this.currentPos.y - 4, m_frameAnimation, false);
			m_tweenGoesUp = new Tween(this.m_animation, "scaleX", Regular.easeOut, 1, 1.2, m_frameAnimation, false);
			m_tweenGoesUp = new Tween(this.m_animation, "scaleY", Regular.easeOut, 1, 1.2, m_frameAnimation, false);
			m_tweenGoesUp.addEventListener(TweenEvent.MOTION_FINISH, goDown,false,0,true);
			m_tweenGoesUp.start();
			m_isActived = true;
			gotHit(curObj);
		}
		
		private function goDown(e:TweenEvent):void 
		{
			m_gotHit = false;
			m_tweenGoesDown = new Tween(this.m_animation, "y", Regular.easeIn, this.currentPos.y - 4, this.currentPos.y, m_frameAnimation, false);
			m_tweenGoesDown = new Tween(this.m_animation, "scaleX", Regular.easeIn, 1.2, 1, m_frameAnimation, false);
			m_tweenGoesDown = new Tween(this.m_animation, "scaleY", Regular.easeIn, 1.2, 1, m_frameAnimation, false);
			m_tweenGoesDown.addEventListener(TweenEvent.MOTION_FINISH, restoreAnim,false,0,true);
		}
		
		private function gotHit(curObj:*):void 
		{
			if (m_Item > 0)
			{
				m_animation.setCurrentFrame(3);
				LEVELDATA.addItem(this, m_Item,curObj);
				LEVELDATA.m_map[m_PosY][m_PosX][1] = 5;
				m_hitable = false;
				return;
			}
			switch (m_type) 
			{			
				case 4:
					m_animation.setCurrentFrame(3);
					LEVELDATA.addItem(this, m_Item,curObj);
					LEVELDATA.m_map[m_PosY][m_PosX][1] = 5;
					m_hitable = false;
				break;				
				case 2:
				if (curObj is Character && curObj.m_state > 0)
				{
					m_animation.visible = false;
					LEVELDATA.m_map[m_PosY][m_PosX][0] = 0;
					brokenAnimation();
				}
				break;
				default:;
			}
		}
		
		private function brokenAnimation():void 
		{
			if (m_particlesArray != null)
			{
				m_particlesArray.splice(0, m_particlesArray.length);
			}
			m_particlesArray = new Array();
			var m_particlesPos:Array = [new Point( -8, -8), new Point(0, -8), new Point( -8, 0), new Point()];
			var m_particlesYSpeed:Array = [-10,-10,-5,-5];
			for (var i:int = 0; i < 4; i++) 
			{
				m_particlesArray[i] = new Particles();
				m_particlesArray[i].graphics.beginBitmapFill(Main.Root.m_currentLoaderEffects.getSprites()[0]);
				m_particlesArray[i].graphics.drawRect(0, 0, 10,10);
				m_particlesArray[i].graphics.endFill();
				parent.addChild(m_particlesArray[i]);
				m_particlesArray[i].x = x + m_particlesPos[i].x;
				m_particlesArray[i].y = y + m_particlesPos[i].y;
				m_particlesArray[i]["particleNum"] = i;
				m_particlesArray[i]["m_YSpeed"] = m_particlesYSpeed[i];
				m_particlesArray[i]["m_gravity"] = 1.5;
				m_particlesArray[i].addEventListener(Event.ENTER_FRAME, particlesGravity,false,0,true);
			}
		}
		
		private function particlesGravity(e:Event):void 
		{
			if (m_particlesArray.indexOf(e.target) >= 0) e.target.particleNum = m_particlesArray.indexOf(e.target);
			e.target.m_YSpeed += e.target.m_gravity
			switch (e.target.particleNum) 
			{
				case 0:
				case 2:
					e.target.m_XSpeed = -3
					e.target.rotation -= 10;
				break;				
				case 1:
				case 3:
					e.target.m_XSpeed = 3
					e.target.rotation += 10;
				break;
				default:
			}
			e.target.x += e.target.m_XSpeed;
			e.target.y += e.target.m_YSpeed;
			if (e.target.y > LEVELDATA.m_vcam.y + LEVELDATA.m_vcam.height / 2)
			{
				e.target.removeEventListener(Event.ENTER_FRAME, particlesGravity);
				e.target.parent.removeChild(e.target);
			}
		}
		
		private function restoreAnim(e:TweenEvent = null):void 
		{
			if (m_tweenGoesDown != null){
				m_tweenGoesDown.stop();
				m_tweenGoesDown.removeEventListener(TweenEvent.MOTION_FINISH, restoreAnim);
			}
			if (m_tweenGoesUp != null){
				m_tweenGoesUp.stop();
				m_tweenGoesUp.removeEventListener(TweenEvent.MOTION_FINISH, goDown);
			}
			m_isActived = false;
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