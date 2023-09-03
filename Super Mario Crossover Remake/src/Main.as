package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Josned
	 */
	public dynamic class Main extends Sprite 
	{
		
		public var m_level:Level = new Level;
		private static var ROOT:Main;
		
		public function Main() 
		{
			super();
			ROOT = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			addChild(new LevelEditor);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		public static function get Root():Main
        {
            return (ROOT);
        }
		
	}

}