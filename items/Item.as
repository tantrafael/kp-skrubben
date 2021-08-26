package kp.items
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
//	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import kp.VisualObject;
	import kp.server.ServerConnection;
	import kp.animations.Animation;
	import kp.rooms.browser.Room;

	//-------------------------------------------------------------------------
	// Item
	//-------------------------------------------------------------------------
//	public class Item extends EventDispatcher
	public class Item extends VisualObject
	{
		public static const READY:String = "ready";
	//	protected var objectDisplay:Sprite = null;
		protected var position:Point = null;
		protected var content:DisplayObject = null;
		private var serverConnection:ServerConnection = ServerConnection.Instance;

		//---------------------------------------------------------------------
		public function Item( itemData:ItemData = null ):void
		{
			position = new Point();
			subjectDisplay = new Sprite();

			var request:URLRequest = new URLRequest( serverConnection.ServerUrl + itemData.MediaUrl );
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, HandleContent );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, HandleIOError );
			loader.load( request );
		}

		//---------------------------------------------------------------------
		public function set Position( value:Point ):void
		{
			if( value )
			{
				position = value.clone();
				subjectDisplay.x = position.x;
				subjectDisplay.y = position.y;

			/*
				if( content != null )
				{
					content.x = position.x;
					content.y = position.y;
				}
			*/
			}
		}

	/*
		//---------------------------------------------------------------------
		public function get Data():ItemData
		{
			return itemData;
		}
	*/

		//---------------------------------------------------------------------
		public function get Content():DisplayObject
		{
			return content;
		}

		//---------------------------------------------------------------------
		protected function HandleContent( event:Event ):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo( event.target );
			loaderInfo.addEventListener( Event.COMPLETE, HandleContent );
			loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, HandleIOError );
			content = loaderInfo.content;

			if( loaderInfo.contentType == "application/x-shockwave-flash" )
			{
				if( getQualifiedClassName( content ).search( "animations" ) >= 0 )
				{
					var animation:Animation = Animation( content );
				//	animation.Initialize();
					animation.Initialize( position, Room.BOUNDS );
					animation.Activate();
				}
			}
			else
			{
				Bitmap( content ).smoothing = true;
			}

			subjectDisplay.addChild( content );
			dispatchEvent( new Event( READY ) );
		}

		//---------------------------------------------------------------------
		protected function HandleIOError( event:IOErrorEvent ):void
		{
			trace( event );
			var loaderInfo:LoaderInfo = LoaderInfo( event.target );
			loaderInfo.addEventListener( Event.COMPLETE, HandleContent );
			loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, HandleIOError );
			dispatchEvent( new Event( READY ) );
		}

	/*
		//---------------------------------------------------------------------
		override public function Embody( objectDisplay:Sprite, depth:int = -1 ):void
		{
			if( objectDisplay != null )
			{
				this.objectDisplay = objectDisplay;

				if( content != null )
				{
					objectDisplay.addChild( content );
				}
			}
		}
	*/

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}