package 
{
	import com.smbc.tiles.OptimizedBlock;
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
		private var m_grid:Sprite
		
		[Embed(source = "com/smbc/bmd/LevelEditorGrid.png")]
		private var m_gridClass:Class;
		
		private var m_gridBmD:BitmapData;
		
		private var m_addButton:Sprite = new Sprite;
		private var m_selectButton:Sprite = new Sprite;
		private var m_removeButton:Sprite = new Sprite;
		private var m_limit:int = 1;
		private var m_mode:int = 0;
		private var m_tiles:Array = new Array;
		private var key:KeyObject;
		private var m_valueTile:int = 0;
		private var m_isMouseDown:Boolean = false;
		
		public function LevelEditor() 
		{
			super();
			m_grid = new Sprite;
			m_gridBmD = new m_gridClass().bitmapData;
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
			m_addButton.graphics.beginFill(0, 0.5);
			m_addButton.graphics.drawRect(16 * 30, 16*2,16*3,16*3);
			m_addButton.graphics.endFill();
			m_selectButton.graphics.beginFill(0, 0.5);
			m_selectButton.graphics.drawCircle(16 * 30, 16 * 10, 16 * 3);
			m_selectButton.graphics.endFill();			
			m_removeButton.graphics.beginFill(0, 0.5);
			m_removeButton.graphics.drawCircle(16 * 30, 16 * 20, 16 * 3);
			m_removeButton.graphics.endFill();
			addChild(m_addButton);
			addChild(m_selectButton);
			addChild(m_removeButton);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseIsDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseIsUp);
			addEventListener(MouseEvent.MOUSE_MOVE, performMouse);
			m_addButton.addEventListener(MouseEvent.CLICK, Adding);
			m_selectButton.addEventListener(MouseEvent.CLICK, Selecting);
			m_removeButton.addEventListener(MouseEvent.CLICK, Delete);
			key = new KeyObject(stage);
		}
		
		private function update(e:Event = null):void
		{
			if (m_mode == 0 && m_tiles[m_valueTile])
			{
				var checkMovement:int = checkCollision();
				if (key.isDown(38) && checkMovement != 1)
				{
					m_tiles[m_valueTile].y -= 16;
				}
				else if(key.isDown(40) && checkMovement != 2)
				{
					m_tiles[m_valueTile].y += 16;
				}
				if (key.isDown(39) && checkMovement != 3)
				{
					m_tiles[m_valueTile].x += 16;
				}
				else if (key.isDown(37) && checkMovement != 4)
				{
					m_tiles[m_valueTile].x -= 16;
				}
			}
		}
		
		private function checkCollision():int 
		{
			for (var i:int = 0; i < m_tiles.length; i++) 
			{
				if (m_valueTile == i) continue;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x , m_tiles[i].y + m_tiles[i].height)) return 1;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x , m_tiles[i].y - m_tiles[i].height)) return 2;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x - m_tiles[i].width, m_tiles[i].y)) return 3;
				if (m_tiles[m_valueTile].hitTestPoint(m_tiles[i].x + m_tiles[i].width,m_tiles[i].y)) return 4;
			}
			return NaN
		}
		
		private function performMouse(e:MouseEvent = null):void 
		{
			if (!m_isMouseDown) return;
			var clickedSprite:Sprite = null;
			if (m_mode == 1)
			{
				for (var i:int = 0; i < m_tiles.length; i++) 
				{
					if (!m_tiles[i] || !m_tiles[i].hitTestPoint(e.stageX,e.stageY)) continue;
					removeChild(m_tiles[i]);
					m_tiles[i].removeEventListener(MouseEvent.CLICK, propiedades);
					m_tiles.splice(i, 1);
				}
			}
			if (m_mode == 2)
			{
				var clickedObjects:Array = stage.getObjectsUnderPoint(new Point(e.stageX, e.stageY));
				if (clickedObjects.length >= 2)
				{
					trace("Ya hay un objeto");
					return;
				}
				if (Math.floor(e.stageX / 16) < (16 * m_limit) && Math.floor(e.stageY / 16) < (16 * m_limit))
				{
					var tile:OptimizedBlock = new OptimizedBlock;
					tile.x = Math.floor(e.stageX / 16) * 16 + tile.width/2;
					tile.y = Math.floor(e.stageY / 16) * 16 + tile.width/2;
					addChild(tile);
					tile.addEventListener(MouseEvent.CLICK, propiedades);
					m_tiles.push(tile);
					return;
				}
			}
			return;
		}		
		
		private function mouseIsDown(e:MouseEvent):void 
		{
			m_isMouseDown = true;
			performMouse(e);
			return;
		}		
		
		private function mouseIsUp(e:MouseEvent):void 
		{
			m_isMouseDown = false;
			return;
		}
		
		private function propiedades(e:MouseEvent):void 
		{
			if (m_mode != 0 && m_mode != 1) return;
			var target:OptimizedBlock = e.currentTarget as OptimizedBlock;
			var index:int = m_tiles.indexOf(target);
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
				m_valueTile = index;
				trace(m_valueTile);
				trace("Propiedades");
			}*/
		}
		
		private function Adding(e:MouseEvent):void 
		{
			m_mode = 2;
			trace("Añadiendo");
		}		
		
		private function Selecting(e:MouseEvent):void 
		{
			m_mode = 0;
			trace("Seleccionando");
		}		
		
		private function Delete(e:MouseEvent):void 
		{
			m_mode = 1;
			trace("Eliminar");
		}
		
	}

}