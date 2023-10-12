package com.smbc.engine 
{
	import com.greensock.loading.SWFLoader;
	import com.smbc.character.Character;
	import com.smbc.controller.CharacterData;
	import com.smbc.items.Mushroom;
	import com.smbc.levelEditor.Buttons.Play;
	import com.smbc.tiles.Block;
	import com.smbc.tiles.Pipe;
	import com.smbc.utils.VcamMC;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import com.smbc.controller.GameController;
	import com.smbc.controller.CharacterStats;
	/**
	 * ...
	 * @author Josned
	 */
	public class Level extends Sprite
	{
		public var m_map:Array = new Array();
		public var m_mapEditor:Array = new Array();
		public var tileObjects:Array = new Array;
		public var gameObjects:Array = new Array;
		public var enemyObjects:Array = new Array;
		public var itemsObjects:Array = new Array;
		private var tilePool:Array = new Array;
		public var xAxisMin:int;
		public var xAxisMax:int;
		public var m_vcam:VcamMC;
		public var extraBlocks:int = 4;
		public var m_frameInstance:int = 0;
		public var m_gameMode:int = 0;
		
		public var lastTime:int = getTimer();
		public var m_CharacterList:Array = new Array();
		public var m_EnemiesList:Array = new Array();
		public var m_ItemsList:Array = new Array();
		public var m_gameObjectList:Array = new Array();
		
		public var m_enemieTest:Goomba;
		public var m_startPoint:Point;
		public var m_levelPaused:Boolean = false;
		
		public function Level(levelData:Array) 
		{
			if (levelData != null)
			{
				var myBA:ByteArray = new ByteArray();
				myBA.writeObject(levelData);
				myBA.position = 0;
				m_map = myBA.readObject();
				m_mapEditor = levelData;
			}
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init,false,0,true);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//m_startPoint = Main.Root.m_currentStartPoint;
			createCharacter();
			xAxisMin = 0;
			xAxisMax = 25;
			addEventListener(Event.ENTER_FRAME, performAll,false,0,true);
			m_vcam.scaleX = 0.5;
			m_vcam.scaleY = 0.5;
			addingBlocks();
			/*if (m_gameMode == 1)
			{
				m_editButton = new Play
				m_vcam.addChild(m_editButton);
				m_editButton.x = 100;
				m_editButton.y = -50;
			}*/
			// entry point
		}
		
		public function removeAllListener():void 
		{
			removeEventListener(Event.ENTER_FRAME, performAll);
			m_vcam.removeListener();
			for (var k:int = 0; k < m_CharacterList.length; k++) 
			{
				if (!m_CharacterList[k]) continue;
				m_CharacterList[k].removeListener();
				m_CharacterList[k] = null;
			}
			m_CharacterList.splice(0, m_CharacterList.length);
			for (k = 0; k < m_EnemiesList; k++) 
			{
				if (!m_EnemiesList[k]) continue;
				m_EnemiesList[k].removeListener();
				m_EnemiesList[k] = null;
			}
			m_EnemiesList.splice(0, m_EnemiesList.length);
			for (k = 0; k < m_ItemsList; k++) 
			{
				if (!m_ItemsList[k]) continue;
				m_ItemsList[k].removeListener();
				m_ItemsList[k] = null;
			}
			m_ItemsList.splice(0, m_ItemsList.length);
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
			for (i = 0; i < enemyObjects.length; i++) 
			{
				if (!enemyObjects[i]) continue;
				for (j = 0; j < enemyObjects[i].length; j++) 
				{
					if (!enemyObjects[i][j]) continue;
					enemyObjects[i][j] = null;
				}
				enemyObjects[i].splice(0, enemyObjects[i].length);
			}
			enemyObjects.splice(0, enemyObjects.length);
			for (i = 0; i < itemsObjects.length; i++) 
			{
				if (!itemsObjects[i]) continue;
				for (j = 0; j < itemsObjects[i].length; j++) 
				{
					if (!itemsObjects[i][j]) continue;
					itemsObjects[i][j] = null;
				}
				itemsObjects[i].splice(0, itemsObjects[i].length);
			}
			itemsObjects.splice(0, itemsObjects.length);
			parent.removeChild(this);
		}
		
		public function goingEditorMode(e:MouseEvent):void 
		{
			e.target.removeEventListener(MouseEvent.CLICK, goingEditorMode);
			e.target.parent.removeChild(e.target);
			removeAllListener();
			Main.Root.startEditor(m_mapEditor);
		}
		
		private function addingBlocks():void 
		{
			var block:Block;
			for (var i:int = 0; i < m_map.length; i++)
			{
				for (var j:int = Math.max(0, xAxisMin - 1); j < xAxisMax; j++) 
				{
					if (m_map[i][j][0] == 0) continue;
					switch (m_map[i][j][0]) 
					{
						case 2:
							if (!enemyObjects[i] || !enemyObjects[i][j])
							{
								if(!enemyObjects[i]) enemyObjects[i] = new Array;
								enemyObjects[i][j] = 0;
							};
							if (enemyObjects[i][j] < 1)
							{
								m_EnemiesList.push(new Goomba());
								m_EnemiesList[m_EnemiesList.length - 1].mapX = j;
								m_EnemiesList[m_EnemiesList.length - 1].mapY = i;
								enemyObjects[i][j] = 1;
								m_EnemiesList[m_EnemiesList.length - 1].x = j * 16;
								m_EnemiesList[m_EnemiesList.length - 1].y = i * 16;
								addChild(m_EnemiesList[m_EnemiesList.length - 1]);
							}
							continue;
						break;
						case 5:
							if (!itemsObjects[i] || !itemsObjects[i][j])
							{
								if(!itemsObjects[i]) itemsObjects[i] = new Array;
								itemsObjects[i][j] = 0;
							};
							if (itemsObjects[i][j] < 1)
							{
								m_ItemsList.push(new Mushroom());
								m_ItemsList[m_ItemsList.length - 1].mapX = j;
								m_ItemsList[m_ItemsList.length - 1].mapY = i;
								itemsObjects[i][j] = 1;
								m_ItemsList[m_ItemsList.length - 1].x = j * 16;
								m_ItemsList[m_ItemsList.length - 1].y = i * 16;
								m_ItemsList[m_ItemsList.length - 1].m_type = m_map[i][j][1];
								addChild(m_ItemsList[m_ItemsList.length - 1]);
							}
							continue;
						break;					
						case 3:
								if (!gameObjects[i] || !gameObjects[i][j])
								{
									block = new Pipe();
									block.size = m_map[i][j][2];
									block.x = j * 16 + 8;
									block.m_PosX = j;
									block.y = (i * 16) + (8 * (block.size));
									block.m_PosY = i;
									block.m_type = m_map[i][j][1];
									addChild(block);
									if (!gameObjects[i])
									{
										gameObjects[i] = new Array;
									};
									gameObjects[i][j] = block;
									m_gameObjectList.push(block);
								};
								continue;
						break;
						case 1:
							if (!tileObjects[i] || !tileObjects[i][j])
							{
								if (tilePool.length > 0){
									block = tilePool.pop();
									block.m_type = m_map[i][j][1];
									block.updateObj();
								}
								else block = new Block();
								block.x = j * 16;
								block.y = i * 16;
								block.m_type = m_map[i][j][1];
								block.m_Item = m_map[i][j][2];
								block.m_PosX = j;
								block.m_PosY = i;
								addChild(block);
								if (!tileObjects[i])
								{
									tileObjects[i] = new Array;
								};
								tileObjects[i][j] = block;
							}
							continue;
						break;
						default:
					}
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
		
		public function checkHitboxes():void 
		{
			for (var i:int = 0; i < m_map.length; i++) 
			{
				for (var j:int = Math.max(0, xAxisMin - 1); j < m_map[i].length; j++) 
				{
					if (m_map[i][j][0] == 0) continue;
					if (!tileObjects[i] || !tileObjects[i][j]) continue;
					
					if (m_map[i][j][0] == 1 && m_map[Math.max(i - 1,0)][j][0] == 1 && m_map[Math.min(i + 1,m_map.length - 1)][j][0] == 1 && m_map[i][Math.max(j - 1,0)][0] == 1 && m_map[i][Math.min(j + 1,m_map[i].length - 1)][0] == 1)
					{
						continue;
					}
					/*if (m_map[i][j][0] == 1 && m_map[Math.max(i - 1,0)][j][1] == 1 && m_map[i][Math.min(j + 1,m_map[i].length)][1] == 1 && m_map[i][Math.max(i - 1,0)][1] == 1 &&m_map[i][j][1] == 1) continue;
					if (m_map[i][j][0] == 1 && m_map[Math.max(i - 1, 0)][j][1] == 3 && m_map[i][Math.min(j + 1, m_map[i].length)][1] == 3 && m_map[i][Math.max(i - 1, 0)][1] == 3 && m_map[i][j][1] == 3) continue;*/
					for (var k:int = 0; k < m_CharacterList.length; k++) 
					{
						m_CharacterList[k].hitBlock(tileObjects[i][j]); //Revisar la utilidad de obj.SetCollisionNum
					}					
					for (k = 0; k < m_EnemiesList.length; k++) 
					{
						m_EnemiesList[k].hitBlock(tileObjects[i][j]); //Revisar la utilidad de obj.SetCollisionNum
					}					
					for (k = 0; k < m_ItemsList.length; k++) 
					{
						m_ItemsList[k].hitBlock(tileObjects[i][j]); //Revisar la utilidad de obj.SetCollisionNum
					}
					tileObjects[i][j].visible = true;
					tileObjects[i][j].PerformAll();
				}
			}
			for (i = 0; i < m_gameObjectList.length; i++) 
			{
				for (k = 0; k < m_EnemiesList.length; k++) 
				{
					m_EnemiesList[k].hitBlock(m_gameObjectList[i]);
				}
				for (k = 0; k < m_ItemsList.length; k++) 
				{
					m_ItemsList[k].hitBlock(m_gameObjectList[i]);
				}
				for (k = 0; k < m_CharacterList.length; k++) 
				{
					m_CharacterList[k].hitBlock(m_gameObjectList[i]);
				}
			}
		}
		
		public function performAll(e:Event):void 
		{
			//Revisar
			for (var i:int = 0; i < m_CharacterList.length; i++) 
			{
				m_CharacterList[i].update();
			}
			if (!m_levelPaused)
			{
				for (i = 0; i < m_EnemiesList.length; i++) 
				{
					if ((m_EnemiesList[i].x < 16 * (xAxisMin - 1) || m_EnemiesList[i].x > 16 * (xAxisMax - 1))){
						if (!m_vcam.hitTestPoint(m_EnemiesList[i].mapX * 16,m_EnemiesList[i].mapY * 16))
						{
							if(!m_EnemiesList[i].m_isDead) enemyObjects[m_EnemiesList[i].mapY][m_EnemiesList[i].mapX] = 0;
							m_EnemiesList[i].removeListener();
							m_EnemiesList.splice(i, 1);
						}
						continue;
					}
					m_EnemiesList[i].update();
				}
				for (i = 0; i < m_ItemsList.length; i++) 
				{
					if ((m_ItemsList[i].x < 16 * (xAxisMin - 1) || m_ItemsList[i].x > 16 * (xAxisMax - 1))){
						continue;
					}
					m_ItemsList[i].update();
				}			
				for (i = 0; i < m_gameObjectList.length; i++) 
				{
					if ((m_gameObjectList[i].x < 16 * (xAxisMin - 1) || m_gameObjectList[i].x > 16 * (xAxisMax - 1))){
						gameObjects[m_gameObjectList[i].m_PosY][m_gameObjectList[i].m_PosX] = null;
						m_gameObjectList[i].removeListener();
						m_gameObjectList.splice(i, 1);
					}
				}
				m_frameInstance++;
				checkHitboxes();
				if (xAxisMax != Math.min(m_map[0].length, Math.ceil((m_vcam.x + m_vcam.width/2) / 16) + extraBlocks) && xAxisMin != Math.max(0, Math.floor((m_vcam.x - m_vcam.width / 2) / 16)))
				{
					xAxisMax = Math.min(m_map[0].length, Math.ceil((m_vcam.x + m_vcam.width/2) / 16) + extraBlocks);
					xAxisMin = Math.max(0, Math.floor((m_vcam.x - m_vcam.width / 2) / 16));
					addingBlocks();
					removeBlocks();
				}
				m_vcam.x = Math.max(m_vcam.width / 2, m_CharacterList[0].x);
				m_vcam.y = Math.min((m_map.length -1) * 16 - m_vcam.height/2,m_CharacterList[0].y);
			}
			/*if (m_enemieTest.x <= 16 * (xAxisMax - 1) && m_enemieTest.x >= 16 * (xAxisMin - 1))
			{
				m_enemieTest.update();
			}*/
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
		}
		
		public function removeItem(i:int):void 
		{
			if (i < 0) return;
			m_ItemsList[i].removeListener();
			m_ItemsList.splice(i, 1);
		}
		
		public function removeEnemies(i:int):void 
		{
			if (i < 0) return;
			m_EnemiesList[i].removeListener();
			m_EnemiesList.splice(i, 1);
		}
		
		public function addItem(curObj:*,itemType:int,character:*):void 
		{
			if (itemType < 1) return;
			m_ItemsList.push(new Mushroom());
			m_ItemsList[m_ItemsList.length - 1].m_type = itemType;
			addChild(m_ItemsList[m_ItemsList.length - 1]);
			m_ItemsList[m_ItemsList.length - 1].x = curObj.x;
			m_ItemsList[m_ItemsList.length - 1].y = curObj.y - curObj.height/2;
			m_ItemsList[m_ItemsList.length - 1].m_facingRight = character.m_facingRight ? false : true;
			m_ItemsList[m_ItemsList.length - 1].m_ignoreTerrain = true;
			m_ItemsList[m_ItemsList.length - 1].setySpeed( -7);
		}
		
		private function createCharacter():void 
		{
			var i:int = 0;
            for (i = 0; i < GameController.m_playerSettings.length; i++) 
            {
                if (GameController.m_playerSettings[i].character == null) continue;
                makePlayer(i);
            };
			for (i = 0; i < m_CharacterList.length; i++) 
			{
				m_CharacterList[i].x = Main.Root.m_currentStartPoint.x + (16 * i);
				m_CharacterList[i].y = Main.Root.m_currentStartPoint.y;
			}
			for (i = 0; i < m_CharacterList.length; i++) 
			{
				addChild(m_CharacterList[i]);
			}
			/*m_character.scaleX = 1;
			m_character.scaleY = 1;
			m_character.x = 1 * 16;
			m_character.graphics.beginFill(0xFF0000);
			m_character.graphics.drawRect(0, 0, 18, 18);
			m_character.graphics.endFill();*/
		}
		
		private function makePlayer(playerNum:int):void 
		{
			var characterStats:CharacterData;
			characterStats = CharacterStats.getStats(GameController.m_playerSettings[playerNum].character);
			characterStats.importData({
			"player_id":playerNum
			});
			m_CharacterList.push(new Character(characterStats,GameController.m_playerSettings[playerNum]));
		}
		
	}
	
}