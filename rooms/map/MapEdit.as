package kp.rooms.map
{
	import flash.events.Event;
//	import kp.rooms.RoomManager;
//	import kp.rooms.RoomData;

	//-------------------------------------------------------------------------
	// MapEdit
	//-------------------------------------------------------------------------
	public class MapEdit extends Map
	{
	//	private var roomManager:RoomManager = RoomManager.Instance;

		//---------------------------------------------------------------------
		public function MapEdit():void
		{
		//	roomManager.addEventListener( RoomManager.ROOM_CREATED, HandleCreatedRoom );
		}

		//---------------------------------------------------------------------
		public function AddRoom( id:int ):void
		{
			layout.AddRoom( id );
		}

	/*
		//---------------------------------------------------------------------
		public function HandleCreatedRoom( event:Event = null ):void
		{
			var id:int = roomManager.GetCreatedRoomId();
		//	var roomData:RoomData = roomManager.GetRoomById( id );
			layout.AddRoom( id );
		}
	*/

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}