package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Josned
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			addChild(new Level);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}

}