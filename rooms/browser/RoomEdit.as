package kp.rooms.browser
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import kp.rooms.RoomData;
	import kp.items.ItemData;
	import kp.items.Item;
	import kp.items.ItemEdit;
	import kp.items.RoomAttribute;
	import kp.server.ServerConnection;

	//-------------------------------------------------------------------------
	// RoomEdit
	//-------------------------------------------------------------------------
	public class RoomEdit extends Room
	{
		private var serverConnection:ServerConnection = ServerConnection.Instance;
		private var state:int = -1;
		private var attributes:SLinkedList = new SLinkedList();
		private var removedAttributeId:int = -1;

		//---------------------------------------------------------------------
		public function RoomEdit( roomData:RoomData ):void
		{
			super( roomData );
		}

		//---------------------------------------------------------------------
		override protected function CreateBackground( itemData:ItemData ):Item
		{
			var item:ItemEdit = new ItemEdit( itemData );
			return item;
		}

		//---------------------------------------------------------------------
		override protected function CreateAttribute( itemData:ItemData ):Item
		{
			var attribute:RoomAttribute = new RoomAttribute( itemData );
			attributes.append( attribute );
			return attribute;
		}

		//---------------------------------------------------------------------
		public function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

				if( attributes.size > 0 )
				{
					var iterator:SListIterator = attributes.getListIterator();
					var attribute:RoomAttribute = null;

					while( iterator.valid() )
					{
						attribute = iterator.data;
						attribute.EnterState( state );
						iterator.forth();
					}
				}
			}
		}

		//---------------------------------------------------------------------
		public function SetBackground( itemData:ItemData ):void
		{
			var item:Item = CreateBackground( itemData );
			item.Position = new Point( 8, 8 );
			item.addEventListener( Item.READY, HandleBackground );
			roomData.Background = itemData;
			serverConnection.SetBackground( itemData.Id, itemData.ItemId, roomData.Id );
		}

		//---------------------------------------------------------------------
		public function AddAttribute( id:int, position:Point ):void
		{
			var itemData:ItemData = itemManager.GetItem( id );
			itemData.Position = position;
			var item:Item = CreateAttribute( itemData );
			item.Position = itemData.Position;
			item.addEventListener( Item.READY, HandleAttributeReady );
			roomData.AddAttribute( itemData );
		//	serverConnection.AddAttribute( id, itemData.ItemId, roomData.Id, position );
		}

	/*
		//---------------------------------------------------------------------
		public function AddAttribute( content:DisplayObject, position:Point ):void
		{}
	*/

		//---------------------------------------------------------------------
		private function HandleBackground( event:Event ):void
		{
			var item:Item = Item( event.target );
			item.removeEventListener( Item.READY, HandleBackground );

			if( background != null )
			{
				background.Destroy();
				background = null;
			}

			background = item;
			background.Embody( subjectDisplay, 0 );
		}

		//---------------------------------------------------------------------
		override protected function HandleAttributeReady( event:Event ):void
		{
			super.HandleAttributeReady( event );
			var attribute:RoomAttribute = RoomAttribute( event.target );
			attribute.addEventListener( RoomAttribute.MOVE, HandleAttributeEvent );
			attribute.addEventListener( RoomAttribute.REMOVE, HandleAttributeEvent );
			attribute.EnterState( state );
			var itemData:ItemData = attribute.Data;
			serverConnection.AddAttribute( itemData.Id, itemData.ItemId, roomData.Id, itemData.Position );
		}

		//---------------------------------------------------------------------
		private function HandleAttributeEvent( event:Event ):void
		{
			var attribute:RoomAttribute = RoomAttribute( event.target );

			switch( event.type )
			{
				case RoomAttribute.MOVE:
				{
					roomData.RemoveAttribute( attribute.Data );
					roomData.AddAttribute( attribute.Data );
				//	trace( attributes.nodeOf( attribute.Data ) );
					serverConnection.SetAttributePosition( attribute.Data.Id, roomData.Id, attribute.Position );
					break;
				}

				case RoomAttribute.REMOVE:
				{
					removedAttributeId = attribute.Data.Id;
				//	attribute.Data.Active = false;
					roomData.RemoveAttribute( attribute.Data );
					attribute.Destroy();
					serverConnection.RemoveAttribute( attribute.Data.Id, roomData.Id );
					break;
				}
			}

			dispatchEvent( event );
		}

		//---------------------------------------------------------------------
		public function GetRemovedAttributeId():int
		{
			return removedAttributeId;
		}
	}
}