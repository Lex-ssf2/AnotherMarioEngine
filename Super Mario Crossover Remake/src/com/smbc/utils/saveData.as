package com.smbc.utils 
{
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Josned
	 */
	public class saveData 
	{
		public static var controllers:Vector.<Controller>;
		private static var m_sharedObject:SharedObject;
        private static var m_localObject:Object;
		public static var m_currentSaveFileName:String = "savedataDemo.dat";
		public static var corrupted:Boolean = false;
		
		public function saveData() 
		{
			
		}
		
		public static function initializeSaveData():void
        {
			var i:int = 0;
			saveData.controllers = new Vector.<Controller>();
			loadGame();
			m_localObject = new Object();
			/*if (m_sharedObject.data.savedata == undefined || !(m_sharedObject.data.savedata is Object))
            {
                m_localObject = new Object();
				trace("huh");
            }
            else
            {
				trace(m_sharedObject.data.savedata, "Tenemos saveData señores");
				var byteArraySharedObject:ByteArray = new ByteArray();
				byteArraySharedObject.writeObject(m_sharedObject.data.savedata);
				byteArraySharedObject.position = 0;
				m_localObject = byteArraySharedObject.readObject();
                if (((!(m_localObject)) || (!(m_localObject.game.controlSettings))))
                {
                    m_localObject = new Object();
                    corrupted = true;
                };
            };*/
			if ((((m_localObject.game == undefined) || (m_localObject.game.exists == undefined)) || (m_localObject.game.exists == false)))
            {
				m_localObject.game = {
					"exists":true,
					"update":"01_test",
					"controlSettings":{}
				}
				for (i = 0; i < Main.MAXPLAYERS; i++) 
				{
					switch (i) 
					{
						case 0:
							saveData.controllers.push(new Controller(i, {
								"UP":Keyboard.UP,
								"DOWN":Keyboard.DOWN,
								"LEFT":Keyboard.LEFT,
								"RIGHT":Keyboard.RIGHT,
								"BUTTON1":Keyboard.NUMPAD_2,
								"BUTTON2":Keyboard.NUMPAD_3
							}));
						break;
						case 1:
							saveData.controllers.push(new Controller(i, {
								"UP":Keyboard.W,
								"DOWN":Keyboard.S,
								"LEFT":Keyboard.A,
								"RIGHT":Keyboard.D,
								"BUTTON1":Keyboard.O,
								"BUTTON2":Keyboard.P
							}));
						break;
						default:
								saveData.controllers.push(new Controller(i, {
								"UP":0,
								"DOWN":0,
								"LEFT":0,
								"RIGHT":0,
								"BUTTON1":0,
								"BUTTON2":0
							}));
						break;
					}
					m_localObject.game.controlSettings["player" + i] = saveData.controllers[i].getControls();
				}
				saveGame();
			}
			else{
				trace("SaveData Exist");
				for (i = 0; i < Main.MAXPLAYERS; i++) 
				{
						saveData.controllers.push(new Controller(i, {
						"UP":0,
						"DOWN":0,
						"LEFT":0,
						"RIGHT":0,
						"BUTTON1":0,
						"BUTTON2":0
					}));
					if (m_localObject.game.controlSettings["player" + i])
					{
						saveData.controllers[i].setControls(m_localObject.game.controlSettings["player" + i]);
					}
				}
			}
		}
		
		public static function saveGame():void
        {
			m_sharedObject.data.savedata = m_localObject;
			m_sharedObject.flush();
        }
		
		public static function loadGame():void
        {
            m_sharedObject = SharedObject.getLocal(m_currentSaveFileName, "/");
        }
	}

}