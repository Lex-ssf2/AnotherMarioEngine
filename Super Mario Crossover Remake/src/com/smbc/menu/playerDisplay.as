package com.smbc.menu 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.smbc.character.Character;
	import com.smbc.controller.CharacterData;
	import flash.display.Sprite;
	import com.smbc.controller.CharacterStats;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Josned
	 */
	public class playerDisplay extends Sprite 
	{
		public var m_player_id:int = -1;
		private var m_colors:Array = [0Xff0000, 0X005cff];
		private var m_display:Sprite;
		public var currentChar:*;
		public var m_classID:*;
		public var m_loadedSWF:SWFLoader;
		
		public function playerDisplay(PID:int = -1) 
		{
			super();
			m_player_id = PID;
			m_display = new Sprite();
			m_display.graphics.beginFill(m_colors[m_player_id], 1);
			m_display.graphics.drawRect(0, 0, 64, 64);
			m_display.graphics.endFill();
			currentChar = new Character();
			addChild(m_display);
			addChild(currentChar);
			currentChar.scaleX = 2;
			currentChar.scaleY = 2;
			currentChar.visible = false;
			if(currentChar.m_animation != null) currentChar.m_animation.setCurrentAnimation(currentChar.m_animation.currentSheet.walk);
		}
		
		public function showCharacter(character:String):void 
		{
			m_loadedSWF = new SWFLoader(new URLRequest(Main.resourceManager.characters[character].file));
			m_loadedSWF.load();
			m_loadedSWF.addEventListener(LoaderEvent.COMPLETE, loadedSWF);
			m_loadedSWF.autoDispose = true;
			currentChar.visible = false;
		}
		
		private function loadedSWF(e:LoaderEvent):void 
		{
			var characterStats:CharacterData;
			CharacterStats.writeStats(e.target.rawContent.getCharacter());
			characterStats = CharacterStats.getStats(e.target.rawContent.getCharacter().statsName);
			e.target.removeEventListener(LoaderEvent.COMPLETE, loadedSWF);
			m_loadedSWF.dispose(true);
			m_loadedSWF.unload();
			m_loadedSWF = null;
			currentChar.updateCharacter(characterStats);
		}
		
		public function updateCostume(costume:int):void 
		{
			currentChar.updateCostume(costume);
		}
		
		public function updateCharacter():void 
		{
			currentChar.update();
		}
		
		public function removeAllListener():void 
		{
			removeChild(m_display);
			parent.removeChild(this);
		}
		
	}

}