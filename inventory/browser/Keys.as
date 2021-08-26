package kp.inventory.browser
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
//	import flash.events.EventDispatcher;
	import flash.events.Event;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import kp.VisualObject;
	import kp.items.ItemManager;
	import kp.items.Item;
	import kp.items.InventoryItem;
	import kp.items.ItemData;

	//-------------------------------------------------------------------------
	// Keys
	//-------------------------------------------------------------------------
	public class Keys extends VisualObject
	{
		public static const DISPLAY_CAPACITY:int = 10;
		public static const ITEM_SIZE:int = 30;
		private const ITEM_DISTANCE:int = ITEM_SIZE + 4;
		private const HALF_ITEM_SIZE:int = ITEM_SIZE / 2;
		private var itemManager:ItemManager = ItemManager.Instance;
		private var items:SLinkedList = null;
		private var selectedItem:InventoryItem = null;
		private var iterator:SListIterator = null;
		private var i:int = 0;

		//---------------------------------------------------------------------
		public function Keys():void
		{
			subjectDisplay = new Sprite();
			items = new SLinkedList();

			if( itemManager.Populated() )
			{
				Initialize();
			}
			else
			{
				itemManager.addEventListener( ItemManager.UPDATED, Initialize );
			}
		}

		//---------------------------------------------------------------------
		private function Initialize( event:Event = null ):void
		{
			itemManager.removeEventListener( ItemManager.UPDATED, Initialize );
			var keys:SLinkedList = itemManager.GetItems( 2 );

			if( keys.size > 0 )
			{
				iterator = keys.getListIterator();
				i = 0;
				LoadItem();
			}
		}

		//---------------------------------------------------------------------
		private function LoadItem( event:Event = null ):void
		{
			if( iterator.valid() && ( i < DISPLAY_CAPACITY ) )
			{
				var itemData:ItemData = iterator.data;
				var item:InventoryItem = new InventoryItem( itemData );
				var P:Point = new Point();
				P.x = 477 - HALF_ITEM_SIZE - ITEM_DISTANCE * i;
				P.y = 12;
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
			iterator.forth();
			LoadItem();
		}

		//---------------------------------------------------------------------
		public function GetSelectedItem():InventoryItem
		{
			return selectedItem;
		}

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
		public function RemoveItem( id:int ):void
		{
			var iterator:SListIterator = items.getListIterator();
			var item:InventoryItem = null;

			while( iterator.valid() )
			{
				item = iterator.data;

				if( item.Data.Id == id )
				{
					items.remove( iterator );
					item.Destroy();
					break;
				}

				iterator.forth();
			}

			itemManager.RemoveItem( id );
		}

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