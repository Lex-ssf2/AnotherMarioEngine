package com.smbc.controller 
{
	import com.smbc.bmd.Characters.Mario.*;
	import com.smbc.character.Character;
	import com.smbc.controller.CharacterData;
	/**
	 * ...
	 * @author Josned
	 */
	public class CharacterStats 
	{
		private static var m_statObjects:Object = new Object();
		
		public function CharacterStats() 
		{ 
		}
		
		public static function writeStats(data:Object):void
        {
            data = ((data) || ({}));
            var charName:String = ((data) ? data.statsName : null);
            if (charName)
            {
                if (CharacterStats.m_statObjects[charName] == undefined)
                {
                    CharacterStats.m_statObjects[charName] = new Object();
                };
                if (data)
                {
                    CharacterStats.m_statObjects[charName] = data;
                };
            };
        }
		
		public static function getStats(charName:String):CharacterData
        {
            return createCharacterDataFrom(CharacterStats.m_statObjects[charName]);
        }
		
		private static function createCharacterDataFrom(data:Object):CharacterData
        {
            var obj:Object;
            var tmp:CharacterData = new CharacterData();
            data = ((data) || ({}));
            var cData:Object = ((data) || ({}));
            if (CharacterStats.m_statObjects[cData.statsName] != null)
            {
                obj = CharacterStats.m_statObjects[cData.statsName];
                tmp.importData(obj);
            }
            return (tmp);
        }
	}

}