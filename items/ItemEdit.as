package kp.items
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.getQualifiedClassName;
	import kp.server.ServerConnection;
	import kp.animations.Animation;

	//-------------------------------------------------------------------------
	// ItemEdit
	//-------------------------------------------------------------------------
	public class ItemEdit extends Item
	{
		protected const MOVIE_CLIP:int = 0;
		protected const ANIMATION:int = 1;
		protected var contentType:int = -1;
		protected var itemData:ItemData = null;

		//---------------------------------------------------------------------
		public function ItemEdit( itemData:ItemData ):void
		{
			super( itemData );
			this.itemData = itemData;
		}

		//---------------------------------------------------------------------
		public function get Data():ItemData
		{
			return itemData;
		}

	/*
		//---------------------------------------------------------------------
		public function get Id():int
		{
			return itemData.Id;
		}
	*/

	/*
		//---------------------------------------------------------------------
		public function get Size():Point
		{
			return new Point( content.width, content.height );
		}
	*/

		//---------------------------------------------------------------------
		public function SetContent( content:DisplayObject, type:int ):void
		{
			subjectDisplay.addChild( content );
		}

		//---------------------------------------------------------------------
		override protected function HandleContent( event:Event ):void
		{
			HandleContentType( event );
			subjectDisplay.addChild( content );
			dispatchEvent( new Event( READY ) );
		}

		//---------------------------------------------------------------------
		protected function HandleContentType( event:Event ):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo( event.target );
			loaderInfo.addEventListener( Event.COMPLETE, HandleContent );
			loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, HandleIOError );
			content = loaderInfo.content;

			if( loaderInfo.contentType == "application/x-shockwave-flash" )
			{
				if( getQualifiedClassName( content ).search( "animations" ) >= 0 )
				{
					contentType = ANIMATION;
				}
				else
				{
					contentType = MOVIE_CLIP;
				}
			}
			else
			{
				Bitmap( content ).smoothing = true;
			}
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}