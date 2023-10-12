package com.smbc.controller 
{
	import com.smbc.menu.charSelectionScreen;
	import com.smbc.engine.Level;
	import com.smbc.levelEditor.Buttons.Play;
	import com.smbc.utils.VcamMC;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import com.smbc.character.*;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class GameController extends Sprite 
	{
		public static var currentLevel:Level;
		public static var m_currentLevelData:Array;
		public static var m_gotoEditor:MovieClip;
		public static var m_Vcam:VcamMC;
		public static var m_playerSettings:Vector.<PlayerSetting> = new Vector.<com.smbc.controller.PlayerSetting>();
		public static var m_charSelectionScreen:Sprite;
		
		public function GameController() 
		{
			super();
		}
				
		public static function startGame(level:Level,mode:int):void 
		{
			System.gc();
			currentLevel = level;
			m_Vcam = new VcamMC();
			currentLevel.m_vcam = m_Vcam;
			Main.Root.addChild(currentLevel);
			currentLevel.m_gameMode = mode;
			Main.Root.addChild(m_Vcam);
			if (mode == 1)
			{
				m_gotoEditor = new Play();
				m_gotoEditor.addEventListener(MouseEvent.CLICK, currentLevel.goingEditorMode,false,0,true);
				m_Vcam.addChild(m_gotoEditor);
				m_gotoEditor.x = m_Vcam.x - m_Vcam.width + 30;
				m_gotoEditor.y = m_Vcam.y + m_Vcam.height - 30;
			}
		}
		
		public static function startCharSelection():void 
		{
			System.gc();
			m_Vcam = new VcamMC();
			m_charSelectionScreen = new charSelectionScreen();
			Main.Root.addChild(m_Vcam);
			Main.Root.addChild(m_charSelectionScreen);
		}
	}

}