package 
{
	import com.smbc.tiles.Block;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import com.senocular.utils.KeyObject;
	
	public class LevelEditor extends Sprite 
	{
		public var m_grid:Sprite
		
		[Embed(source = "com/smbc/bmd/LevelEditorGrid.png")]
		private var m_gridClass:Class;
		
		private var m_gridBmD:BitmapData;
		
		private var m_addButton:Sprite = new Sprite;
		private var m_selectButton:Sprite = new Sprite;
		private var m_removeButton:Sprite = new Sprite;
		private var m_limit:int = 1;
		private var m_mode:int = 0;
		public var m_tiles:Array = new Array();
		private var tile:Block;
		private var key:KeyObject;
		public var m_valueTile:int = 0;
		public var m_isMouseDown:Boolean = false;
		private var m_loadedLevel:Array;
		public var m_tileContainer:MovieClip = new MovieClip();
		
		public function LevelEditor(loadedLevel:Array = null) 
		{
			super();
			m_grid = new Sprite;
			m_gridBmD = new m_gridClass().bitmapData;
			m_loadedLevel = loadedLevel;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_grid.graphics.beginBitmapFill(m_gridBmD);
			m_grid.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			m_grid.graphics.endFill();
			m_grid.graphics.lineStyle(1, 0);
			m_grid.graphics.moveTo(16 * 16, 0);
			m_grid.graphics.lineTo(16 * 16, stage.stageHeight);			
			m_grid.graphics.moveTo(0, 16 * 16);
			m_grid.graphics.lineTo(stage.stageHeight, 16 * 16);
			addChild(m_grid);
			addChild(m_tileContainer);
			/*m_addButton.graphics.beginFill(0, 0.5);
			m_addButton.graphics.drawRect(0, 0,16*3,16*3);
			m_addButton.graphics.endFill();
			m_addButton.x = (16 * 30);
			m_addButton.y = (16 * 2);
			m_selectButton.graphics.beginFill(0, 0.5);
			m_selectButton.graphics.drawCircle(16 * 30, 16 * 10, 16 * 3);
			m_selectButton.graphics.endFill();			
			m_removeButton.graphics.beginFill(0, 0.5);
			m_removeButton.graphics.drawCircle(16 * 30, 16 * 20, 16 * 3);
			m_removeButton.graphics.endFill();
			addChild(m_addButton);
			addChild(m_selectButton);
			addChild(m_removeButton);*/
			addEventListener(Event.ENTER_FRAME, update);
			if (m_loadedLevel != null)
			{
				trace("Hay algo");
				loadLevelData();
			}
			/*m_addButton.addEventListener(MouseEvent.CLICK, Adding);
			m_selectButton.addEventListener(MouseEvent.CLICK, Selecting);
			m_removeButton.addEventListener(MouseEvent.CLICK, Delete);*/
			key = new KeyObject(stage);
		}
		
		private function loadLevelData():void 
		{
			for each (var tiles:Block in m_tiles) 
			{
				m_tiles.splice(m_tiles.indexOf(tiles), 1);
				tiles.removeListener();
				tiles = null;
			}
			m_tiles = new Array();
			for (var i:int = 0; i < m_loadedLevel.length; i++) 
			{
				for (var j:int = 0; j < m_loadedLevel[i].length; j++) 
				{
					if (!m_loadedLevel[i] || !m_loadedLevel[i][j]) continue;
					if (m_loadedLevel[i][j] > 0)
					{
						m_tiles.push(new Block);
						m_tiles[m_tiles.length - 1].m_type = m_loadedLevel[i][j];
						m_tiles[m_tiles.length - 1].m_PosX = j
						m_tiles[m_tiles.length - 1].m_PosY = i;
						m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
						m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
						m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].width / 2;
					}
				}
			}
		}
		
		private function update(e:Event = null):void
		{
			/*if (m_mode == 0 && m_tiles[m_valueTile])
			{
				m_tiles[m_valueTile].PerformAll();
				var checkMovement:int = 0; 
				checkMovement = checkCollision();
				if (key.isDown(38))
				{
					if (checkMovement & (1 << 0)) return;
					m_tiles[m_valueTile].y -= 16;
				}
				else if(key.isDown(40))
				{
					if (checkMovement & (1 << 1)) return;
					m_tiles[m_valueTile].y += 16;
				}
				if (key.isDown(39))
				{
					if (checkMovement & (1 << 2)) return; 
					m_tiles[m_valueTile].x += 16;
				}
				else if (key.isDown(37))
				{
					if (checkMovement & (1 << 3)) return;
					m_tiles[m_valueTile].x -= 16;
				}
				updatePos(m_valueTile);
			}*/
		}
		
		public function removeAllListener():void 
		{
			removeEventListener(Event.ENTER_FRAME, update);
			for each (var tiles:Block in m_tiles) 
			{
				m_tiles.splice(m_tiles.indexOf(tiles), 1);
				tiles.removeListener();
				tiles = null;
			}
			removeChild(m_tileContainer);
			m_tileContainer = null;
			parent.removeChild(this);
		}
		
		private function checkCollision():int 
		{
			var num:int = 0;
			for (var i:int = 0; i < m_tiles.length; i++) 
			{
				if (m_valueTile == i) continue;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x , m_tiles[i].y + m_tiles[i].height)) num += 1;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x , m_tiles[i].y - m_tiles[i].height)) num += 2;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x - m_tiles[i].width, m_tiles[i].y)) num += 4;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x + m_tiles[i].width, m_tiles[i].y)) num += 8;
				if (num > Math.pow(2,4)) return num;
			}
			return num;
		}		
		
		public function updatePos(tileNum:int):void 
		{
			m_tiles[tileNum].m_PosX = Math.floor(m_tiles[tileNum].x / 16);
			m_tiles[tileNum].m_PosY = Math.floor(m_tiles[tileNum].y / 16);
			m_tiles[tileNum].x = m_grid.x + m_tiles[tileNum].m_PosX * 16 + m_tiles[tileNum].width / 2;
			m_tiles[tileNum].y = m_grid.y + m_tiles[tileNum].m_PosY * 16 + m_tiles[tileNum].height/2
			return;
		}
		
		public function returnPos(tileNum):Point 
		{
			return new Point(m_tiles[tileNum].x, m_tiles[tileNum].y);
		}
		
		public function restorePos(tileNum:int):void 
		{
			m_tiles[tileNum].x = m_grid.x + m_tiles[tileNum].m_PosX * 16 + m_tiles[tileNum].width / 2;
			m_tiles[tileNum].y = m_grid.y + m_tiles[tileNum].m_PosY * 16 + m_tiles[tileNum].height / 2;
			return;
		}
		
		public function removeTile(deletedTile:int):void 
		{
			m_tileContainer.removeChild(m_tiles[deletedTile]);
			m_tiles.splice(deletedTile, 1);
			return;
		}
		
		public function performMouse(e:MouseEvent = null):void 
		{
			if (!m_isMouseDown) return;
			var localPoint:Point = m_grid.globalToLocal(new Point(e.stageX, e.stageY));
			if (m_mode == 2)
			{
				for (var i:int = 0; i < m_tiles.length; i++) 
				{
					if (!m_tiles[i] || !m_tiles[i].hitTestPoint(e.stageX,e.stageY)) continue;
					m_tileContainer.removeChild(m_tiles[i]);
					m_tiles.splice(i, 1);
				}
				return;
			}
			if (m_mode == 1)
			{
				var clickedObjects:Array = getObjectsUnderPoint(new Point(e.stageX, e.stageY));
				if (clickedObjects.length >= 2)
				{
					//trace("Ya hay un objeto");
					return;
				}
				if (Math.floor(localPoint.x / 16) < (16 * m_limit) && Math.floor(localPoint.y / 16) < (16 * m_limit))
				{
					if (clickedObjects.length >= 2)
					{
						return;
					}
					m_tiles.push(new Block());
					m_tiles[m_tiles.length - 1].m_type = 1;
					m_tiles[m_tiles.length - 1].m_PosX = Math.floor(localPoint.x / 16);
					m_tiles[m_tiles.length - 1].m_PosY = Math.floor(localPoint.y / 16);
					m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
					m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
					m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].height/2;
					return;
				}
			}
			return;
		}
		
		private function propiedades(e:MouseEvent):void 
		{
			if (m_mode != 0 && m_mode != 2) return;
			/*var target:Block = e.currentTarget as Block;
			//var index:int = m_tiles.indexOf(e.currentTarget);
			m_valueTile = index;
			//trace("Propiedades",index);
			/*if (m_mode == 1)
			{
				target.parent.removeChild(target);
				target.removeEventListener(MouseEvent.CLICK, propiedades);
				if (index != 1) {
					m_tiles.splice(index, 1);
				}
				trace(m_tiles);
			}
			else 
			{
				
				trace(m_valueTile);
				trace("Propiedades");
			}*/
		}
		
		public function getEditorMode():int 
		{
			return m_mode;
		}		
		
		public function setEditorMode(mode:int):void 
		{
			m_mode = mode;
		}
		
		public function getTiles():Array 
		{
			return m_tiles;
		}
		
	}

}