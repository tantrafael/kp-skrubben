package kp.items
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Iterator;
	import kp.server.ServerConnection;

	//-------------------------------------------------------------------------
	// ItemManager
	//-------------------------------------------------------------------------
	public class ItemManager extends EventDispatcher
	{
		public static const BACKGROUND:String = "background";
		public static const ATTRIBUTE:String = "attribute";
		public static const KEY:String = "key";
		public static const UPDATED:String = "updated";
	//	public static const POPULATED:String = "populated";
		private static const INSTANCE:ItemManager = new ItemManager();
		private const typeNames:Array = new Array( "Skrubb bakgrund", "Skrubb attribut", "Skrubb nyckel" );
		private var items:HashMap = null;
		private var collections:Array = null;
		private var serverConnection:ServerConnection = ServerConnection.Instance;

		//---------------------------------------------------------------------
		public function ItemManager():void
		{
			if( INSTANCE != null )
			{
				throw new Error( "An instance of ItemManager already exists." );
			}
			else
			{
				Initialize();
			}
		}

		//---------------------------------------------------------------------
		public static function get Instance():ItemManager
		{
			return INSTANCE;
		}

		//---------------------------------------------------------------------
		private function Initialize():void
		{
		//	trace( "ItemManager::Initialize()" );
			items = new HashMap( 100 );

			var N:int = typeNames.length;
			collections = new Array( N );

			for( var i:int = 0; i < N; i++ )
			{
				collections[ i ] = new SLinkedList();
			}

			serverConnection.addEventListener( ServerConnection.DATA_RECEIVED, HandleData );

			if( serverConnection.PendingInventoryData() )
			{
			//	Populate();
				HandleData();
			}
			else
			{
			//	serverConnection.addEventListener( ServerConnection.DATA_RECEIVED, Populate );
			}
		}

	/*
		//---------------------------------------------------------------------
		private function Populate( event:Event = null ):void
		{
			serverConnection.removeEventListener( ServerConnection.DATA_RECEIVED, Populate );
			HandleData();
			dispatchEvent( new Event( POPULATED ) );
		}

		//---------------------------------------------------------------------
		private function Update( event:Event = null ):void
		{
			serverConnection.removeEventListener( ServerConnection.DATA_RECEIVED, Update );
			HandleData();
			dispatchEvent( new Event( UPDATED ) );
		}
	*/

		//---------------------------------------------------------------------
		public function Populated():Boolean
		{
			return ( items.size > 0 );
		}

		//---------------------------------------------------------------------
		public function GetItem( id:int ):ItemData
		{
			return items.find( id );
		}

		//---------------------------------------------------------------------
		public function GetItems( type:int ):SLinkedList
		{
			return collections[ type ];
		}

		//---------------------------------------------------------------------
		public function RemoveItem( id:int ):Boolean
		{
			var itemData:ItemData = items.remove( id );
			return ( itemData != null );
		}

		//---------------------------------------------------------------------
		private function HandleData( event:Event = null ):void
		{
		//	trace( "ItemManager::HandleData()" );

			var xmlList:XMLList = serverConnection.RetrieveInventoryData();
			var id:int = 0;
			var itemId:int = 0;
			var type:int = -1;
			var itemName:String = null;
			var position:Point = null;
			var mediaType:int = -1;
			var mediaUrl:String = null;
			var active:Boolean = false;
			var itemData:ItemData = null;
			var collection:SLinkedList = null;

			for each( var item:XML in xmlList )
			{
				position = new Point();

				id         = item.id.text();
				itemId     = item.item_id.text();
				type       = typeNames.indexOf( String( item.type.text() ) );
				itemName   = item.name.text();
				position.x = item.x.text();
				position.y = item.y.text();
				mediaType  = item.media_type.text();
				mediaUrl   = item.media_src.text();
			//	active     = ( item.active.text() == "0" ? false : true );
				active     = false;

				itemData = new ItemData( id, itemId, type, itemName, position, mediaType, mediaUrl, active );
				items.insert( id, itemData );

				collection = collections[ type ];
				collection.append( itemData );
			}

		//	trace( items.dump() );

			dispatchEvent( new Event( UPDATED ) );
		}

		//---------------------------------------------------------------------
		public function Destroy():void
		{}
	}
}