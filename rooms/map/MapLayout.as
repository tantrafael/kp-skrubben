package kp.rooms.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import de.polygonal.ds.SListNode;
	import animation.sliding.Slider;
	import animation.sliding.SpringPositionSlider;
	import kp.rooms.RoomManager;
	import kp.rooms.RoomData;
	import kp.rooms.browser.Room;
	import kp.items.Item;

	//-------------------------------------------------------------------------
	// MapLayout
	//-------------------------------------------------------------------------
	public class MapLayout extends EventDispatcher
	{
		private var subjectDisplay:Sprite = null;
		private var rooms:HashMap = null;
		private var currentRoom:MapRoom = null;
		private var slider:SpringPositionSlider = null;
		private var roomManager:RoomManager = RoomManager.Instance;

		//---------------------------------------------------------------------
		public function MapLayout( objectDisplay:Sprite ):void
		{
			subjectDisplay = new Sprite();
		//	subjectDisplay = new MapLayoutDisplay();
			objectDisplay.addChild( subjectDisplay );

			rooms = new HashMap( 100 );

			slider = new SpringPositionSlider( 0.05, 0.1, 0.3 );
			slider.addEventListener( Slider.STOP, HandleSliderStop );

			if( roomManager.Populated() )
			{
				Initialize();
			}
			else
			{
				roomManager.addEventListener( RoomManager.POPULATED, Initialize );
			}
		}

		//---------------------------------------------------------------------
		private function Initialize( event:Event = null ):void
		{
		//	roomManager.removeEventListener( RoomManager.UPDATED, Initialize );
			roomManager.removeEventListener( RoomManager.POPULATED, Initialize );

			var ids:Array = roomManager.GetIds();

			for each( var id:int in ids )
			{
				AddRoom( id );
			}

			var	room:MapRoom = rooms.find( ids[ 0 ] );
			var P:Point = room.DisplayPosition;
			P.x = -P.x;
			P.y = -P.y;
		//	slider.Position = P;
		}

		//---------------------------------------------------------------------
	//	public function Display( id:int ):void
		public function Display( room:Room ):void
		{
			if( currentRoom != null )
			{
				currentRoom.Deactivate();
			}

			currentRoom = rooms.find( room.Id );

			if( currentRoom != null )
			{
			//	currentRoom.Activate( room.GetBackground() );

				var id:int = room.Id;
				var backgroundItem:Item = room.GetBackground();
				var bitmap:Bitmap = null;

				if( backgroundItem != null )
				{
					var background:DisplayObject = backgroundItem.Content;
					var bitmapData:BitmapData = new BitmapData( 38, 18 );
					var matrix:Matrix = new Matrix();
					var scale = bitmapData.width / background.width;
					matrix.scale( scale, scale );
					bitmapData.draw( background, matrix, null, null, null, true );
					bitmap = new Bitmap( bitmapData );
				}

				currentRoom.Activate( bitmap );

				var P:Point = currentRoom.DisplayPosition.clone();
				P.x = -P.x;
				P.y = -P.y;

				subjectDisplay.addEventListener( Event.ENTER_FRAME, Render );
				slider.Slide( P );
			}
		}

		//---------------------------------------------------------------------
		public function AddRoom( id:int ):void
		{
			var roomData:RoomData = roomManager.GetRoomById( id );
			var room:MapRoom = new MapRoom( roomData );
			room.Embody( subjectDisplay );
			rooms.insert( id, room );
		}

		//---------------------------------------------------------------------
		private function HandleSliderStop( event:Event ):void
		{
			subjectDisplay.removeEventListener( Event.ENTER_FRAME, Render );
			Render();
		}

		//---------------------------------------------------------------------
		private function Render( event:Event = null ):void
		{
			subjectDisplay.x = slider.Position.x;
			subjectDisplay.y = slider.Position.y;
		}

		//---------------------------------------------------------------------
		public function Destroy():void
		{}
	}
}