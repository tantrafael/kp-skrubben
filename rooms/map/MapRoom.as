package kp.rooms.map
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import kp.VisualObject;
	import kp.rooms.RoomData;

	//-------------------------------------------------------------------------
	// MapRoom
	//-------------------------------------------------------------------------
	public class MapRoom extends VisualObject
	{
		public static const READY:String = "ready";
		public static const SIZE:Point = new Point( 42, 22 );
	//	private var roomData:RoomData = null;
		private var imageDisplay:Sprite = null;
		private var backgroundDisplay:Sprite = null;
		private var displayPosition:Point = null;
		private const inactiveColor:int = 0x204060;
		private const activeColor:int = 0xFFFF00;
		private var inactiveColorTransform:ColorTransform = null;
		private var activeColorTransform:ColorTransform = null;

		//---------------------------------------------------------------------
		public function MapRoom( roomData:RoomData ):void
	//	public function MapRoom():void
		{
		//	this.roomData = roomData;

			inactiveColorTransform = new ColorTransform();
			activeColorTransform   = new ColorTransform();
			inactiveColorTransform.color = inactiveColor;
			activeColorTransform.color = activeColor;

			subjectDisplay = new MapRoomDisplay();
			imageDisplay = Sprite( subjectDisplay.getChildByName( "image" ) );
			backgroundDisplay = Sprite( subjectDisplay.getChildByName( "background" ) );

			displayPosition = new Point( SIZE.x * roomData.Position.x, SIZE.y * roomData.Position.y );
			subjectDisplay.x = displayPosition.x;
			subjectDisplay.y = displayPosition.y;
			Deactivate();
		}

		//---------------------------------------------------------------------
		public function get DisplayPosition():Point
		{
			return displayPosition.clone();
		}

		//---------------------------------------------------------------------
	//	public function Activate():void
		public function Activate( image:Bitmap ):void
		{
			if( image != null )
			{
				imageDisplay.addChild( image );
			}

			backgroundDisplay.transform.colorTransform = activeColorTransform;
		}

		//---------------------------------------------------------------------
		public function Deactivate():void
		{
			if( imageDisplay.numChildren > 0 )
			{
				imageDisplay.removeChildAt( 0 );
			}

			backgroundDisplay.transform.colorTransform = inactiveColorTransform;
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}