package kp.rooms.browser
{
	import flash.display.Sprite;
	import flash.events.Event;
	import kp.rooms.RoomData;
	import kp.rooms.browser.Room;
	import kp.rooms.browser.RoomEdit;
	import kp.items.RoomAttribute;

	//-------------------------------------------------------------------------
	// RoomLayoutEdit
	//-------------------------------------------------------------------------
	public class RoomLayoutEdit extends RoomLayout
	{
		private var state:int = -1;
		private var removedAttributeRoom:RoomEdit = null;

		//---------------------------------------------------------------------
		override protected function CreateRoom( roomData:RoomData ):Room
		{
			var room:RoomEdit = new RoomEdit( roomData );
			room.EnterState( state );
			room.addEventListener( RoomAttribute.MOVE, HandleAttributeEvent );
			room.addEventListener( RoomAttribute.REMOVE, HandleAttributeEvent );
			return room;
		}

		//---------------------------------------------------------------------
		public function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

				var currentRoom:Room = GetCurrentRoom();

				if( currentRoom )
				{
					RoomEdit( currentRoom ).EnterState( state );
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleAttributeEvent( event:Event ):void
		{
			switch( event.type )
			{
				case RoomAttribute.REMOVE:
				{
					removedAttributeRoom = RoomEdit( event.target );
					break;
				}
			}

			dispatchEvent( event );
		}

		//---------------------------------------------------------------------
		public function GetRemovedItemId():int
		{
			var id:int = -1;

			if( removedAttributeRoom != null )
			{
				id = removedAttributeRoom.GetRemovedAttributeId();
			}

			return id;
		}
	}
}