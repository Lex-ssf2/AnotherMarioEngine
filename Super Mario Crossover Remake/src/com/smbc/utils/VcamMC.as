package com.smbc.utils 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	/**
	 * ...
	 * @author Josned
	 */
	public class VcamMC extends MovieClip
	{
		public var cameraTrans:Transform = new Transform(this);
		public var stageTrans:Transform;
		public var m_parent:*;
		public var rectangle:Sprite = new Sprite();
		
		public function VcamMC() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			stageTrans = new Transform(stage);
			m_parent = parent;
			rectangle.graphics.beginFill(0xFF0000, 0.5);
			rectangle.graphics.drawRect(-stage.stageWidth / 2, -stage.stageHeight / 2, stage.stageWidth, stage.stageHeight);
			rectangle.graphics.endFill();
			rectangle.visible = false;
			addChild(rectangle);
			stage.addEventListener(Event.ENTER_FRAME, updatePos);
		}
		
		public function updatePos(e:Event):void 
		{
			m_parent.filters = filters;
			stageTrans.colorTransform = cameraTrans.colorTransform;
			var stageMatrix:Matrix = cameraTrans.matrix;
			stageMatrix.invert();
			stageMatrix.translate(stage.stageWidth * Math.pow(1/2,stage.stageWidth/rectangle.width), stage.stageHeight * Math.pow(1/2,stage.stageWidth/rectangle.width));
			stageTrans.matrix = stageMatrix;
		}
		
	}

}