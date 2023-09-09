package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.smbc.levelEditor.Buttons.*;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class MenuEditor extends Sprite 
	{
		public var m_levelEditor:LevelEditor = new LevelEditor(Main.m_TestMap);
		public var m_addButton:MovieClip;
		public var m_EraserButton:MovieClip;
		public var m_PlayButton:MovieClip;
		private var m_levelData:Array = new Array(16);
		private var m_loadedLevel:Array = new Array;
		
		public function MenuEditor(levelData:Array) 
		{
			super();
			m_loadedLevel = levelData;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_addButton = new Terrain();
			m_EraserButton = new Eraser();
			m_PlayButton = new Play();
			addChild(m_addButton);
			m_addButton.x = 16 * 1;
			m_addButton.y = 16 * 1;
			m_addButton.scaleX = 0.5;
			m_addButton.scaleY = 0.5;
			addChild(m_EraserButton);
			m_EraserButton.x = 16 * 1;
			m_EraserButton.y = 16 * 3;
			m_EraserButton.scaleX = 0.5;
			m_EraserButton.scaleY = 0.5;
			addChild(m_PlayButton);
			m_PlayButton.x = 16 * 1;
			m_PlayButton.y = 16 * 5;
			m_PlayButton.scaleX = 0.5;
			m_PlayButton.scaleY = 0.5;
			m_addButton.addEventListener(MouseEvent.CLICK, addBlock);
			m_EraserButton.addEventListener(MouseEvent.CLICK, removeBlock);
			m_PlayButton.addEventListener(MouseEvent.CLICK, playLevel);
			m_levelEditor = new LevelEditor(m_loadedLevel);
			addChild(m_levelEditor);
			trace("Init Menu");
		}
		
		public function addBlock(e:MouseEvent):void 
		{
			if (m_levelEditor.getEditorMode() != 2) m_levelEditor.setEditorMode(2);
			else m_levelEditor.setEditorMode(0);
		}		
		
		public function removeBlock(e:MouseEvent):void 
		{
			if (m_levelEditor.getEditorMode() != 1) m_levelEditor.setEditorMode(1);
			else m_levelEditor.setEditorMode(0);
		}
		
		public function removeAllListener():void 
		{
			m_addButton.removeEventListener(MouseEvent.CLICK, addBlock);
			m_EraserButton.removeEventListener(MouseEvent.CLICK, removeBlock);
			m_PlayButton.removeEventListener(MouseEvent.CLICK, playLevel);
			m_levelEditor.removeAllListener();
			parent.removeChild(this);
		}
		
		public function playLevel(e:MouseEvent):void 
		{
			m_levelData.splice(0, m_levelData.length);
			m_levelData = new Array(16);
			for (var i:int = 0; i < 16; i++) 
			{
				m_levelData[i] = new Array(16);
				for (var j:int = 0; j < 16; j++) 
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
			Main.Root.startGame(new Level(Main.Root.m_currentLevelData, 1));
		}
	}

}