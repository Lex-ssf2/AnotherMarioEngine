package com.smbc.tiles 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Pipe extends Block 
	{
		public var tileSprites:Sprite;
		public var upButton:Sprite;
		public var DownButton:Sprite;
		
		public function Pipe() 
		{
			super();
			m_entityNum = 3;
		}
		
		override protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (m_collision == null) m_collision = new Sprite();
			if (tileSprites == null) tileSprites = new Sprite();			
			if (upButton == null) upButton = new Sprite();
			if (DownButton == null) DownButton = new Sprite();
			addChild(m_collision);
			initListener();
			addChild(tileSprites);
			addChild(upButton);
			addChild(DownButton);
			upButton.visible = false;
			DownButton.visible = false;
			currentPos = new Point(this.m_animation.x, this.m_animation.y);
		}
		
		override public function initListener():void 
		{
			super.initListener();
			reDrawPipe();
			upButton.graphics.beginBitmapFill(m_animation.getBMDFrame((8 * 2) - 1));
			upButton.graphics.drawRect(-8, 0, 16, 16);
			upButton.graphics.endFill();			
			DownButton.graphics.beginBitmapFill(m_animation.getBMDFrame(7));
			DownButton.graphics.drawRect(-8, 0, 16, 16);
			DownButton.graphics.endFill();
		}
		
		private function reDrawPipe():void 
		{
			m_collision.graphics.clear();
			tileSprites.graphics.clear();
			m_collision.graphics.beginFill(0, 1);
			m_collision.graphics.drawRect(0 ,0 , 16*2 , 16);
			m_collision.graphics.endFill();
			tileSprites.graphics.beginBitmapFill(m_animation.getBMDFrame((8 * 4) + 4));
			tileSprites.graphics.drawRect(0, 0, 16, 16);
			tileSprites.graphics.endFill();
			tileSprites.graphics.beginBitmapFill(m_animation.getBMDFrame((8 * 4) + 5));
			tileSprites.graphics.drawRect(16, 0, 16, 16);
			tileSprites.graphics.endFill();
			m_collision.graphics.beginFill(0xFF0000, 1);
			m_collision.graphics.drawRect(0 ,16 , 16*2 , 16*size);
			m_collision.graphics.endFill();
			tileSprites.graphics.beginBitmapFill(m_animation.getBMDFrame((8 * 4) + 6));
			tileSprites.graphics.drawRect(0, 16, 16, 16*size);
			tileSprites.graphics.endFill();			
			tileSprites.graphics.beginBitmapFill(m_animation.getBMDFrame((8 * 4) + 7));
			tileSprites.graphics.drawRect(16, 16, 16, 16*size);
			tileSprites.graphics.endFill();
			m_collision.visible = false;
			m_collision.x = -16;
			m_collision.y = -8 * (size + 1);
			tileSprites.x = m_collision.x;
			tileSprites.y = m_collision.y;
			upButton.y = -m_collision.height / 2;
			DownButton.y = m_collision.height/2 - 16;
		}
		
		override public function addEventsEditor():void 
		{
			upButton.visible = true;
			DownButton.visible = true;
			upButton.addEventListener(MouseEvent.CLICK, addSize,false,0,true);
			DownButton.addEventListener(MouseEvent.CLICK, removeSize,false,0,true);
		}		
		
		override public function killEventsEditor():void 
		{
			upButton.visible = false;
			DownButton.visible = false;
			upButton.removeEventListener(MouseEvent.CLICK, addSize);
			DownButton.removeEventListener(MouseEvent.CLICK, removeSize);
		}
		
		private function addSize(e:MouseEvent):void 
		{
			size++
			if (size >= 10)
			{
				size = 10;
			}
			reDrawPipe();
		}		
		
		private function removeSize(e:MouseEvent):void 
		{
			size--
			if (size <= 1)
			{
				size = 1;
			}
			reDrawPipe();
		}
		
	}

}