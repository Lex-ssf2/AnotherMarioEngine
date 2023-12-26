package 
{
	import com.senocular.utils.KeyObject;
	import com.smbc.engine.Level;
	import com.smbc.engine.interactiveSprite;
	import com.smbc.tiles.Block;
	import com.smbc.tiles.Pipe;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.smbc.levelEditor.Buttons.*;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.System;
	import com.smbc.controller.GameController;
	import com.smbc.utils.EntityTypes;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class MenuEditor extends Sprite 
	{
		public var m_levelEditor:LevelEditor = new LevelEditor(null);
		public var m_buttonEditorVector:Vector.<MovieClip> = new Vector.<flash.display.MovieClip>();
		public var m_buttonBlockVector:Vector.<MovieClip> = new Vector.<flash.display.MovieClip>();
		public var m_buttonEnemiesVector:Vector.<MovieClip> = new Vector.<flash.display.MovieClip>();
		public var m_buttonItemsVector:Vector.<MovieClip> = new Vector.<flash.display.MovieClip>();
		public var m_currentTabVector:Vector.<MovieClip> = new Vector.<flash.display.MovieClip>();
		private var m_levelData:Array = new Array(16);
		private var m_loadedLevel:Array = new Array();
		private var m_isDragging:Boolean = false;
		private var scroller:Sprite;
		private var m_startX:int = 16 * 2;
		private var fileRef:FileReference;
		private var m_bar:Sprite;
		
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
			m_bar = new Sprite();
			m_bar.graphics.beginFill(0XADAAA7, 1);
			m_bar.graphics.drawRect(0, 0, 32, stage.stageHeight);
			m_bar.graphics.endFill();
			addChild(m_bar);
			scroller = new Sprite;
			scroller.graphics.beginFill(0, 1);
			scroller.graphics.drawRect(0, 0, 32, 8);
			scroller.graphics.endFill();
			scroller.x = 16 * 1;
			scroller.y = 16 * 17;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_buttonEditorVector.push(new BlockButton(), new EnemiesButton(), new ItemsButton(), new Eraser(), new Play(), new Save(), new Load());
			m_buttonBlockVector.push(new Terrain() , new BPipe(), new QBlock(), new TBlock(), new BBlock(), new DiagonalOne, new DiagonalTwo, new DiagonalTres, new MDiagonalOne, new MDiagonalTwo, new MDiagonalTres);
			m_buttonEnemiesVector.push(new BGoomba(), new BStartPoint());
			m_buttonItemsVector.push(new BMushroom(), new BFireFlower());
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
		
		private function resetTab(num:int):void 
		{
			var allButtons:Array = [m_buttonBlockVector, m_buttonEnemiesVector,m_buttonItemsVector];
			for (var i:int = 0; i < m_currentTabVector.length; i++) 
			{
				removeChild(m_currentTabVector[i]);
			}
			m_currentTabVector.slice(0, m_currentTabVector.length);
			m_currentTabVector = allButtons[num].slice();
			for (i = 0; i < m_currentTabVector.length; i++) 
			{
				m_currentTabVector[i].scaleX = 0.5;
				m_currentTabVector[i].scaleY = 0.5;
				m_currentTabVector[i].x = 32 * (i + 1);
				m_currentTabVector[i].y = 16 * 19;
				addChild(m_currentTabVector[i]);
			}
		}
		
		public function clickingObj(e:MouseEvent):void 
		{
			var index:int;
			var currentBlock:*;
			m_levelEditor.m_isMouseDown = true;
			if (e.target == scroller)
			{
				m_isDragging = m_levelEditor.m_isMouseDown;
				scroller.startDrag(false, new Rectangle(16*1, 16*17, 16*17, 0));
				return;
			}
			m_levelEditor.performMouse(e);
			if(e.target.parent && (e.target.parent.parent is interactiveSprite || e.target.parent.parent is Block || e.target.parent is Block))
			{
				m_isDragging = m_levelEditor.m_isMouseDown;
				if(e.target.parent is Block)
				{
					currentBlock = e.target.parent;
				}
				else if(e.target.parent.parent is interactiveSprite || e.target.parent.parent is Block)
				{
					currentBlock = e.target.parent.parent;
				}
				if (m_levelEditor.getEditorMode() != 0) return;
				if (m_levelEditor.m_valueTile != m_levelEditor.m_tiles.indexOf(currentBlock))
				{
					m_levelEditor.getTiles()[m_levelEditor.m_valueTile].killEventsEditor();
				}
				m_levelEditor.m_valueTile = m_levelEditor.m_tiles.indexOf(currentBlock);
				m_levelEditor.getTiles()[m_levelEditor.m_valueTile].addEventsEditor();
				Sprite(currentBlock).startDrag(false, new Rectangle(16 * 1 - 8, 0, m_levelEditor.m_grid.width, m_levelEditor.m_grid.height + 8));
				return;
			};
			index = m_buttonEditorVector.indexOf(e.target as MovieClip);
			if (index >= 0) clickButton(e.target as MovieClip, index);
			index = m_currentTabVector.indexOf(e.target as MovieClip);
			if ( index < 0) return;
			clickSubButton(e.target as MovieClip, index,false);
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
			var clickedObjects:Array = new Array();
			if(m_isDragging) m_levelEditor.updatePos(m_levelEditor.m_valueTile);
			m_isDragging = false;
			if (!m_levelEditor.m_isMouseDown) return;
			if(m_levelEditor.m_tiles[m_levelEditor.m_valueTile]) clickedObjects = getObjectsUnderPoint(new Point(m_levelEditor.m_tiles[m_levelEditor.m_valueTile].x + m_levelEditor.x, m_levelEditor.m_tiles[m_levelEditor.m_valueTile].y + m_levelEditor.y));
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
			m_levelEditor.m_isMouseDown = false;
			clickSubButton(e, index);
			switch (e) 
			{
				case m_buttonEditorVector[0]:
					resetTab(0);
				break;				
				case m_buttonEditorVector[1]:
					resetTab(1);
				break;					
				case m_buttonEditorVector[2]:
					resetTab(2);
				break;					
				case m_buttonEditorVector[3]:
				break;							
				case m_buttonEditorVector[4]:
					playLevel();
				break;				
				case m_buttonEditorVector[5]:
					saveFile();
				break;				
				case m_buttonEditorVector[6]:
					loadFile();
				break;
				default:
			}
			return;
		}
		
		private function clickSubButton(e:MovieClip,index:int,outSideTab:Boolean = true):void 
		{
			var SameType:Boolean = m_levelEditor.getBlockType() == (e.m_id) && m_levelEditor.getEditorMode() == (e.m_type);
			var colorTransform:ColorTransform;
			colorTransform = (SameType) ? new ColorTransform() : new ColorTransform(0.5, 0.5, 0.5);
			MovieClip(e).transform.colorTransform = colorTransform;
			if (outSideTab)
			{
				for (var i:int = 0; i < m_buttonEditorVector.length; i++) 
				{
					if (i == index) continue;
					m_buttonEditorVector[i].transform.colorTransform = new ColorTransform();
				}
			}
			else
			{
				for (i = 0; i < m_currentTabVector.length; i++) 
				{
					if (i == index) continue;
					m_currentTabVector[i].transform.colorTransform = new ColorTransform();
				}
			}
			if (e.m_type == null) return;
			if (!SameType) 
			{
				m_levelEditor.setEditorMode(e.m_type);
				m_levelEditor.setBlockType(e.m_id);
				return
			}
			m_levelEditor.setEditorMode(0);
			m_levelEditor.setBlockType(0);
		}
		
		public function removeAllListener():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickingObj);
			stage.removeEventListener(MouseEvent.MOUSE_UP, ScrollRelease);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollMove);
			m_levelEditor.removeAllListener();
			parent.removeChild(this);
		}
		
		public function saveFile():void 
		{
			fileRef = null;
			fileRef = new FileReference();
			savingLevel();
			fileRef.save(JSON.stringify(GameController.m_currentLevelData), "myStage.map");
			System.gc();
		}
		
		public function loadFile():void 
		{
			fileRef = null
			fileRef = new FileReference();
			var fileExt:FileFilter = new FileFilter("Lvl Files (*.map)", "*.map");
			fileRef.addEventListener(Event.SELECT, onFileSelect,false,0,true);
			fileRef.browse([fileExt]);
		}
		
		private function onFileSelect(e:Event):void 
		{
			fileRef.addEventListener(Event.COMPLETE, loadedLvl,false,0,true);
			fileRef.load();
		}
		
		private function loadedLvl(e:Event):void 
		{
			m_levelData.splice(0, m_levelData.length);
			removeAllListener();
			fileRef.removeEventListener(Event.SELECT, onFileSelect);
			fileRef.removeEventListener(Event.COMPLETE, loadedLvl);
			var levelObj:Array = [].concat(JSON.parse(fileRef.data.toString()));
			System.gc();
			Main.Root.startEditor(levelObj);
		}
		
		public function playLevel():void 
		{
			savingLevel();
			removeAllListener();
			//GameController.startGame(new Level(GameController.m_currentLevelData),1);
			GameController.startCharSelection();
		}
		
		private function savingLevel():void 
		{
			m_levelData.splice(0, m_levelData.length);
			m_levelData = new Array(16);
			for (var i:int = 0; i < m_levelData.length; i++) 
			{
				m_levelData[i] = new Array(16*10);
				for (var j:int = 0; j < m_levelData[i].length; j++) 
				{
					m_levelData[i][j] = new Array();
					m_levelData[i][j][0] = 0;
				}
			}
			for (i = 0; i < m_levelEditor.getTiles().length; i++) 
			{
				if (!m_levelData[m_levelEditor.getTiles()[i].m_PosY] || !m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX] || !m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX][0])
				{
					if (!m_levelData[m_levelEditor.getTiles()[i].m_PosY])
					{
						m_levelData[m_levelEditor.getTiles()[i].m_PosY] = new Array;
					}					
					if (!m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX])
					{
						m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX] = new Array;
					}
					m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX][0] = m_levelEditor.getTiles()[i].m_entityNum;
					m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX][1] = m_levelEditor.getTiles()[i].m_type;
					switch (m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX][0]) 
					{
						case EntityTypes.DynamicBlocks:
							m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX][2] = m_levelEditor.getTiles()[i].size;
						break;
						case EntityTypes.Blocks:
							m_levelData[m_levelEditor.getTiles()[i].m_PosY][m_levelEditor.getTiles()[i].m_PosX][2] = m_levelEditor.getTiles()[i].m_Item;
						break;
						case EntityTypes.Characters:
							Main.Root.m_currentStartPoint.x = m_levelEditor.getTiles()[i].m_PosX * 16;
							Main.Root.m_currentStartPoint.y = m_levelEditor.getTiles()[i].m_PosY * 16;
						break;
						default:
					}
				}
			}
			GameController.m_currentLevelData = m_levelData;
		}
	}

}