package kp.rooms.browser
{
	import flash.display.Sprite;
//	import flash.events.EventDispatcher;
	import flash.events.Event;
	import kp.VisualObject;
	import kp.rooms.RoomManager;
	import kp.rooms.RoomData;
	import kp.rooms.browser.Room;

	//-------------------------------------------------------------------------
	// RoomBrowser
	//-------------------------------------------------------------------------
	public class RoomBrowser extends VisualObject
	{
		protected var layout:RoomLayout = null;
		protected var navigation:RoomNavigation = null;

		//---------------------------------------------------------------------
		public function RoomBrowser():void
		{
			subjectDisplay = new RoomBrowserDisplay();

			var layoutDisplay:Sprite = Sprite( subjectDisplay.getChildByName( "layout" ) );
			layout = CreateRoomLayout();
			layout.addEventListener( RoomLayout.ENTER_ROOM, HandleLayoutEvent );
			layout.Embody( layoutDisplay );

			var navigationDisplay:Sprite = Sprite( subjectDisplay.getChildByName( "navigation" ) );
			navigation = CreateRoomNavigation();
			navigation.addEventListener( Door.SELECT, HandleNavigationEvent );
		//	navigation.SetReference( subjectDisplay );
			navigation.Embody( navigationDisplay );
		}

		//---------------------------------------------------------------------
		protected function CreateRoomLayout():RoomLayout
		{
			return new RoomLayout();
		}

		//---------------------------------------------------------------------
		protected function CreateRoomNavigation():RoomNavigation
		{
		//	return new RoomNavigation( subjectDisplay );
			return new RoomNavigation();
		}

		//---------------------------------------------------------------------
		private function HandleLayoutEvent( event:Event ):void
		{
			switch( event.type )
			{
				case RoomLayout.ENTER_ROOM:
				{
					var room:Room = layout.GetCurrentRoom();
					navigation.Update( room.Neighbors );
					dispatchEvent( event );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleNavigationEvent( event:Event ):void
		{
			switch( event.type )
			{
				case Door.SELECT:
				{
					var direction:int = navigation.GetRequestedDirection();
					layout.DisplayNeighbor( direction );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		public function GetCurrentRoom():Room
		{
			return layout.GetCurrentRoom();
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}