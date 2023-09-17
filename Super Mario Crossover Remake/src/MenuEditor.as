package 
{
	import com.senocular.utils.KeyObject;
	import com.smbc.engine.Level;
	import com.smbc.tiles.Block;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.smbc.levelEditor.Buttons.*;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class MenuEditor extends Sprite 
	{
		public var m_levelEditor:LevelEditor = new LevelEditor(null);
		public var m_buttonEditorVector:Vector.<MovieClip> = new Vector.<flash.display.MovieClip>();
		private var m_levelData:Array = new Array(16);
		private var m_loadedLevel:Array = new Array();
		private var m_isDragging:Boolean = false;
		private var scroller:Sprite;
		private var m_startX:int = 16 * 2;
		
		public function MenuEditor(levelData:Array) 
		{
			super();
			m_loadedLevel = levelData;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void 
		{
			m_levelEditor = new LevelEditor(m_loadedLevel);
			addChild(m_levelEditor);
			m_levelEditor.x = m_startX;
			scroller = new Sprite;
			scroller.graphics.beginFill(0, 1);
			scroller.graphics.drawRect(0, 0, 32, 8);
			scroller.graphics.endFill();
			scroller.x = 16 * 1;
			scroller.y = 16 * 20;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_buttonEditorVector.push(new Terrain(), new Eraser(), new Play());
			for (var i:int = 0; i < m_buttonEditorVector.length; i++) 
			{
				m_buttonEditorVector[i].scaleX = 0.5;
				m_buttonEditorVector[i].scaleY = 0.5;
				m_buttonEditorVector[i].x = 16*1;
				m_buttonEditorVector[i].y = 16 * (i + i + 1);
				addChild(m_buttonEditorVector[i]);
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clickingObj);
			stage.addEventListener(MouseEvent.MOUSE_UP, ScrollRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollMove);
			addChild(scroller);
			trace("Init Menu");
		}
		
		public function clickingObj(e:MouseEvent):void 
		{
			var index:int;
			m_isDragging = true;
			m_levelEditor.m_isMouseDown = m_isDragging;
			if (e.target == scroller)
			{
				scroller.startDrag(false, new Rectangle(16*1, 16*20, 16*20, 0));
				return;
			}
			if(e.target.parent && e.target.parent.parent is Block)
			{
				m_levelEditor.performMouse(e);
				if (m_levelEditor.getEditorMode() != 0) return;
				m_levelEditor.m_valueTile = m_levelEditor.m_tiles.indexOf(e.target.parent.parent);
				Sprite(e.target.parent.parent).startDrag(false, new Rectangle(16 * 1 - 8, 0, m_levelEditor.m_grid.width, m_levelEditor.m_grid.height + 8));
				return;
			};
			index = m_buttonEditorVector.indexOf(e.target as MovieClip);
			if (index < 0) return;
			clickButton(e.target as MovieClip, index);
			return;
			/*
			 * This is for extra things ONLY in the menu idk how to detect Level Editor objects
			 * var type:String;
			type = index < 0? "N":"B";
			if (index < 0)
			{
				trace(m_levelEditor.getTiles().indexOf(e.target as Sprite));
				index = m_levelEditor.getTiles().indexOf(e.target as Sprite);
				type = index < 0? "N":"T";
				if (index < 0)
				{
					trace("Hmm?");
					return;
				}
			}
			switch (type) 
			{
				case "B":
					clickButton(e.target as MovieClip,index);
				break;
				case "T":
					trace("Funcion");
				break;
			default:
				trace("Skull Emoji how did u got this?");
			}*/
		}
		
		private function ScrollRelease(e:MouseEvent):void 
		{
			stopDrag();
			m_isDragging = false;
			if (!m_levelEditor.m_isMouseDown) return;
			m_levelEditor.updatePos(m_levelEditor.m_valueTile);
			var clickedObjects:Array = getObjectsUnderPoint(new Point(m_levelEditor.m_tiles[m_levelEditor.m_valueTile].x + m_levelEditor.x, m_levelEditor.m_tiles[m_levelEditor.m_valueTile].y + + m_levelEditor.y));
			if (clickedObjects.length > 2)
			{
				for (var i:int = 0; i < clickedObjects.length; i++) 
				{
					if (m_levelEditor.m_tiles.indexOf(clickedObjects[i].parent) == m_levelEditor.m_valueTile || m_levelEditor.m_tiles.indexOf(clickedObjects[i].parent) < 0) continue;
					m_levelEditor.removeTile(m_levelEditor.m_tiles.indexOf(clickedObjects[i].parent))
					break;
				}
			}
			m_levelEditor.m_isMouseDown = m_isDragging;
			return;
		}		

		private function scrollMove(e:MouseEvent):void 
		{
			m_levelEditor.performMouse(e);
			if (!m_isDragging) return;
			updateEditorPos();
		}
		
		private function updateEditorPos():void 
		{
			var percentScrolled:Number = (scroller.x - 16 * 1) / scroller.width;
			var pages:int = 16 * 16;
			if (percentScrolled < 0.01)
            {
                percentScrolled = 0;
            }
            else if (percentScrolled > 0.99)
			{
				percentScrolled = 1;
			};
			m_levelEditor.x = 16*2 - (percentScrolled * pages * 1);
		}
		
		private function clickButton(e:MovieClip,index:int):void 
		{
			if (e is Play) //Play Button Event;
			{
				playLevel();
				return;
			}
			var colorTransform:ColorTransform;
			colorTransform = m_levelEditor.getEditorMode() == (index+1) ? new ColorTransform() : new ColorTransform(0.5, 0.5, 0.5);
			MovieClip(e).transform.colorTransform = colorTransform;
			for (var i:int = 0; i < m_buttonEditorVector.length; i++) 
			{
				if (i == index) continue;
				m_buttonEditorVector[i].transform.colorTransform = new ColorTransform();
			}
			if (m_levelEditor.getEditorMode() != (index+1)) 
			{
				m_levelEditor.setEditorMode(index + 1);
				return
			}
			m_levelEditor.setEditorMode(0);
		}
		
		public function removeAllListener():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickingObj);
			stage.removeEventListener(MouseEvent.MOUSE_UP, ScrollRelease);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollMove);
			m_levelEditor.removeAllListener();
			parent.removeChild(this);
		}
		
		public function playLevel():void 
		{
			m_levelData.splice(0, m_levelData.length);
			m_levelData = new Array(16);
			for (var i:int = 0; i < m_levelData.length; i++) 
			{
				m_levelData[i] = new Array(16*10);
				for (var j:int = 0; j < m_levelData[i].length; j++) 
				{
					m_levelData[i][j] = 0;
				}
			}
			for (i = 0; i < m_levelEditor.getTiles().length; i++) 
			{
				if (!m_levelData[m_levelEditor.getTiles()[i].m_PosY] || !m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX])
				{
					if (!m_levelData[m_levelEditor.getTiles()[i].m_PosY])
					{
						m_levelData[m_levelEditor.getTiles()[i].m_PosY] = new Array;
					}
					m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX] = m_levelEditor.getTiles()[i].m_type;
				}
			}
			Main.Root.m_currentLevelData = m_levelData;
			removeAllListener();
			Main.Root.startGame(new com.smbc.engine.Level(Main.Root.m_currentLevelData, 1));
		}
	}

}