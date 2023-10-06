package com.smbc.menu 
{
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
		public static var m_characterList:Array = ["Mario", "Luigi"];
		private var m_playButton:Sprite;
		private var m_colors:Array = [0Xff0000, 0X005cff];
		private var m_colorsChar:Array = [0Xff0000, 0x6abe30];
		private var m_charDisplay:Array = new Array();
		private var m_charSlots:Array = new Array();
		private var m_vcam:VcamMC;
		private var m_currentPlayer:int = -1;
		
		public function charSelectionScreen() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void 
		{
			m_vcam = GameController.m_Vcam;
			m_playButton = new Sprite();
			m_playButton.graphics.beginFill(0, 1);
			m_playButton.graphics.drawRect(0, 0, 32, 32);
			m_playButton.graphics.endFill();
			addChild(m_playButton);
			m_playButton.x = m_vcam.x + m_vcam.width/2 - 32;
			m_playButton.y = m_vcam.y + m_vcam.height / 2 - 32;
			for (var i:int = 0; i < m_colors.length; i++) 
			{
				m_charDisplay[i] = new Sprite();
				m_charDisplay[i].graphics.beginFill(m_colors[i], 1);
				m_charDisplay[i].graphics.drawRect(0, 0, 64, 64);
				m_charDisplay[i].graphics.endFill();
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
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clicked);
			trace("Init CharSelection");
		}
		
		private function clicked(e:MouseEvent):void 
		{
			var index:int = m_charDisplay.indexOf(e.target);
			if (index >= 0)
			{
				m_currentPlayer = index;
				return;
			}
			index = m_charSlots.indexOf(e.target);
			if (index >= 0)
			{
				GameController.m_playerSettings[m_currentPlayer] = m_characterList[index];
				trace("Player ", m_currentPlayer + 1, " is " , GameController.m_playerSettings[m_currentPlayer], m_currentPlayer);
				return;
			}
			if (e.target == m_playButton)
			{
				removeAllListener();
				GameController.startGame(new Level(GameController.m_currentLevelData),1);
			}
		}
		
		private function removeAllListener():void 
		{
			m_vcam.removeListener();
			removeChild(m_playButton);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clicked);
		}
	}

}