package kp.rooms.map
{
	import flash.display.Sprite;
	import flash.events.Event;
	import kp.VisualObject;
	import kp.rooms.browser.Room;

	//-------------------------------------------------------------------------
	// Map
	//-------------------------------------------------------------------------
	public class Map extends VisualObject
	{
		protected var layout:MapLayout = null;

		//---------------------------------------------------------------------
		public function Map():void
		{
			subjectDisplay = new MapDisplay();
			var layoutDisplay:Sprite = Sprite( subjectDisplay.getChildByName( "layout" ) );
			layout = new MapLayout( layoutDisplay );
		}

		//---------------------------------------------------------------------
	//	public function Display( id:int ):void
		public function Display( room:Room ):void
		{
		//	layout.Display( id );
			layout.Display( room );
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}