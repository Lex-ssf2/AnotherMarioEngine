package com.smbc.utils
{

	import flash.display.Sprite;
	import com.senocular.utils.KeyObject;
	
    public class Controller 
    {

		public const m_up:String = "UP";
		public const m_down:String = "DOWN";
		public const m_right:String = "RIGHT";
		public const m_left:String = "LEFT";
		public const m_button1:String = "BUTTON1";
		public const m_button2:String = "BUTTON2";
		private var m_controlsArray:Array = [m_up, m_down, m_right, m_left, m_button1, m_button2];
        private var _ID:int;
		private var m_controlsMap:Object;

        public function Controller(tempID:int, controls:Object)
        {
            var key:String;
            super();
            this._ID = tempID;
			m_controlsMap = new Object()
			for (var i:int = 0; i < m_controlsArray.length; i++) 
			{
				m_controlsMap[m_controlsArray[i]] = null;
			}
			setControls(controls);
        }

        public function get ID():int
        {
            return (this._ID);
        }
		
		public function getControls():Object
		{
			return m_controlsMap;
		}
		
		public function IsDown(keyNum:String):Boolean
        {
            return KeyObject.isDown(m_controlsMap[keyNum]);
        }
		
		public function setControls(controls:Object):void
        {
            var key:String;
			var objec:Object;
            if (controls != null)
            {
                for (key in controls)
                {
                    try
                    {
                        if ((key in m_controlsMap))
                        {
                            m_controlsMap[key] = controls[key];
                        }
                        /*else
                        {
                            if (["_TAP_JUMP", "_AUTO_DASH", "_DT_DASH"].indexOf(("_" + key)) >= 0)
                            {
                                this[("_" + key)] = controls[key];
                            }
                            else
                            {
                                trace((key + " [in Controller.as] does not exist!!"));
                            };
                        };*/
                    }
                    catch(e)
                    {
                        trace((("A control wasn't set somewhere (" + key) + ")"));
                    };
                };
            };
        }
    }
}