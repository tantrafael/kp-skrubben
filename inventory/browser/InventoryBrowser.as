package kp.inventory.browser
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import kp.VisualObject;
	import kp.items.ItemManager;
	import kp.items.InventoryItem;

	//-------------------------------------------------------------------------
	// InventoryBrowser
	//-------------------------------------------------------------------------
	public class InventoryBrowser extends VisualObject
	{
		private var layout:InventoryLayout = null;
		private var navigation:InventoryNavigation;
		private var itemManager:ItemManager = ItemManager.Instance;
		private var collection:SLinkedList = null;
		private var iterator:SListIterator = null;
		private var type:int = -1;
		private var page:int = -1;

		//---------------------------------------------------------------------
		public function InventoryBrowser():void
		{
			subjectDisplay = new InventoryBrowserDisplay();

			var layoutDisplay:Sprite = Sprite( subjectDisplay.getChildByName( "layout" ) );
			layout = new InventoryLayout();
			layout.addEventListener( InventoryItem.SELECT, HandleLayoutEvent );
			layout.Embody( layoutDisplay );

			var navigationDisplay:Sprite = Sprite( subjectDisplay.getChildByName( "navigation" ) );
			navigation = new InventoryNavigation( navigationDisplay );
			navigation.addEventListener( InventoryNavigation.SELECT_TYPE, HandleTypeSelection );
			navigation.addEventListener( InventoryNavigation.SELECT_DIRECTION, HandleDirectionSelection );
			navigation.addEventListener( InventoryNavigation.SELECT_PAGE, HandlePageSelection );
		//	navigation.Embody( navigationDisplay );

		//	itemManager.addEventListener( ItemManager.ITEM_ACTIVATED, HandleItemActivation );
		}

		//---------------------------------------------------------------------
		override public function Embody( objectDisplay:Sprite, depth:int = -1 ):void
		{
			super.Embody( objectDisplay, depth );

			if( type < 0 )
			{
				DisplayType( 1 );
			}
		}

		//---------------------------------------------------------------------
		public function GetSelectedItem():InventoryItem
		{
			return layout.GetSelectedItem();
		}

		//---------------------------------------------------------------------
		public function ActivateItem( id:int ):void
		{
		//	layout.ActivateItem( id );
			layout.SetItemState( id, InventoryItem.INACTIVE );
		}

		//---------------------------------------------------------------------
		public function DeactivateItem( id:int ):void
		{
		//	layout.DeactivateItem( id );
			layout.SetItemState( id, InventoryItem.ACTIVE );
		}

		//---------------------------------------------------------------------
		private function HandleTypeSelection( event:Event ):void
		{
			var type:int = navigation.GetSelectedType();
			DisplayType( type );
		}

		//---------------------------------------------------------------------
		private function HandleDirectionSelection( event:Event ):void
		{
			var direction:int = navigation.GetSelectedDirection();
			DisplayPage( page + direction );
		}

		//---------------------------------------------------------------------
		private function HandlePageSelection( event:Event ):void
		{
			DisplayPage( navigation.GetSelectedPage() );
		}

		//---------------------------------------------------------------------
		private function DisplayType( type:int ):void
		{
			navigation.DisplayType( type );

			if( this.type != type )
			{
				this.type = type;
				collection = itemManager.GetItems( type );
				iterator = collection.getListIterator();
				var pages:int = Math.ceil( collection.size / InventoryLayout.DISPLAY_CAPACITY );
				navigation.SetPages( pages );
				page = 0;
				layout.Display( iterator );
				navigation.DisplayType( type );
				navigation.DisplayPage( page );
			//	navigation.Display( type, page );
			}
		}

		//---------------------------------------------------------------------
		private function DisplayPage( page:int ):void
		{
			if( this.page != page )
			{
				this.page = page;
				var index:int = page * InventoryLayout.DISPLAY_CAPACITY;
				var i:int = 0;
				iterator.start();

				while( ( i < index ) && iterator.hasNext() )
				{
					i++;
					iterator.forth();
				}

				layout.Display( iterator );
				navigation.DisplayPage( page );
			}
		}

		//---------------------------------------------------------------------
		private function HandleLayoutEvent( event:Event ):void
		{
			switch( event.type )
			{
				case InventoryItem.SELECT:
				{
					dispatchEvent( event );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}