package com.smbc.tiles 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.smbc.bmd.*;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class OptimizedBlock extends Sprite 
	{
		private var m_collision:Sprite;
		private var m_BitmapData:SpriteSheetAnimation;
		private var m_pixelArt:Sprite;
		private var m_X_Tiles:int;
		private var m_Y_Tiles:int;
		private var m_Tile_Size:int;
		private var m_tile_type:int;
		
		public function OptimizedBlock(x_tiles:int = 1,y_tiles:int = 1,tileSize:int = 16,tileType:int = 0) 
		{
			super();
			m_X_Tiles = (x_tiles < 16) ? x_tiles : 16;
			m_Y_Tiles = (y_tiles < 16) ? y_tiles : 16;
			m_Tile_Size = tileSize;
			m_tile_type = tileType;
			m_collision = new Sprite();
			m_pixelArt = new Sprite();
			m_collision.graphics.beginFill(0, .5);
			m_collision.graphics.drawRect(-(m_Tile_Size * m_X_Tiles)/2 ,-(m_Tile_Size * m_Y_Tiles)/2 , m_Tile_Size * m_X_Tiles, m_Tile_Size * m_Y_Tiles);
			m_collision.graphics.endFill();
			addChild(m_collision);
			//m_collision.graphics.beginBitmapFill(TilesetSkins.getBitmap(0));
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("Added");
			m_BitmapData = new SpriteSheetAnimation(TilesetSkins.getBitmap(0), 16, 16, 8, 4,true);
			addChild(m_BitmapData);
			addChild(m_pixelArt);
			updateSize();
			//this.updateObj();
		}
		
		public function updateSize():void 
		{
			m_collision.graphics.clear();
			m_collision.graphics.beginFill(0, .5);
			m_collision.graphics.drawRect(-(m_Tile_Size * m_X_Tiles)/2 ,-(m_Tile_Size * m_Y_Tiles)/2 , m_Tile_Size * m_X_Tiles, m_Tile_Size * m_Y_Tiles);
			m_collision.graphics.endFill();			
			m_pixelArt.graphics.clear();
			m_pixelArt.graphics.beginBitmapFill(m_BitmapData.getBMDFrame(m_tile_type));
			m_pixelArt.graphics.drawRect(0,0, m_Tile_Size * m_X_Tiles, m_Tile_Size * m_Y_Tiles);
			m_pixelArt.graphics.endFill();
			m_pixelArt.x = -(m_Tile_Size * m_X_Tiles) / 2;
			m_pixelArt.y = -(m_Tile_Size * m_Y_Tiles) / 2;
		}
		
		public function hitBlock(objClass:Character, overlap:Number = 4):uint
		{
			if (m_collision.hitTestPoint(objClass.x,objClass.y + objClass.height/2) && !objClass.m_isJumping && objClass.y <= y - overlap)
			{
				objClass.y = y - height/2 - objClass.height / 2; 
				objClass.m_onGround = true;
				objClass.m_floor = y - height/2;
				objClass.setySpeed(0);
				return 1; 
			}
			if (m_collision.hitTestPoint(objClass.x,objClass.y - objClass.height/2) && objClass.y > y +height/2)
			{
				objClass.y = y + height/2 + objClass.height / 2;
				objClass.setySpeed(4);
				objClass.m_isJumping = false;
				return 2;
			}
			if (m_collision.hitTestPoint(objClass.x + objClass.width / 2, objClass.y))
			{
				objClass.x = x - width / 2 - objClass.width / 2;
				return 4;
			}
			if (m_collision.hitTestPoint(objClass.x - objClass.width / 2, objClass.y))
			{
				objClass.x = x + width / 2 + objClass.width / 2;
				return 8;
			}
			//No es por nada pero esta programado muy xd
			
			/*if ((m_collision.hitTestPoint(objClass.x - objClass.width/2 + overlap,objClass.y + objClass.height/2) || m_collision.hitTestPoint(objClass.x + objClass.width/2 - overlap,objClass.y + objClass.height/2)) && !objClass.m_isJumping && objClass.y <= y - overlap)
			{
				objClass.y = y - height/2 - objClass.height / 2; 
				objClass.m_onGround = true;
				objClass.m_floor = y - height/2;
				objClass.setySpeed(0);
				return 1; 
			}
			if ((m_collision.hitTestPoint(objClass.x - objClass.width/2 + overlap,objClass.y - objClass.height/2) || m_collision.hitTestPoint(objClass.x + objClass.width/2 - overlap,objClass.y - objClass.height/2)) && objClass.y > y +height/2)
			{
				objClass.y = y + height/2 + objClass.height / 2;
				objClass.setySpeed(4);
				objClass.m_isJumping = false;
				return 2;
			} Works better*/
			return NaN;
		}
		
		public function updateObj():void 
		{
			/*switch (m_type) 
			{
				case 2:
					m_animation.setCurrentFrame(1);
				break;				
				case 3:
					m_animation.setCurrentFrame(8);
				break;				
				case 4:
					m_animation.setCurrentFrame(22);
				break;				
				case 5:
					m_animation.setCurrentFrame(3);
				break;
				default: m_animation.setCurrentFrame(0);
			}*/
		}
		
	}

}