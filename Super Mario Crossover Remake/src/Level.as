package 
{
	import com.smbc.tiles.Block;
	import com.smbc.utils.Vcam;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Josned
	 */
	public class Level extends Sprite
	{
		private var m_character:Character;
		private var m_blocks:Array = [];
		private var m_map:Array = [
		[4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3],
		[0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3],
		[2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3],
		[0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 4, 2, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3],
		[2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		];
		
		private var tileObjects:Array = new Array;
		private var tilePool:Array = new Array;
		public var xAxisMin:int;
		public var xAxisMax:int;
		public var m_vcam:Vcam;
		public var extraBlocks:int = 2;
		
		public function Level() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			createCharacter();
			xAxisMin = 0;
			xAxisMax = 20;
			addEventListener(Event.ENTER_FRAME, performAll);
			m_vcam = new Vcam();
			addChild(m_vcam);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		public function performAll(e:Event):void 
		{
			for (var i:int = 0; i < m_map.length; i++)
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
								block.y = i * 16 + 170;
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
						}
						else
						{
							if (m_vcam.hitTestObject(tileObjects[i][j]))
							{
								//3 is the perfect number idk why
								var collision:int = tileObjects[i][j].hitBlock(m_character,tileObjects[i][j].getRect(stage), m_character.getRect(stage),2);
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
					else
					{
						var test:*;
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
			};
			m_vcam.x = Math.max(m_vcam.width / 2, m_character.x);
			m_vcam.y = Math.min(m_vcam.height,m_character.y);
		}
		
		private function createCharacter():void 
		{
			m_character = new Character();
			m_character.scaleX = 1;
			m_character.scaleY = 1;
			m_character.x = 1 * 16;
			/*m_character.graphics.beginFill(0xFF0000);
			m_character.graphics.drawRect(0, 0, 18, 18);
			m_character.graphics.endFill();*/
			
			addChild(m_character);
		}
		
	}
	
}