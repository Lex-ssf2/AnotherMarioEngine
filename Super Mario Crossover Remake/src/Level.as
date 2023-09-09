package 
{
	import com.smbc.levelEditor.Buttons.Play;
	import com.smbc.tiles.Block;
	import com.smbc.utils.VcamMC;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Josned
	 */
	public class Level extends Sprite
	{
		private var m_character:Character;
		private var m_map:Array = new Array();
		
		private var tileObjects:Array = new Array;
		private var tilePool:Array = new Array;
		public var xAxisMin:int;
		public var xAxisMax:int;
		public var m_vcam:VcamMC;
		public var extraBlocks:int = 2;
		public var m_frameInstance:int = 0;
		public var m_gameMode:int;
		public var m_editButton:MovieClip;
		
		public var lastTime:int = getTimer();
		
		public var m_test:Character;
		
		public function Level(levelData:Array,gameMode:int = 0) 
		{
			m_map = levelData;
			m_gameMode = gameMode;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init,false,0,true);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createCharacter();
			xAxisMin = 0;
			xAxisMax = 21;
			addEventListener(Event.ENTER_FRAME, performAll,false,0,true);
			m_vcam = new VcamMC();
			m_vcam.scaleX = 0.5;
			m_vcam.scaleY = 0.5;
			addChild(m_vcam);
			addingBlocks();
			if (m_gameMode == 1)
			{
				m_editButton = new Play
				m_vcam.addChild(m_editButton);
				m_editButton.x = 50;
				m_editButton.addEventListener(MouseEvent.CLICK, goingEditorMode,false,0,true);
			}
			// entry point
		}
		
		public function removeAllListener():void 
		{
			removeEventListener(Event.ENTER_FRAME, performAll);
			m_character.removeListener();
			m_vcam.removeListener();
			m_character = null;
			m_editButton.removeEventListener(MouseEvent.CLICK, goingEditorMode);
			for (var i:int = 0; i < tileObjects.length; i++) 
			{
				if (!tileObjects[i]) continue;
				for (var j:int = 0; j < tileObjects[i].length; j++) 
				{
					if (!tileObjects[i][j]) continue;
					tileObjects[i][j].removeListener();
					tileObjects[i][j] = null;
				}
				tileObjects[i].splice(0, tileObjects[i].length);
			}
			tileObjects.splice(0, tileObjects.length);
			parent.removeChild(this);
		}
		
		private function goingEditorMode(e:MouseEvent):void 
		{
			removeAllListener();
			Main.Root.startEditor(Main.Root.m_currentLevelData);
		}
		
		private function addingBlocks():void 
		{
			for (var i:int = 0; i < m_map.length; i++)
			{
				for (var j:int = Math.max(0, xAxisMin - 1); j < xAxisMax; j++) 
				{
					if (m_map[i][j] == 0) continue;
					var block:Block;
					if (!tileObjects[i] || !tileObjects[i][j])
					{
						if (tilePool.length > 0){
							block = tilePool.pop();
							block.m_type = m_map[i][j];
							block.updateObj();
						}
						else block = new Block();
						if (m_map[i][j] >= 1)
						{
							block.x = j * 16;
							block.y = i * 16;
							block.m_type = m_map[i][j];
							addChild(block);
							if (!tileObjects[i])
							{
								tileObjects[i] = new Array;
							};
							tileObjects[i][j] = block;
						}
						else continue;
					}
					continue;
				}
			};
		}
		
		private function removeChunks(from:int,to:int):void 
		{
			for (var i:int = 0; i < m_map.length; i++)
			{
				for (var j:int = Math.max(0, from - 1); j < to; j++) 
				{
					if (m_map[i][j] == 0) continue;
					if (!tileObjects[i] || !tileObjects[i][j]) continue;
					tilePool.push(tileObjects[i][j]);
					removeChild(tileObjects[i][j]);
					tileObjects[i][j] = null;
				}
			};
		}
		
		private function removeBlocks():void 
		{
			for (var i:int = 0; i < m_map.length; i++)
			{
				if (m_map[i][xAxisMin - 2] == 0) continue;
				if (!tileObjects[i] || !tileObjects[i][xAxisMin - 2]) continue;
				tilePool.push(tileObjects[i][xAxisMin - 2]);
				removeChild(tileObjects[i][xAxisMin - 2]);
				tileObjects[i][xAxisMin - 2] = null;
			}			
			for (i = 0; i < m_map.length; i++)
			{
				if (m_map[i][xAxisMax + 1] == 0) continue;
				if (!tileObjects[i] || !tileObjects[i][xAxisMax + 1]) continue;
				tilePool.push(tileObjects[i][xAxisMax + 1]);
				removeChild(tileObjects[i][xAxisMax + 1]);
				tileObjects[i][xAxisMax + 1] = null;
			}
		}
		
		private function checkHitboxes():void 
		{
			for (var i:int = 0; i < m_map.length; i++) 
			{
				for (var j:int = Math.max(0, xAxisMin - 1); j < m_map[i].length; j++) 
				{
					if (m_map[i][j] == 0) continue;
					if (!tileObjects[i] || !tileObjects[i][j]) continue;
					if (m_map[i - 1][j] == 1 && m_map[i][j + 1] == 1 && m_map[i][j - 1] == 1 &&m_map[i][j] == 1) continue;
					if (m_map[i - 1][j] == 3 && m_map[i][j + 1] == 3 && m_map[i][j - 1] == 3 &&m_map[i][j] == 3) continue;
					var collision:int = tileObjects[i][j].hitBlock(m_character);
					var collision:int = tileObjects[i][j].hitBlock(m_test);
					tileObjects[i][j].PerformAll();
					if (tileObjects[i][j].m_type == 4)
					{
						if (collision == 2)
						{
							m_map[i][j] = 5;
							tileObjects[i][j].m_type = m_map[i][j];
							tileObjects[i][j].updateObj();
						}
					}
				}
			}
		}
		
		public function performAll(e:Event):void 
		{
			//Revisar
			m_frameInstance++;
			m_character.update();
			m_test.update();
			checkHitboxes();
			if (xAxisMax != Math.min(m_map[2].length, Math.ceil((m_vcam.x + m_vcam.width/2) / 16) + extraBlocks) && xAxisMin != Math.max(0, Math.floor((m_vcam.x - m_vcam.width / 2) / 16)))
			{
				xAxisMax = Math.min(m_map[2].length, Math.ceil((m_vcam.x + m_vcam.width/2) / 16) + extraBlocks);
				xAxisMin = Math.max(0, Math.floor((m_vcam.x - m_vcam.width / 2) / 16));
				addingBlocks();
				removeBlocks();
			}
			/*if ((Math.floor(m_vcam.x / 16) % 10 == 0 ||  Math.floor(m_vcam.x / 16) % 10 == 8) && m_updateChunks && Math.floor(m_character.x / 16) > 10 - 5)
			{
				var chunkSize:int = Math.floor(m_vcam.x / 16) / 10
				m_updateChunks = false;
				xAxisMax = 10 * (chunkSize + 2);
				xAxisMin = 10 * (chunkSize - 1);
				if (m_prevPage > Math.floor(m_vcam.x / 16) / 10)
				{
					removeChunks(10 * chunkSize, 10 * (chunkSize + 3));
				}
				else if (m_prevPage < Math.floor(m_vcam.x / 16) / 10){
					removeChunks(10 * (chunkSize - 3),10 * (chunkSize - 2));
				}
				m_prevPage = Math.floor(m_vcam.x / 16) / 10;
				addingBlocks();
			}
			else if (Math.floor(m_vcam.x / 16) % 10 != 0)
			{
				m_updateChunks = true;
			}*/
			/*for (var i:int = 0; i < m_map.length; i++)
			{
				for (var j:int = xAxisMin - 1; j < xAxisMax + 1; j++) 
				{
					if (m_map[i][j] == 0) continue;
					if ((j + extraBlocks) * 16 + 10 > m_vcam.x - m_vcam.width/2 && (j - extraBlocks) * 16 + 10 < m_vcam.x + m_vcam.width/2)
					{
						var block:Block;
						if (!tileObjects[i] || !tileObjects[i][j])
						{
							if (tilePool.length > 0){
								block = tilePool.pop();
								block.m_type = m_map[i][j];
								block.updateObj();
							}
							else block = new Block();
							if (m_map[i][j] >= 1)
							{
								block.x = j * 16;
								block.y = i * 16;
								block.m_type = m_map[i][j];
								addChild(block);
								xAxisMin = Math.max(0, Math.floor((m_vcam.x - m_vcam.width/2) / 16) - extraBlocks);
								xAxisMax = Math.min(m_map[i].length - 1, Math.ceil((m_vcam.x + m_vcam.width/2) / 16) + extraBlocks);
								if (!tileObjects[i])
								{
									tileObjects[i] = new Array;
								};
								tileObjects[i][j] = block;
							}
							else continue;
						}
						else
						{
							var collision:int = tileObjects[i][j].hitBlock(m_character);
							tileObjects[i][j].PerformAll();
							if (tileObjects[i][j].m_type == 4)
							{
								if (collision == 2)
								{
									m_map[i][j] = 5;
									tileObjects[i][j].m_type = m_map[i][j];
									tileObjects[i][j].updateObj();
								}
							}
						}
					}
					else
					{
						var test:Block;
						if (tileObjects[i] && tileObjects[i][j])
						{
							test = tileObjects[i][j];
							tilePool.push(test);
							removeChild(test);
							xAxisMin = Math.max(0, Math.floor((m_vcam.x - m_vcam.width/2) / 16) - extraBlocks);
							xAxisMax = Math.min(m_map[i].length - 1, Math.ceil((m_vcam.x + m_vcam.width/2) / 16) + extraBlocks);
							tileObjects[i][j] = null;
						}
					}
				}
			};*/
			//if(getChildIndex(m_vcam) < numChildren-1) setChildIndex(m_vcam, numChildren - 1);
			m_vcam.x = Math.max(m_vcam.width / 2, m_character.x);
			m_vcam.y = Math.min((m_map.length -1) * 16 - m_vcam.height/2,m_character.y);
		}
		
		private function createCharacter():void 
		{
			m_character = new Character();
			m_test = new Character();
			m_test.x = m_character.x + 16
			/*m_character.scaleX = 1;
			m_character.scaleY = 1;
			m_character.x = 1 * 16;
			m_character.graphics.beginFill(0xFF0000);
			m_character.graphics.drawRect(0, 0, 18, 18);
			m_character.graphics.endFill();*/
			
			addChild(m_character);
			addChild(m_test);
		}
		
	}
	
}