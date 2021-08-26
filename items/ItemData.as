package kp.items
{
	import flash.display.Sprite;
	import flash.geom.Point;

	//-------------------------------------------------------------------------
	// ItemData
	//-------------------------------------------------------------------------
	public class ItemData
	{
		public static const BACKGROUND:int = 0;
		public static const ATTRIBUTE:int = 1;
		public static const KEY:int = 2;
		private var id:int = -1;
		private var itemId:int = -1;
		private var type:int = -1;
		private var itemName:String = null;
		private var position:Point = null;
		private var mediaType:int = -1;
		private var mediaUrl:String = null;
		private var active:Boolean = false;

		//---------------------------------------------------------------------
		public function ItemData( id:int, itemId:int, type:int, itemName:String, position:Point, mediaType:int, mediaUrl:String, active:Boolean ):void
		{
			this.id = id;
			this.itemId = itemId;
			this.type = type;
			this.itemName = itemName;
			this.position = position;
			this.mediaType = mediaType;
			this.mediaUrl = mediaUrl;
			this.active = active;
		}

		//---------------------------------------------------------------------
		public function get Id():int
		{
			return id;
		}

		//---------------------------------------------------------------------
		public function get ItemId():int
		{
			return itemId;
		}

		//---------------------------------------------------------------------
		public function get Type():int
		{
			return type;
		}

		//---------------------------------------------------------------------
		public function get Position():Point
		{
			return position;
		}

		//---------------------------------------------------------------------
		public function set Position( value:Point ):void
		{
			position = value;
		}

		//---------------------------------------------------------------------
		public function get MediaUrl():String
		{
			return mediaUrl;
		}

		//---------------------------------------------------------------------
		public function get Active():Boolean
		{
			return active;
		}

		//---------------------------------------------------------------------
		public function set Active( value:Boolean ):void
		{
			active = value;
		}

		//---------------------------------------------------------------------
		public function Destroy():void
		{}
	}
}