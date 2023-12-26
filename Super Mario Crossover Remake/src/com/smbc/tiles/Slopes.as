package com.smbc.tiles 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import com.smbc.utils.EntityTypes;
	/**
	 * ...
	 * @author Josned
	 */
	public class Slopes extends Block 
	{
		
		public function Slopes() 
		{
			super();
			m_type = 1;
			m_entityNum = EntityTypes.Slopes;
		}
		
		override protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (m_collision == null) m_collision = new Sprite();
			m_collisionCheck[0] = 0;
			m_collisionCheck[1] = 0;
			m_collision.visible = false;
			addChild(m_collision);
			initListener();
			addChild(m_animation);
			currentPos = new Point(this.m_animation.x, this.m_animation.y);
			updateObj();
		}
		
		override public function updateObj():void 
		{
			m_animation.visible = true;
			m_animation.manualAnimation = true;
			scaleX = 1;
			if(m_type > 3)
				scaleX = -1;
			m_collision.graphics.clear();
			m_collision.graphics.beginFill(0, 1);
			m_collision.graphics.moveTo(8,-8);
			m_collision.graphics.lineTo(-8,8);
			m_collision.graphics.lineTo(8,8);
			m_collision.graphics.endFill();
			switch (m_type) 
			{
				case 1:
				case 4:
					m_animation.setCurrentFrame(8*5);
				break;
				case 2:
				case 5:
					m_animation.setCurrentFrame(8*5 + 1);
					m_collision.graphics.clear();
					m_collision.graphics.beginFill(0, 1);
					m_collision.graphics.moveTo(8,-2);
					m_collision.graphics.lineTo(-8,8);
					m_collision.graphics.lineTo(8,8);
					m_collision.graphics.endFill();
				break;				
				case 3:
				case 6:
					m_animation.setCurrentFrame(8*5 + 2);
					m_collision.graphics.clear();
					m_collision.graphics.beginFill(0, 1);
					m_collision.graphics.moveTo(8,-8);
					m_collision.graphics.lineTo(-8,-2);
					m_collision.graphics.lineTo(-8,8);
					m_collision.graphics.lineTo(8,8);
					m_collision.graphics.endFill();
				break;
				default: m_animation.setCurrentFrame(8*5);
			}
		}
	}

}