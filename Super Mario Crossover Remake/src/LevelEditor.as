package 
{
	import com.smbc.character.Mario;
	import com.smbc.engine.Goomba;
	import com.smbc.items.Mushroom;
	import com.smbc.tiles.Block;
	import com.smbc.tiles.Pipe;
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
		private var m_blockType:int = -2;
		public var m_tiles:Array = new Array();
		private var tile:Block;
		private var key:KeyObject;
		public var m_valueTile:int = 0;
		public var m_isMouseDown:Boolean = false;
		private var m_loadedLevel:Array;
		public var m_tileContainer:MovieClip = new MovieClip();
		public var m_currentStartPoint:int = -1;
		
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
			m_grid.graphics.drawRect(0, 0, 16*16*3, 16*16);
			m_grid.graphics.endFill();
			m_grid.graphics.lineStyle(1, 0);
			m_grid.graphics.moveTo(16 * 16, 0);
			m_grid.graphics.lineTo(16 * 16, 16*16);			
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
					if (m_loadedLevel[i][j][0] == 1)
					{
						m_tiles.push(new Block);
						m_tiles[m_tiles.length - 1].m_type = m_loadedLevel[i][j][1];
						m_tiles[m_tiles.length - 1].m_Item = m_loadedLevel[i][j][2];
						m_tiles[m_tiles.length - 1].m_entityNum = m_loadedLevel[i][j][0];
						m_tiles[m_tiles.length - 1].m_PosX = j
						m_tiles[m_tiles.length - 1].m_PosY = i;
						m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
						if (m_tiles[m_tiles.length - 1].m_Item > 0)
						{
							m_tiles[m_tiles.length - 1].updatePowerUp(new Mushroom(), m_tiles[m_tiles.length - 1].m_Item);
						}
						m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
						m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].height / 2;
						continue;
					}					
					if (m_loadedLevel[i][j][0] == 2)
					{
						m_tiles.push(new Goomba());
						m_tiles[m_tiles.length - 1].m_type = m_loadedLevel[i][j][1];
						m_tiles[m_tiles.length - 1].m_entityNum = m_loadedLevel[i][j][0];
						m_tiles[m_tiles.length - 1].m_PosX = j
						m_tiles[m_tiles.length - 1].m_PosY = i;
						m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
						m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
						m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].height / 2;
						continue;
					}					
					if (m_loadedLevel[i][j][0] == 3)
					{
						m_tiles.push(new Pipe());
						m_tiles[m_tiles.length - 1].m_type = m_loadedLevel[i][j][1];
						m_tiles[m_tiles.length - 1].m_entityNum = m_loadedLevel[i][j][0];
						m_tiles[m_tiles.length - 1].size = m_loadedLevel[i][j][2];
						m_tiles[m_tiles.length - 1].m_PosX = j
						m_tiles[m_tiles.length - 1].m_PosY = i;
						m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
						m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
						m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].height / 2;
						continue;
					}
					if (m_loadedLevel[i][j][0] == 4)
					{
						m_tiles.push(new Mario(null));
						m_currentStartPoint = (m_tiles.length - 1);
						m_tiles[m_tiles.length - 1].m_type = m_loadedLevel[i][j][1];
						m_tiles[m_tiles.length - 1].m_entityNum = m_loadedLevel[i][j][0];
						m_tiles[m_tiles.length - 1].m_PosX = j
						m_tiles[m_tiles.length - 1].m_PosY = i;
						m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
						m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
						m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].height / 2;
						continue;
					}
					if (m_loadedLevel[i][j][0] == 5)
					{
						m_tiles.push(new Mushroom());
						m_tiles[m_tiles.length - 1].m_type = m_loadedLevel[i][j][1];
						m_tiles[m_tiles.length - 1].m_entityNum = m_loadedLevel[i][j][0];
						m_tiles[m_tiles.length - 1].m_PosX = j
						m_tiles[m_tiles.length - 1].m_PosY = i;
						m_tileContainer.addChild(m_tiles[m_tiles.length - 1]);
						m_tiles[m_tiles.length - 1].x = m_grid.x + m_tiles[m_tiles.length - 1].m_PosX * 16 + m_tiles[m_tiles.length - 1].width/2;
						m_tiles[m_tiles.length - 1].y = m_grid.y + m_tiles[m_tiles.length - 1].m_PosY * 16 + m_tiles[m_tiles.length - 1].height / 2;
						continue;
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
			for (var i:int = 0; i < m_tiles.length; i++) 
			{
				m_tiles[i].removeListener();
				m_tiles[i] = null;
				m_tiles.splice(i, 1);
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
			if (!m_tiles[tileNum] || m_mode != 0) return;
			m_tiles[tileNum].m_PosX = Math.floor((m_tiles[tileNum].x - m_tiles[tileNum].m_collision.width/2 + 8) / 16);
			m_tiles[tileNum].m_PosY = Math.floor((m_tiles[tileNum].y - m_tiles[tileNum].m_collision.height/2 + 8)  / 16);
			m_tiles[tileNum].x = m_grid.x + m_tiles[tileNum].m_PosX * 16 + m_tiles[tileNum].width / 2;
			m_tiles[tileNum].y = m_grid.y + m_tiles[tileNum].m_PosY * 16 + m_tiles[tileNum].height / 2;
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
					if (!m_tiles[i] || !m_tiles[i].hitTestPoint(e.stageX, e.stageY)) continue;
					if (m_tiles[i] is Mario) m_currentStartPoint = -1;
					m_tileContainer.removeChild(m_tiles[i]);
					m_tiles.splice(i, 1);
				}
				return;
			}
			if (m_mode != 0 && m_mode != 2)
			{
				var clickedObjects:Array = getObjectsUnderPoint(new Point(e.stageX, e.stageY));
				if (clickedObjects.length >= 2)
				{
					if (m_mode == 6)
					{
						for (i = 0; i < clickedObjects.length; i++) 
						{
							if (clickedObjects[i].parent.parent is Block && clickedObjects[i].parent.parent.m_hitable)
							{
								m_tiles[m_tiles.indexOf(clickedObjects[i].parent.parent)].m_Item = m_blockType;
								m_tiles[m_tiles.indexOf(clickedObjects[i].parent.parent)].updatePowerUp(new Mushroom(), m_tiles[m_tiles.indexOf(clickedObjects[i].parent.parent)].m_Item);
							}
						}
					}
					return;
				}
				if (Math.floor(localPoint.x / 16) < (16 * 3) && Math.floor(localPoint.y / 16) < (16 * m_limit) && e.stageX > 33)
				{
					if (clickedObjects.length >= 2)
					{
						return;
					}
					if (m_blockType == 0) return;
					switch (m_mode) 
					{
						case 1:
							m_tiles.push(new Block());
						break;
						case 3:
							m_tiles.push(new Goomba());
						break;						
						case 4:
							m_tiles.push(new Pipe());
							m_tiles[m_tiles.length - 1].size = Math.round(Math.random()*10);
						break;
						case 5:
						if (m_currentStartPoint < 0)
						{
							m_tiles.push(new Mario());
							m_currentStartPoint = m_tiles.length - 1;
						}
						break;
						case 6:
						m_tiles.push(new Mushroom());
						break;
						default:
					}
					var currentTile:int = m_tiles.length - 1;
					if (m_mode == 5) currentTile = m_currentStartPoint;
					m_tiles[currentTile].m_type = m_blockType;
					m_tiles[currentTile].m_PosX = Math.floor(localPoint.x / 16);
					m_tiles[currentTile].m_PosY = Math.floor(localPoint.y / 16);
					m_tileContainer.addChild(m_tiles[currentTile]);
					m_tiles[currentTile].x = m_grid.x + m_tiles[currentTile].m_PosX * 16 + m_tiles[currentTile].width/2;
					m_tiles[currentTile].y = m_grid.y + m_tiles[currentTile].m_PosY * 16 + m_tiles[currentTile].height/2;
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
		
		public function setBlockType(mode:int):void 
		{
			m_blockType = mode;
		}		
		
		public function getBlockType():int
		{
			return m_blockType;
		}
		
		public function getTiles():Array 
		{
			return m_tiles;
		}
		
	}

}