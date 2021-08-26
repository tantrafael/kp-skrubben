package kp.edit
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kp.items.ItemData;
	import kp.items.Item;
	import kp.items.ItemEdit;
	import kp.Main;
	import kp.server.ServerConnection;
	import kp.menu.Menu;
	import kp.rooms.RoomManager;
	import kp.rooms.RoomData;
	import kp.rooms.browser.Room;
	import kp.rooms.browser.RoomEdit;
	import kp.rooms.browser.RoomBrowser;
	import kp.rooms.browser.RoomBrowserEdit;
	import kp.rooms.browser.RoomLayout;
	import kp.rooms.map.MapEdit;
	import kp.rooms.map.Map;
	import kp.inventory.browser.InventoryBrowser;
	import kp.inventory.browser.Keys;
	import kp.items.ItemManager;
	import kp.items.RoomAttribute;
	import kp.items.InventoryItem;

	//-------------------------------------------------------------------------
	// MainEdit
	//-------------------------------------------------------------------------
	public class MainEdit extends Main
	{
	//	public static const VIEW:int = 0;
	//	public static const EDIT:int = 1;
		private const VIEW:int = 0;
		private const EDIT:int = 1;
		private var state:int = -1;
		private var menu:Menu = null;
		private var keys:Keys = null;
		private var inventoryBrowser:InventoryBrowser = null;
		private var lowerDisplay:Sprite = null;
		private var inventoryItem:InventoryItem = null;
		private var inventoryItemData:ItemData = null;
		private var dragItem:Sprite = null;
		private var content:DisplayObject = null;

		//---------------------------------------------------------------------
		public function MainEdit():void
		{
		//	serverConnection.LoadInitialData( 1 );
			serverConnection.Initialize( user, ServerConnection.EDIT );

			var menuDisplay:Sprite = new Sprite();
			var roomBrowserDisplay:Sprite = new Sprite();
			lowerDisplay = new Sprite();

			menuDisplay.x = 46;
			menuDisplay.y = 290;
			lowerDisplay.x = 18;
			lowerDisplay.y = 280;

			addChild( lowerDisplay );
			addChild( menuDisplay );
			addChild( roomBrowserDisplay );

			menu = new Menu();
			menu.addEventListener( Menu.SELECT_STATE, HandleMenuEvent );
			menu.Embody( menuDisplay );

			keys = new Keys();
			keys.addEventListener( InventoryItem.SELECT, HandleInventoryBrowserEvent );
			keys.Embody( menuDisplay );

			roomBrowser.Embody( roomBrowserDisplay );
			roomBrowser.addEventListener( RoomAttribute.MOVE, HandleAttributeEvent );
			roomBrowser.addEventListener( RoomAttribute.REMOVE, HandleAttributeEvent );

			inventoryBrowser = new InventoryBrowser();
			inventoryBrowser.addEventListener( InventoryItem.SELECT, HandleInventoryBrowserEvent );

			roomManager.addEventListener( RoomManager.DOOR_UNLOCKED, HandleRoomManagerEvent );
			roomManager.addEventListener( RoomManager.ROOM_CREATED, HandleRoomManagerEvent );

			EnterState( VIEW );
		}

		//---------------------------------------------------------------------
		override protected function CreateRoomBrowser():RoomBrowser
		{
			return new RoomBrowserEdit();
		}

		//---------------------------------------------------------------------
		override protected function CreateMap():Map
		{
			return new MapEdit();
		}

		//---------------------------------------------------------------------
		private function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;
				RoomBrowserEdit( roomBrowser ).EnterState( state );
				menu.EnterState( state );

				switch( state )
				{
					case VIEW:
					{
						roomBrowser
						map.Embody( lowerDisplay );
						inventoryBrowser.Disembody();
						break;
					}

					case EDIT:
					{
						map.Disembody();
						inventoryBrowser.Embody( lowerDisplay );
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleMenuEvent( event:Event ):void
		{
			var selectedState:int = menu.GetSelectedState();
			EnterState( selectedState );
		}

		//---------------------------------------------------------------------
		private function HandleAttributeEvent( event:Event ):void
		{
			switch( event.type )
			{
				case RoomAttribute.REMOVE:
				{
					var id:int = RoomBrowserEdit( roomBrowser ).GetRemovedItemId();
					inventoryBrowser.ActivateItem( id );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleInventoryBrowserEvent( event:Event ):void
		{
			inventoryItem = event.target.GetSelectedItem();

			inventoryItemData = inventoryItem.Data;
			var P:Point = inventoryItem.AbsolutePosition;

			dragItem = new Sprite();
			dragItem.x = Math.round( P.x );
			dragItem.y = Math.round( P.y );

			content = inventoryItem.Content;
			content.scaleX = content.scaleY = 1;

			var bounds:Rectangle = content.getBounds( content );
			content.x = Math.round( -bounds.x - 0.5 * bounds.width );
			content.y = Math.round( -bounds.y - 0.5 * bounds.height );

			dragItem.startDrag();
			stage.addEventListener( MouseEvent.MOUSE_UP, HandleRelease );
			dragItem.addChild( content );
			addChild( dragItem );

			if( inventoryItemData.Type != ItemData.KEY )
			{
				dragItem.alpha = 0.65;
			}

			if( inventoryItemData.Type == ItemData.BACKGROUND )
			{
				dragItem.scaleX = dragItem.scaleY = 0.35;
			}
		}

		//---------------------------------------------------------------------
		private function HandleRelease( event:MouseEvent ):void
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP, HandleRelease );
			dragItem.stopDrag();
			removeChild( dragItem );

			var itemUsed:Boolean = false;
			var currentRoom:RoomEdit = RoomEdit( roomBrowser.GetCurrentRoom() );

			if( currentRoom != null )
			{
				switch( inventoryItemData.Type )
				{
					case ItemData.BACKGROUND:
					{
						if( RoomBrowserEdit( roomBrowser ).HitTest( dragItem ) )
						{
						//	var itemData:ItemData = ItemManager.Instance.GetItem( id );
							var background:ItemEdit = ItemEdit( currentRoom.GetBackground() );

							if( background != null )
							{
								inventoryBrowser.ActivateItem( background.Data.Id );
								background.Data.Active = false;
							}

						//	itemManager.Activate();
							currentRoom.SetBackground( inventoryItemData );
							inventoryItemData.Active = true;
							itemUsed = true;
						}

						break;
					}

					case ItemData.ATTRIBUTE:
					{
						if( RoomBrowserEdit( roomBrowser ).HitTest( dragItem ) )
						{
							var P:Point = new Point();
							P.x = dragItem.x + content.x;
							P.y = dragItem.y + content.y;
							currentRoom.AddAttribute( inventoryItem.Data.Id, P );
						//	currentRoom.AddAttribute( content, P );
							inventoryItemData.Active = true;
							itemUsed = true;
						}

						break;
					}

					case ItemData.KEY:
					{
						var direction:int = RoomBrowserEdit( roomBrowser ).Navigation.HitTestDirection( dragItem );

						if( direction >= 0 )
						{
							var id:int = currentRoom.Neighbors[ direction ];

							if( id == 0 )
							{
							//	roomManager.UnlockDoor( currentRoom.Id, direction );
								if( roomManager.UnlockDoor( currentRoom.Id, direction ) )
								{
									keys.RemoveItem( inventoryItemData.Id );
									itemUsed = true;
								}
							}
						}

						break;
					}
				}
			}

			if( !itemUsed )
			{
				inventoryItem.Release();
			}
		}

		//---------------------------------------------------------------------
		private function HandleRoomManagerEvent( event:Event ):void
		{
			var id:int = -1;

			switch( event.type )
			{
				case RoomManager.DOOR_UNLOCKED:
				{
					RoomBrowserEdit( roomBrowser ).UnlockDoor();
					id = roomManager.GetUnlockedRoomId();
					RoomBrowserEdit( roomBrowser ).Display( id );
					break;
				}

				case RoomManager.ROOM_CREATED:
				{
					RoomBrowserEdit( roomBrowser ).UnlockDoor();
					id = roomManager.GetCreatedRoomId();
					RoomBrowserEdit( roomBrowser ).Display( id );
					MapEdit( map ).AddRoom( id );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		override protected function Destroy( event:Event = null ):void
		{}
	}
}