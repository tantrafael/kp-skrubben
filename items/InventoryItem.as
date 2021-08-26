package kp.items
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
//	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kp.inventory.browser.InventoryLayout;

	//-------------------------------------------------------------------------
	// InventoryItem
	//-------------------------------------------------------------------------
	public class InventoryItem extends ItemEdit
	{
		public static const SELECT:String = "select";
		public static const INACTIVE:int = 0;
		public static const ACTIVE:int = 1;
		private var state:int = -1;
		private var scale:Number = 1;

		//---------------------------------------------------------------------
		public function InventoryItem( itemData:ItemData ):void
		{
			super( itemData );
		}

		//---------------------------------------------------------------------
		public function get AbsolutePosition():Point
		{
			return objectDisplay.localToGlobal( position );
		}

		//---------------------------------------------------------------------
		public function Release():void
		{
			EnterState( INACTIVE );
		}

		//---------------------------------------------------------------------
		override protected function HandleContent( event:Event ):void
		{
			HandleContentType( event );

			var itemSize:Number = Math.max( content.width, content.height );
			var displaySize:Number = InventoryLayout.ITEM_SIZE;
			var matrix:Matrix = new Matrix();

			var bounds:Rectangle = content.getBounds( content );
			matrix.translate( -bounds.x, -bounds.y );

			if( itemSize > displaySize )
			{
				var scale:Number = displaySize / itemSize;
				matrix.scale( scale, scale );
				content.scaleX = content.scaleY = scale;
			}

			var bitmapData:BitmapData = new BitmapData( content.width, content.height, true, 0x00000000 );
			bitmapData.draw( content, matrix );
			var bitmap:Bitmap = new Bitmap( bitmapData );
			bitmap.x = Math.round( -0.5 * bitmap.width );
			bitmap.y = Math.round( -0.5 * bitmap.height );
			subjectDisplay.addChild( bitmap );
		//	content.scaleX = content.scaleY = 1.0;

			dispatchEvent( new Event( READY ) );
		}

		//---------------------------------------------------------------------
		public function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

				switch( state )
				{
					case INACTIVE:
					{
					//	itemData.Active = false;
						subjectDisplay.buttonMode = true;
						subjectDisplay.addEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );
						subjectDisplay.alpha = 1;
						break;
					}

					case ACTIVE:
					{
					//	itemData.Active = true;
						subjectDisplay.buttonMode = false;
						subjectDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );
						subjectDisplay.alpha = 0.5;
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleMouseEvent( event:MouseEvent = null ):void
		{
			switch( event.type )
			{
				case MouseEvent.MOUSE_DOWN:
				{
					EnterState( ACTIVE );
					dispatchEvent( new Event( SELECT ) );
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