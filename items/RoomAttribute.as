package kp.items
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import kp.items.ItemData;
	import kp.animations.Animation;
	import kp.rooms.browser.Room;

	//-------------------------------------------------------------------------
	// RoomAttribute
	//-------------------------------------------------------------------------
	public class RoomAttribute extends ItemEdit
	{
		public static const MOVE:String = "move";
		public static const REMOVE:String = "remove";
		private const BOUNDS_MARGIN:int = 15;
		private const BOUNDS_EXCESS:Number = 0.25;
		private var state:int = -1;
		private var userInterface:Sprite = new Sprite();
		private var bounds:Rectangle = null;
		private var grabPos:Point = new Point();
		private var D:Point = new Point();
		private var P:Point = new Point();

		//---------------------------------------------------------------------
		public function RoomAttribute( itemData:ItemData ):void
		{
			super( itemData );
		}

		//---------------------------------------------------------------------
		public function get Position():Point
		{
			return position.clone();
		}

		//---------------------------------------------------------------------
		override protected function HandleContent( event:Event ):void
		{
			HandleContentType( event );
			subjectDisplay.addChild( content );

			if( contentType == ANIMATION )
			{
				var animation:Animation = Animation( content );
				animation.Initialize( position, Room.BOUNDS );
			}

			var removeButton:Sprite = new RemoveButton();
			var clickArea:SimpleButton = SimpleButton( removeButton.getChildByName( "clickArea" ) );
			clickArea.addEventListener( MouseEvent.MOUSE_DOWN, Remove );

			var rect:Rectangle = content.getBounds( content );
			userInterface = new Sprite();
			userInterface.x = rect.x;
			userInterface.y = rect.y;
			userInterface.addChild( removeButton );

			bounds = Room.BOUNDS.clone();

			var overflow:Point = new Point();
			overflow.x = BOUNDS_EXCESS * rect.width  - BOUNDS_MARGIN;
			overflow.y = BOUNDS_EXCESS * rect.height - BOUNDS_MARGIN;
			bounds.left   -= overflow.x;
			bounds.right  += overflow.x;
			bounds.top    -= overflow.y;
			bounds.bottom += overflow.y;

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
					case 0:
					{
						ActivateContent();
						subjectDisplay.buttonMode = false;
						subjectDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, Grab );
						subjectDisplay.removeEventListener( MouseEvent.MOUSE_OVER, ShowInterface );
						subjectDisplay.removeEventListener( MouseEvent.MOUSE_OUT, HideInterface );

						if( subjectDisplay.contains( userInterface ) )
						{
							subjectDisplay.removeChild( userInterface );
						}

						break;
					}

					case 1:
					{
						DeactivateContent();
						subjectDisplay.buttonMode = true;
						subjectDisplay.addEventListener( MouseEvent.MOUSE_DOWN, Grab );
						subjectDisplay.addEventListener( MouseEvent.MOUSE_OVER, ShowInterface );
						subjectDisplay.addEventListener( MouseEvent.MOUSE_OUT, HideInterface );

						if( !subjectDisplay.contains( userInterface ) )
						{
							HideInterface();
							subjectDisplay.addChild( userInterface );
						}

						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		override public function Embody( objectDisplay:Sprite, depth:int = -1 ):void
		{
			super.Embody( objectDisplay, depth );
			var rect:Rectangle = content.getBounds( objectDisplay );
			D.x = rect.left + 0.5 * rect.width  - subjectDisplay.x;
			D.y = rect.top  + 0.5 * rect.height - subjectDisplay.y;
			P.x = position.x;
			P.y = position.y;
			BoundPosition( P );
			position.x = subjectDisplay.x;
			position.y = subjectDisplay.y;
			itemData.Position = position;
		}

		//---------------------------------------------------------------------
		private function Grab( event:MouseEvent ):void
		{
			content.alpha = 0.65;
			subjectDisplay.removeEventListener( MouseEvent.MOUSE_OUT, HideInterface );

			grabPos.x = event.localX;
			grabPos.y = event.localY;

			objectDisplay.stage.addEventListener( MouseEvent.MOUSE_MOVE, Drag );
			objectDisplay.stage.addEventListener( MouseEvent.MOUSE_UP, Release );
		
			if( objectDisplay )
			{
				objectDisplay.addChild( subjectDisplay );
			}
		}

		//---------------------------------------------------------------------
		private function Release( event:MouseEvent ):void
		{
			content.alpha = 1;
			subjectDisplay.addEventListener( MouseEvent.MOUSE_OUT, HideInterface );

			objectDisplay.stage.removeEventListener( MouseEvent.MOUSE_MOVE, Drag );
			objectDisplay.stage.removeEventListener( MouseEvent.MOUSE_UP, Release );

			position.x = subjectDisplay.x;
			position.y = subjectDisplay.y;
			itemData.Position = position;
			dispatchEvent( new Event( MOVE ) );
		}

		//---------------------------------------------------------------------
		private function Drag( event:MouseEvent ):void
		{
			P.x = event.stageX - grabPos.x;
			P.y = event.stageY - grabPos.y;
			BoundPosition( P );
		}

		//---------------------------------------------------------------------
		private function BoundPosition( P:Point ):void
		{
			if( P.x + D.x < bounds.left )
			{
				P.x = bounds.left - D.x;
			}
			else if( P.x + D.x > bounds.right )
			{
				P.x = bounds.right - D.x;
			}

			if( P.y + D.y < bounds.top )
			{
				P.y = bounds.top - D.y;
			}
			else if( P.y + D.y > bounds.bottom )
			{
				P.y = bounds.bottom - D.y;
			}

			subjectDisplay.x = P.x;
			subjectDisplay.y = P.y;
		}

		//---------------------------------------------------------------------
		private function Remove( event:MouseEvent ):void
		{
		//	Destroy();
			itemData.Active = false;
			dispatchEvent( new Event( REMOVE ) );
		}

		//---------------------------------------------------------------------
		private function ActivateContent():void
		{
			if( content != null )
			{
				switch( contentType )
				{
					case ANIMATION:
					{
						Animation( content ).Activate();
						break;
					}

					case MOVIE_CLIP:
					{
						MovieClip( content ).play();
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		private function DeactivateContent():void
		{
			if( content != null )
			{
				switch( contentType )
				{
					case ANIMATION:
					{
						Animation( content ).Deactivate();
						break;
					}

					case MOVIE_CLIP:
					{
						MovieClip( content ).stop();
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		private function ShowInterface( event:MouseEvent = null ):void
		{
			userInterface.alpha = 1;
		}

		//---------------------------------------------------------------------
		private function HideInterface( event:MouseEvent = null ):void
		{
			userInterface.alpha = 0;
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			subjectDisplay.buttonMode = false;
			subjectDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, Grab );
			super.Destroy();
		}
	}
}