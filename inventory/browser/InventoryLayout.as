package kp.inventory.browser
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import kp.VisualObject;
	import kp.items.ItemManager;
	import kp.items.Item;
	import kp.items.InventoryItem;
	import kp.items.ItemData;

	//-------------------------------------------------------------------------
	// InventoryLayout
	//-------------------------------------------------------------------------
	public class InventoryLayout extends VisualObject
	{
	//	public static const ENTER_ROOM:String = "enterRoom";
		public static const DISPLAY_SIZE:Point = new Point( 9, 3 );
		public static const DISPLAY_CAPACITY:int = DISPLAY_SIZE.x * DISPLAY_SIZE.y;
		public static const ITEM_SIZE:int = 44;
		private const ITEM_DISTANCE:int = ITEM_SIZE + 10;
		private const HALF_ITEM_SIZE:int = ITEM_SIZE / 2;
		private var items:SLinkedList = null;
		private var index:int = 0;
		private var selectedItem:InventoryItem = null;
		private var iterator:SListIterator = null;
		private var i:int = 0;
		private var position:Point = new Point();

		//---------------------------------------------------------------------
		public function InventoryLayout():void
		{
			subjectDisplay = new Sprite();
			items = new SLinkedList();
		//	iterator = items.getListIterator();
		}

		//---------------------------------------------------------------------
		public function Display( iterator:SListIterator ):void
		{
			this.iterator = iterator;
			i = 0;
			position.x = position.y = 0;

			var item:InventoryItem = null;
		//	var i:int = 0;
		
			if( items )
			{
				while( items.size > 0 )
				{
					item = items.removeHead();
					item.removeEventListener( Item.READY, HandleItemReady );
					item.Destroy();
				}
			}

		/*
			var position = new Point( 0, 0 );

			while( iterator.valid() && ( i < DISPLAY_CAPACITY ) )
			{
				item = new InventoryItem( iterator.data );
			//	item.Position = new Point( ITEM_SPACE * position.x, ITEM_SPACE * position.y );
				item.Position = new Point( 22 + 54 * position.x, 22 + 54 * position.y );
				item.addEventListener( Item.READY, HandleItemReady );
				items.append( item );

				i++;
				position.x++;

				if( position.x == DISPLAY_SIZE.x )
				{
					position.x = 0;
					position.y++;
				}

				iterator.forth();
			}
		*/

			LoadItem();
		}

		//---------------------------------------------------------------------
		private function LoadItem( event:Event = null ):void
		{
			if( iterator.valid() && ( i < DISPLAY_CAPACITY ) )
			{
				var itemData:ItemData = iterator.data;
				var item:InventoryItem = new InventoryItem( itemData );
				var P:Point = new Point();
				P.x = HALF_ITEM_SIZE + ITEM_DISTANCE * position.x;
				P.y = HALF_ITEM_SIZE + ITEM_DISTANCE * position.y;
				item.Position = P;
				item.addEventListener( Item.READY, HandleItemReady );
				items.append( item );
			}
		}

		//---------------------------------------------------------------------
		private function HandleItemReady( event:Event ):void
		{
			var item:InventoryItem = InventoryItem( event.target );
			item.removeEventListener( Item.READY, HandleItemReady );
			item.addEventListener( InventoryItem.SELECT, HandleItemEvent );

			if( item.Data.Active )
			{
				item.EnterState( InventoryItem.ACTIVE );
			}
			else
			{
				item.EnterState( InventoryItem.INACTIVE );
			}

			var content:DisplayObject = item.Content;

			if( content != null )
			{
				var itemSize:Number = Math.max( content.width, content.height );

				if( itemSize > ITEM_SIZE )
				{
					var scale:Number = ITEM_SIZE / itemSize;
					content.scaleX = content.scaleY = scale;
				}

				content.x = Math.round( -0.5 * content.width );
				content.y = Math.round( -0.5 * content.height );
			}

			item.Embody( subjectDisplay );

			i++;
			position.x++;

			if( position.x == DISPLAY_SIZE.x )
			{
				position.x = 0;
				position.y++;
			}

			iterator.forth();
			LoadItem();
		}

		//---------------------------------------------------------------------
		public function GetSelectedItem():InventoryItem
		{
			return selectedItem;
		}

	/*
		//---------------------------------------------------------------------
		public function ActivateItem( id:int ):void
		{
			var iterator:SListIterator = items.getListIterator();

			while( iterator.valid() )
			{
				var item:InventoryItem = iterator.data;

				if( item.Data.Id == id )
				{
					item.EnterState( InventoryItem.INACTIVE );
					break;
				}

				iterator.forth();
			}
		}

		//---------------------------------------------------------------------
		public function DeactivateItem( id:int ):void
		{
			var iterator:SListIterator = items.getListIterator();

			while( iterator.valid() )
			{
				var item:InventoryItem = iterator.data;

				if( item.Data.Id == id )
				{
					item.EnterState( InventoryItem.ACTIVE );
					break;
				}

				iterator.forth();
			}
		}
	*/

		//---------------------------------------------------------------------
		public function SetItemState( id:int, state:int ):void
		{
			var iterator:SListIterator = items.getListIterator();

			while( iterator.valid() )
			{
				var item:InventoryItem = iterator.data;

				if( item.Data.Id == id )
				{
					item.EnterState( state );
					break;
				}

				iterator.forth();
			}
		}

	/*
		//---------------------------------------------------------------------
		private function HandleItemReady( event:Event ):void
		{
			var item:InventoryItem = InventoryItem( event.target );
			item.removeEventListener( Item.READY, HandleItemReady );
			item.addEventListener( InventoryItem.SELECT, HandleItemEvent );

			if( item.Data.Active )
			{
				item.EnterState( InventoryItem.ACTIVE );
			}
			else
			{
				item.EnterState( InventoryItem.INACTIVE );
			}

			var content:DisplayObject = item.Content;

			if( content != null )
			{
				var itemSize:Number = Math.max( content.width, content.height );

				if( itemSize > ITEM_SIZE )
				{
					var scale:Number = ITEM_SIZE / itemSize;
					content.scaleX = content.scaleY = scale;
				}

				content.x = Math.round( -0.5 * content.width );
				content.y = Math.round( -0.5 * content.height );
			}

			item.Embody( subjectDisplay );
		}
	*/

		//---------------------------------------------------------------------
		private function HandleItemEvent( event:Event ):void
		{
			selectedItem = InventoryItem( event.target );
			dispatchEvent( event );
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}