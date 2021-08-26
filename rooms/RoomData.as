package kp.rooms
{
	import flash.geom.Point;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import kp.items.ItemData;

	//-------------------------------------------------------------------------
	// RoomData
	//-------------------------------------------------------------------------
	public class RoomData
	{
		private var id:int = 0;
		private var position:Point = null;
		private var isPublic:Boolean = true;
		private var neighbors:Array = null;
		private var background:ItemData = null;
		private var attributes:SLinkedList = null;

		//---------------------------------------------------------------------
		public function RoomData( id:int, position:Point, isPublic:Boolean, neighbors:Array, background:ItemData, attributes:SLinkedList ):void
		{
			this.id = id;
			this.position = position;
			this.neighbors = neighbors;
			this.background = background;
			this.attributes = attributes;
		}

		//---------------------------------------------------------------------
		public function get Id():int
		{
			return id;
		}

		//---------------------------------------------------------------------
		public function get Position():Point
		{
			return position.clone();
		}

		//---------------------------------------------------------------------
		public function get Neighbors():Array
		{
			return neighbors;
		}

		//---------------------------------------------------------------------
		public function get Background():ItemData
		{
			return background;
		}

		//---------------------------------------------------------------------
		public function set Background( itemData:ItemData ):void
		{
			background = itemData;
		}

		//---------------------------------------------------------------------
		public function get Attributes():SLinkedList
		{
			return attributes;
		}

		//---------------------------------------------------------------------
		public function GetNeighborId( direction:int ):int
		{
			if( neighbors && neighbors.length > direction )
			{
				return neighbors[ direction ];
			}
			else
			{
				return 0;
			}
		}

		//---------------------------------------------------------------------
		public function SetNeighborId( direction:int, roomId:int ):void
		{
			if( neighbors && neighbors.length > direction )
			{
				neighbors[ direction ] = roomId;
			}
		}

		//---------------------------------------------------------------------
		public function AddAttribute( itemData:ItemData ):void
		{
			if( attributes != null )
			{
				attributes.append( itemData );
			}
		}

		//---------------------------------------------------------------------
		public function RemoveAttribute( itemData:ItemData ):void
		{
			if( attributes != null )
			{
				var iterator:SListIterator = attributes.nodeOf( itemData );
				attributes.remove( iterator );
			}
		}

		//---------------------------------------------------------------------
		public function Destroy():void
		{}
	}
}