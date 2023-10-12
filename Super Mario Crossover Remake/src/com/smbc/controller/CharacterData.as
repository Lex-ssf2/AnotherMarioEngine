package com.smbc.controller
{

    public class CharacterData 
    {

        protected var m_player_id:int;
        protected var m_displayName:String;
        protected var m_statsName:String;
        protected var m_gravity:Number;
        protected var m_jumpSpeed:Number;
        protected var m_shortHopSpeed:Number;
        protected var m_XSpeed:Number;
		protected var m_decel_rate:Number;
		protected var m_accel_rate:Number;
		protected var m_minimum_x_speed:Number;
        protected var m_bitmapController:*;
        protected var m_performAll:*;

        public function CharacterData()
        {
            this.m_player_id = -1;
            this.m_displayName = null;
            this.m_statsName = null;
            this.m_gravity = 0;
            this.m_jumpSpeed = 0;
            this.m_shortHopSpeed = 0;
            this.m_XSpeed = 0;
			this.m_decel_rate = 0;
			this.m_accel_rate = 0;
			this.m_minimum_x_speed = 0;
            this.m_bitmapController = null;
            this.m_performAll = null;
        }

        public function get PlayerID():int
        {
            return this.m_player_id;
        }        
		
		public function get DisplayName():String
        {
            return this.m_displayName;
        }		
		
		public function get StatsName():String
        {
            return this.m_statsName;
        }		
		
		public function get Gravity():Number
        {
            return this.m_gravity;
        }
		
		public function get JumpSpeed():Number
        {
            return this.m_jumpSpeed;
        }		
		
		public function get ShortHopSpeed():Number
        {
            return this.m_shortHopSpeed;
        }
		
		public function get XSpeed():Number
        {
            return this.m_XSpeed;
        }		
		
		public function get DecelRate():Number
        {
            return this.m_decel_rate;
        }
		
		public function get AccelRate():Number
        {
            return this.m_accel_rate;
        }
		
		public function get minimunXSpeed():Number
        {
            return this.m_minimum_x_speed;
        }
		
		public function get BitmapController():*
        {
            return this.m_bitmapController;
        }
		
		public function get PerformAll():*
        {
            return this.m_performAll;
        }

        public function getVar(varName:String):*
        {
            if (this[("m_" + varName)] !== undefined)
            {
                return (this[("m_" + varName)]);
            };
            return (null);
        }
		
		public function importData(data:Object):Boolean
        {
            var obj:*;
            var s:*;
            var flag:Boolean = true;
            if (data != null)
            {
                for (obj in data)
                {
                    if (this["m_" + obj] !== undefined)
                    {
						this["m_" + obj] = data[obj];
                    }
                    else
                    {
                        flag = false;
                        trace(('You tried to set "m_' + obj) + "\" but it doesn't exist in the CharacterData class.");
                    };
                };
            };
            return (flag);
        }


    }
}