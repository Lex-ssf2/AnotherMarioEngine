package com.smbc.controller
{

    public class PlayerSetting
    {

        public var character:String;
        public var name:String;
        public var human:Boolean;
        public var exist:Boolean;
        public var team:Number;
        public var costume:int;
        public var lives:Number;
        public var x_start:Number;
        public var y_start:Number;
        public var x_respawn:Number;
        public var y_respawn:Number;
        public var facingRight:Boolean;

        public function PlayerSetting()
        {
            this.init();
        }

        public function init():void
        {
            this.character = null;
            this.name = null;
            this.human = true;
            this.exist = true;
            this.team = -1;
            this.costume = 0;
            this.lives = 0;
            this.x_start = 0;
            this.y_start = 0;
            this.x_respawn = 0;
            this.y_respawn = 0;
            this.facingRight = true;
        }

        public function getVar(varName:String):*
        {
            if (this[varName] !== undefined)
            {
                return (this[varName]);
            };
            return (null);
        }

       /*public function exportSettings():Object
        {
            return ({
                "character":this.character
            });
        }

        public function importSettings(data:Object):void
        {
            var obj:*;
            for (obj in data)
            {
                if (this[obj] !== undefined)
                {
                    this[obj] = data[obj];
                }
                else
                {
                    trace((('You tried to set "' + obj) + "\" but it doesn't exist in the PlayerSetting class."));
                };
            };
        }*/


    }
}