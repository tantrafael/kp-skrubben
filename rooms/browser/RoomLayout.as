package kp.rooms.browser
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import de.polygonal.ds.SListNode;
	import animation.sliding.Slider;
	import animation.sliding.SpringPositionSlider;
	import kp.VisualObject;
	import kp.rooms.RoomManager;
	import kp.rooms.RoomData;
	import kp.rooms.browser.Room;

	//-------------------------------------------------------------------------
	// RoomLayout
	//-------------------------------------------------------------------------
	public class RoomLayout extends VisualObject
	{
		public static const ENTER_ROOM:String = "enterRoom";
		private var roomManager:RoomManager = null;
		private var currentRoomId:int = 0;
		private var nextRoomId:int = 0;
		private var list:SLinkedList = null;
		private var iterator:SListIterator = null;
		private var slider:SpringPositionSlider = null;

		//---------------------------------------------------------------------
		public function RoomLayout():void
		{
			subjectDisplay = new Sprite();

			list = new SLinkedList();
			iterator = list.getListIterator();

			slider = new SpringPositionSlider( 0.05, 0.1, 0.3 );
			slider.addEventListener( Slider.STOP, HandleSliderStop );

			roomManager = RoomManager.Instance;

			if( roomManager.Populated() )
			{
				Initialize();
			}
			else
			{
			//	roomManager.addEventListener( RoomManager.UPDATED, Initialize );
				roomManager.addEventListener( RoomManager.POPULATED, Initialize );
			}
		}

		//---------------------------------------------------------------------
		private function Initialize( event:Event = null ):void
		{
		//	roomManager.removeEventListener( RoomManager.UPDATED, Initialize );
			roomManager.removeEventListener( RoomManager.POPULATED, Initialize );
			var id:int = roomManager.GetDefaultRoomId();
			Display( id );
		}

		//---------------------------------------------------------------------
		public function DisplayNeighbor( direction:int ):void
		{
			if( iterator.valid() )
			{
				var room:Room = iterator.data;
				var id:int = room.GetNeighborId( direction );
				Display( id );
			}
		}

		//---------------------------------------------------------------------
		public function Display( id:int ):void
		{
			if( ( id > 0 ) && ( id != nextRoomId ) )
			{
				if( id == currentRoomId )
				{
					RemoveNext();
				}
				else
				{
					if( roomManager.Contains( id ) )
					{
						if( ReuseExisting( id ) )
						{
							EnterNext();
						}
						else
						{
							CreateNext( id );
						}
					}
				}
			}
		}

		//---------------------------------------------------------------------
		private function CreateNext( id ):void
		{
			RemoveNext();

			var roomData:RoomData = roomManager.GetRoomById( id );
			var room:Room = CreateRoom( roomData );
			list.append( room );
			nextRoomId = id;

			if( list.size == 1 )
			{
				var P:Point = room.DisplayPosition;
				P.x = -P.x;
				P.y = -P.y;
				slider.Position = P;
			}

			if( room.Ready() )
			{
				EnterNext();
			}
			else
			{
				room.addEventListener( Room.READY, EnterNext );
			}
		}

		//---------------------------------------------------------------------
		protected function CreateRoom( roomData:RoomData ):Room
		{
			return new Room( roomData );
		}

		//---------------------------------------------------------------------
		private function EnterNext( event:Event = null ):void
		{
			var room:Room = null;

			while( list.size > 2 )
			{
				room = list.removeHead();
				room.Destroy();
			}

			iterator.end();

			room = iterator.data;
			room.removeEventListener( Room.READY, EnterNext );
			room.Embody( subjectDisplay );

			var P:Point = room.DisplayPosition.clone();
			P.x = -P.x;
			P.y = -P.y;
			subjectDisplay.addEventListener( Event.ENTER_FRAME, Render );
			slider.Slide( P );

			currentRoomId = room.Id;
			nextRoomId = 0;

			dispatchEvent( new Event( ENTER_ROOM ) );
		}

		//---------------------------------------------------------------------
		private function ReuseExisting( id ):Boolean
		{
			var found:Boolean = false;
			var i:SListIterator = list.getListIterator();
			var room:Room = null;
			var roomId:int = 0;

			while( !found && i.valid() )
			{
				room = i.data;
				roomId = room.Id;

				if( roomId == id )
				{
					found = true;
					list.remove( i );
					list.append( room );
				}
				else
				{
					i.forth();
				}
			}

			return found;
		}

		//---------------------------------------------------------------------
		private function RemoveNext():void
		{
			iterator.forth();

			if( iterator.valid() )
			{
				var undisplayed:Room = list.removeTail();
				undisplayed.removeEventListener( Room.READY, EnterNext );
				undisplayed.Destroy();
			}

			iterator.end();

			nextRoomId = 0;
		}

		//---------------------------------------------------------------------
		private function HandleSliderStop( event:Event ):void
		{
			subjectDisplay.removeEventListener( Event.ENTER_FRAME, Render );
			Render();

			var room:Room = null;
			var currentNode:SListNode = iterator.node;

			while( list.head != currentNode )
			{
				room = list.removeHead();
				room.Destroy();
			}
		}

		//---------------------------------------------------------------------
		private function Render( event:Event = null ):void
		{
			subjectDisplay.x = slider.Position.x;
			subjectDisplay.y = slider.Position.y;
		}

		//---------------------------------------------------------------------
		public function GetCurrentRoom():Room
		{
			return iterator.data;
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}