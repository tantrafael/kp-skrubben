package kp.rooms.browser
{
	import de.polygonal.ds.SLinkedList;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLRequest;
	import de.polygonal.ds.SListIterator;
	import kp.VisualObject;
	import kp.rooms.RoomData;
	import kp.items.ItemManager;
	import kp.items.ItemData;
	import kp.items.Item;

	//-------------------------------------------------------------------------
	// Room
	//-------------------------------------------------------------------------
	public class Room extends VisualObject
	{
		public static const READY:String = "ready";
	//	public static const SIZE:Point = new Point( 554, 269 );
		public static const BOUNDS:Rectangle = new Rectangle( 8, 8, 554, 269 );
		protected var roomData:RoomData = null;
		protected var itemManager:ItemManager = ItemManager.Instance;
		protected var background:Item = null;
		private var iterator:SListIterator = null;
		private var displayPosition:Point = null;
		private var loaded:int = 0;
		private var ready:Boolean = false;

		//---------------------------------------------------------------------
		public function Room( roomData:RoomData ):void
		{
			this.roomData = roomData;

		//	displayPosition = new Point( SIZE.x * roomData.Position.x, SIZE.y * roomData.Position.y );
			displayPosition = new Point( BOUNDS.width * roomData.Position.x, BOUNDS.height * roomData.Position.y );

			subjectDisplay = new Sprite();
			subjectDisplay.x = displayPosition.x;
			subjectDisplay.y = displayPosition.y;

			if( roomData.Background != null )
			{
			//	background = new Item( roomData.Background );
				background = CreateBackground( roomData.Background );
				background.Position = new Point( 8, 8 );
				background.addEventListener( Item.READY, Proceed );
			}
			else
			{
				Proceed();
			}
		}

		//---------------------------------------------------------------------
		private function Proceed( event:Event = null ):void
		{
			if( background != null )
			{
				background.removeEventListener( Item.READY, Proceed );
				background.Embody( subjectDisplay, 0 );
			}

			ready = true;
			dispatchEvent( new Event( READY ) );
			iterator = roomData.Attributes.getListIterator();
			LoadAttribute();
		}

		//---------------------------------------------------------------------
		private function LoadAttribute( event:Event = null ):void
		{
			if( iterator.valid() )
			{
				var itemData:ItemData = iterator.data;
				var item:Item = CreateAttribute( itemData );
				item.Position = itemData.Position;
				item.addEventListener( Item.READY, HandleAttributeReady );
			}
		}

		//---------------------------------------------------------------------
		protected function HandleAttributeReady( event:Event ):void
		{
			var item:Item = Item( event.target );
			item.removeEventListener( Item.READY, HandleAttributeReady );
			item.Embody( subjectDisplay );
			iterator.forth();
			LoadAttribute();
		}

		//---------------------------------------------------------------------
		protected function CreateBackground( itemData:ItemData ):Item
		{
			return new Item( itemData );
		}

		//---------------------------------------------------------------------
		protected function CreateAttribute( itemData:ItemData ):Item
		{
			return new Item( itemData );
		}

		//---------------------------------------------------------------------
		public function get Id():int
		{
			return roomData.Id;
		}

		//---------------------------------------------------------------------
		public function get Neighbors():Array
		{
			return roomData.Neighbors;
		}

		//---------------------------------------------------------------------
		public function get DisplayPosition():Point
		{
			return displayPosition.clone();
		}

		//---------------------------------------------------------------------
		public function Ready():Boolean
		{
			return ready;
		}

		//---------------------------------------------------------------------
		public function GetNeighborId( direction:int ):int
		{
			return roomData.GetNeighborId( direction );
		}

		//---------------------------------------------------------------------
		public function GetBackground():Item
		{
			return background;
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}