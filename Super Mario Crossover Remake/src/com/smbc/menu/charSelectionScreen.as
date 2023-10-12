package com.smbc.menu 
{
	import com.smbc.controller.PlayerSetting;
	import com.smbc.engine.Level;
	import com.smbc.utils.VcamMC;
	import flash.display.Sprite;
	import com.smbc.character.*;
	import com.smbc.controller.GameController;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Josned
	 */
	public class charSelectionScreen extends Sprite 
	{
		public static var m_characterList:Array = ["mario", "luigi"];
		private var m_playButton:Sprite;
		private var m_colorsChar:Array = [0Xff0000, 0x6abe30];
		private var m_charDisplay:Array = new Array();
		private var m_charSlots:Array = new Array();
		private var m_vcam:VcamMC;
		private var m_currentPlayer:int = 0;
		
		public function charSelectionScreen() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void 
		{
			m_vcam = GameController.m_Vcam;
			GameController.m_playerSettings.splice(0, GameController.m_playerSettings.length);
			m_playButton = new Sprite();
			m_playButton.graphics.beginFill(0, 1);
			m_playButton.graphics.drawRect(0, 0, 32, 32);
			m_playButton.graphics.endFill();
			addChild(m_playButton);
			m_playButton.x = m_vcam.x + m_vcam.width/2 - 32;
			m_playButton.y = m_vcam.y + m_vcam.height / 2 - 32;
			for (var i:int = 0; i < Main.MAXPLAYERS; i++) 
			{
				m_charDisplay[i] = new playerDisplay(i);
				addChild(m_charDisplay[i]);
				m_charDisplay[i].x = m_vcam.x - m_vcam.width / 2 + 30 + (64 * (i));
				m_charDisplay[i].y = m_vcam.y + m_vcam.height / 2 - 64 - 30;
			}			
			for (i = 0; i < m_colorsChar.length; i++) 
			{
				m_charSlots[i] = new Sprite();
				m_charSlots[i].graphics.beginFill(m_colorsChar[i], 1);
				m_charSlots[i].graphics.drawRect(0, 0, 64, 64);
				m_charSlots[i].graphics.endFill();
				addChild(m_charSlots[i]);
				m_charSlots[i].x = m_vcam.x - m_vcam.width / 2 + 30 + (64 * (i));
				m_charSlots[i].y = m_vcam.y - m_vcam.height / 2 + 64 + 30;
			}
			for (i = 0; i < Main.MAXPLAYERS; i++) 
			{
				GameController.m_playerSettings.push(new PlayerSetting);
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clicked);
			stage.addEventListener(Event.ENTER_FRAME, performAll);
			trace("Init CharSelection");
		}
		
		private function clicked(e:MouseEvent):void 
		{
			var index:int = m_charDisplay.indexOf(e.target.parent);
			if (index >= 0)
			{
				m_currentPlayer = index;
				return;
			}
			if ( e.target.parent != null && e.target.parent.parent.parent != null)
			{
				index = m_charDisplay.indexOf(e.target.parent.parent.parent);
				if (index >= 0)
				{
					m_currentPlayer = index;
					GameController.m_playerSettings[m_currentPlayer].costume++;
					if (GameController.m_playerSettings[m_currentPlayer].costume >= m_charDisplay[m_currentPlayer].currentChar.m_classID.images.length)
					{
						GameController.m_playerSettings[m_currentPlayer].costume = 0;
					}
					m_charDisplay[m_currentPlayer].updateCostume(GameController.m_playerSettings[m_currentPlayer].costume);
					return;
				}	
			}
			index = m_charSlots.indexOf(e.target);
			if (index >= 0)
			{
				GameController.m_playerSettings[m_currentPlayer].character = m_characterList[index];
				m_charDisplay[m_currentPlayer].m_classID = GameController.m_playerSettings[m_currentPlayer].character;
				m_charDisplay[m_currentPlayer].showCharacter(m_characterList[index]);
				return;
			}
			if (e.target == m_playButton)
			{
				removeAllListener();
				for (var i:int = 0; i < GameController.m_playerSettings.length; i++) 
				{
					if (GameController.m_playerSettings[i].character == null) continue;
					Main.Root.loadCharacterSWF(GameController.m_playerSettings[i].character);
				}
			}
		}
		
		private function performAll(e:Event = null):void 
		{
			for (var i:int = 0; i < m_charDisplay.length; i++) 
			{
				m_charDisplay[i].updateCharacter();
			}
		}
		
		private function removeAllListener():void 
		{
			for (var i:int = 0; i < m_charDisplay.length; i++) 
			{
				m_charDisplay[i].removeAllListener();
			}
			m_vcam.removeListener();
			removeChild(m_playButton);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clicked);
			stage.removeEventListener(Event.ENTER_FRAME, performAll);
		}
	}

}