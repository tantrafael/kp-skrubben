package kp.rooms.browser
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import kp.rooms.browser.Room;
	import kp.items.RoomAttribute;
//	import kp.rooms.RoomManager;

	//-------------------------------------------------------------------------
	// RoomBrowserEdit
	//-------------------------------------------------------------------------
	public class RoomBrowserEdit extends RoomBrowser
	{
	//	public static const VIEW:int = 0;
	//	public static const EDIT:int = 1;
		private var state:int = -1;
	//	private var roomManager:RoomManager = RoomManager.Instance;

	/*
		//---------------------------------------------------------------------
		public function RoomBrowserEdit():void
		{
			super();
		//	roomManager.addEventListener( RoomManager.ROOM_CREATED, HandleCreatedRoom );
		}
	*/

		//---------------------------------------------------------------------
		public function get Navigation():RoomNavigationEdit
		{
			return RoomNavigationEdit( navigation );
		}

		//---------------------------------------------------------------------
		override protected function CreateRoomLayout():RoomLayout
		{
			var roomLayoutEdit:RoomLayoutEdit = new RoomLayoutEdit();
			roomLayoutEdit.addEventListener( RoomAttribute.MOVE, HandleAttributeEvent );
			roomLayoutEdit.addEventListener( RoomAttribute.REMOVE, HandleAttributeEvent );
			return roomLayoutEdit;
		}

		//---------------------------------------------------------------------
		override protected function CreateRoomNavigation():RoomNavigation
		{
			return new RoomNavigationEdit();
		}

		//---------------------------------------------------------------------
		public function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

			/*
				switch( state )
				{
					case VIEW:
					{
						break;
					}

					case EDIT:
					{
						break;
					}
				}
			*/

				RoomNavigationEdit( navigation ).EnterState( state );
				RoomLayoutEdit( layout ).EnterState( state );
			}
		}

		//---------------------------------------------------------------------
		public function Display( id:int ):void
		{
		//	RoomLayoutEdit( layout ).Display( id );
			layout.Display( id );
		}

		//---------------------------------------------------------------------
		public function HitTest( object:DisplayObject ):Boolean
		{
			var background:DisplayObject = subjectDisplay.getChildByName( "background" );
			return object.hitTestObject( background );
		}

		//---------------------------------------------------------------------
		public function UnlockDoor():void
		{
			var room:Room = layout.GetCurrentRoom();
			navigation.Update( room.Neighbors );
		}

		//---------------------------------------------------------------------
		private function HandleAttributeEvent( event:Event ):void
		{
			dispatchEvent( event );
		}

		//---------------------------------------------------------------------
		public function GetRemovedItemId():int
		{
			return RoomLayoutEdit( layout ).GetRemovedItemId();
		}
	}
}