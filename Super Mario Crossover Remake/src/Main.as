package 
{
	import com.smbc.bmd.*;
	import com.smbc.bmd.SpriteSheetLoader;
	import com.smbc.engine.Level;
	import com.smbc.tiles.Block;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Main extends Sprite 
	{
		
		public var m_level:com.smbc.engine.Level = new com.smbc.engine.Level(null);
		public var m_levelEditor:MenuEditor;
		public static var m_TestMap:Array = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,0,0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3,0,0],
		[0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3,0,0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3,0,0],
		[2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3,0,0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3,0,0],
		[0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 4, 2, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3,0,0],
		[2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3,0,0],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3,0,0],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,0,0],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1,1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1,1]
		];
		public var m_currentLevelData:Array;
		private static var ROOT:Main;
		
		public var m_currentLoader:SpriteSheetLoader;
		public var m_currentLoaderMario:SpriteSheetLoader;
		
		public function Main() 
		{
			super();
			ROOT = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init,false,0,true);
		}
		
		public function init(e:Event = null):void 
		{
			m_currentLoader = new SpriteSheetLoader(TilesetSkins.getBitmap(0), 16, 16, 8, 5);
			m_currentLoaderMario = new SpriteSheetLoader(MarioSkins.getBitmap(0) , 16, 16, 8, 5);
			m_levelEditor = new MenuEditor(m_TestMap);
			addChild(m_levelEditor);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		public function startEditor(levelData:Array):void 
		{
			System.gc();
			m_levelEditor = new MenuEditor(levelData);
			addChild(m_levelEditor);
		}
		
		public function startGame(level:com.smbc.engine.Level):void 
		{
			System.gc();
			m_level = level;
			addChild(m_level);
		}
		
		public static function get Root():Main
        {
            return (ROOT);
        }
		
	}

}