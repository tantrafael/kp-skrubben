package kp.rooms
{
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Iterator;
	import kp.server.ServerConnection;
	import kp.items.ItemData;
	import kp.items.ItemManager;

	//-------------------------------------------------------------------------
	// RoomManager
	//-------------------------------------------------------------------------
	public class RoomManager extends EventDispatcher
	{
	//	public static const UPDATED:String = "updated";
		public static const POPULATED:String = "populated";
		public static const ROOM_CREATED:String = "roomCreated";
		public static const DOOR_UNLOCKED:String = "doorUnlocked";
		private static const INSTANCE:RoomManager = new RoomManager();
		private var serverConnection:ServerConnection = ServerConnection.Instance;
		private var itemManager:ItemManager = ItemManager.Instance;
		private var rooms:HashMap = null;
		private var ids:Array = null;
		private var directions:Array = null;
		private var baseRoomId:int = -1;
		private var direction:int = -1;
		private var createdRoomId:int = -1;
		private var unlockedRoomId:int = -1;

		//---------------------------------------------------------------------
		public function RoomManager():void
		{
			if( INSTANCE != null )
			{
				throw new Error( "An instance of RoomManager already exists." );
			}
			else
			{
				Initialize();
			}
		}

		//---------------------------------------------------------------------
		public static function get Instance():RoomManager
		{
			return INSTANCE;
		}

		//---------------------------------------------------------------------
		private function Initialize():void
		{
		//	trace( "RoomManager::Initialize()" );
			rooms = new HashMap( 100 );
			ids = new Array();

			directions = new Array( 4 );
			directions[ 0 ] = new Point(  1,  0  );
			directions[ 1 ] = new Point(  0, -1  );
			directions[ 2 ] = new Point( -1,  0  );
			directions[ 3 ] = new Point(  0,  1  );

		//	serverConnection.addEventListener( ServerConnection.DATA_RECEIVED, HandleData );

			if( serverConnection.PendingRoomData() )
			{
				Populate();
			//	HandleData();
			}
			else
			{
			//	serverConnection.addEventListener( ServerConnection.DATA_RECEIVED, HandleData );
				serverConnection.addEventListener( ServerConnection.DATA_RECEIVED, Populate );
			}
		}

		//---------------------------------------------------------------------
		private function Populate( event:Event = null ):void
		{
			serverConnection.removeEventListener( ServerConnection.DATA_RECEIVED, Populate );
			HandleData();
			dispatchEvent( new Event( POPULATED ) );
		}

		//---------------------------------------------------------------------
		public function Populated():Boolean
		{
			return ( rooms.size > 0 );
		}

		//---------------------------------------------------------------------
		public function GetDefaultRoomId():int
		{
			var id:int = 0;

			if( ids && ids.length > 0 )
			{
				id = ids[ 0 ];
			}

			return id;
		}

		//---------------------------------------------------------------------
		public function GetCreatedRoomId():int
		{
			return createdRoomId;
		}

		//---------------------------------------------------------------------
		public function GetUnlockedRoomId():int
		{
			return unlockedRoomId;
		}

		//---------------------------------------------------------------------
		public function Contains( id:int ):Boolean
		{
			return rooms.containsKey( id );
		}

		//---------------------------------------------------------------------
		public function GetRoomById( id:int ):RoomData
		{
			return rooms.find( id );
		}

		//---------------------------------------------------------------------
		public function GetRoomByPosition( position:Point ):RoomData
		{
			var result:RoomData = null;
			var i:int = 0;
			var roomData:RoomData = null;

			while( i < ids.length )
			{
				roomData = rooms.find( ids[ i ] );

				if( roomData.Position.equals( position ) )
				{
					result = roomData;
					break;
				}

				i++;
			}

			return result;
		}

		//---------------------------------------------------------------------
		public function GetIds():Array
		{
		//	return rooms.getKeySet();
			return ids;
		}

	/*
		//---------------------------------------------------------------------
		public function GetRooms():HashMap
		{
			return rooms;
		}
	*/

		//---------------------------------------------------------------------
	//	public function UnlockDoor( baseRoomId:int, direction:int ):void
		public function UnlockDoor( baseRoomId:int, direction:int ):Boolean
		{
		//	trace( "RoomManager::UnlockDoor( " + baseRoomId + ", " + direction + " )" );

			var baseRoom:RoomData = GetRoomById( baseRoomId );
			var position:Point = baseRoom.Position.add( directions[ direction ] );
			var room:RoomData = GetRoomByPosition( position );

			if( room != null )
			{
				unlockedRoomId = room.Id;
				baseRoom.SetNeighborId( direction, room.Id );
				var oppositeDirection:int = ( direction + 2 ) % 4;
				room.SetNeighborId( oppositeDirection, baseRoom.Id );
				serverConnection.UnlockDoor( baseRoomId, direction );
				dispatchEvent( new Event( DOOR_UNLOCKED ) );
			}
			else
			{
				this.baseRoomId = baseRoomId;
				this.direction = direction;
				serverConnection.CreateRoom( baseRoomId, direction );
				serverConnection.addEventListener( ServerConnection.DATA_RECEIVED, HandleCreatedRoom );
			}

			return ( room == null );
		}

		//---------------------------------------------------------------------
		private function HandleCreatedRoom( event:Event = null ):void
		{
			serverConnection.removeEventListener( ServerConnection.DATA_RECEIVED, HandleCreatedRoom );
			HandleData();

			createdRoomId = ids[ ids.length - 1 ];
			var baseRoomData:RoomData = rooms.find( baseRoomId );
			baseRoomData.SetNeighborId( direction, createdRoomId );

			dispatchEvent( new Event( ROOM_CREATED ) );
		}

		//---------------------------------------------------------------------
		private function HandleData( event:Event = null ):void
		{
		//	trace( "RoomManager::HandleData()" );

			var roomList:XMLList = serverConnection.RetrieveRoomData();
			var id:int = 0;
			var position:Point = null;
			var isPublic:Boolean = true;
			var neighbors:Array = null;
			var itemList:XMLList = null;
			var itemId:int = 0;
			var itemPosition:Point = null;
			var background:ItemData = null;
			var attributes:SLinkedList = null;
			var itemData:ItemData = null;
			var itemInfo:Object = null;
			var roomData:RoomData = null;

			for each( var room:XML in roomList )
			{
				position = new Point();
				neighbors = new Array( 4 );
				background = null;
				attributes = new SLinkedList();

				id             = room.id.text();
				position.x     = room.x.text();
				position.y     = room.y.text();
				isPublic       = room.public.text();
				neighbors[ 0 ] = room.east.text();
				neighbors[ 1 ] = room.north.text();
				neighbors[ 2 ] = room.west.text();
				neighbors[ 3 ] = room.south.text();
				itemList       = room.items.item;

				for each( var item:XML in itemList )
				{
					itemId = item.id.text();
					itemPosition = new Point( item.x.text(), item.y.text() );

					itemData = itemManager.GetItem( itemId );
					itemData.Position = itemPosition;
					itemData.Active = true;

					if( itemData.Type == ItemData.BACKGROUND )
					{
						background = itemData;
					}
					else
					{
						attributes.append( itemData );
					}
				}

				roomData = new RoomData( id, position, isPublic, neighbors, background, attributes );
				rooms.insert( id, roomData );
			//	ids.append( id );
				ids.push( id );
			}

		//	trace( ids );
		//	trace( rooms.dump() );

		//	dispatchEvent( new Event( UPDATED ) );
		}

		//---------------------------------------------------------------------
		public function Destroy():void
		{}
	}
}