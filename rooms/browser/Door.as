package kp.rooms.browser
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import animation.sliding.Slider;
	import animation.sliding.SpringPositionSlider;
//	import kp.VisualObject;

	//-------------------------------------------------------------------------
	// Door
	//-------------------------------------------------------------------------
	public class Door extends EventDispatcher
//	public class Door extends VisualObject
	{
		public static const SELECT:String = "select";
		public static const ENABLED:int = 0;
		public static const DISABLED:int = 1;
		protected var state:int = -1;
		protected var subjectDisplay:Sprite = null;
		protected var arrow:Sprite = null;
		protected var objectDisplay:Sprite = null;
		private var P0:Point = null;
		protected var P1:Point = null;
		protected var slider:SpringPositionSlider = null;

		//---------------------------------------------------------------------
		public function Door( objectDisplay:Sprite, position:Point, direction:Point, index:int ):void
	//	public function Door( position:Point, direction:Point, index:int ):void
		{
			this.objectDisplay = objectDisplay;
			subjectDisplay = new Sprite();

			P0 = new Point();
			P1 = new Point();
			P0.x = Math.round( position.x - 25 * direction.x );
			P0.y = Math.round( position.y - 25 * direction.y );
			P1.x = Math.round( position.x + 27 * direction.x );
			P1.y = Math.round( position.y + 27 * direction.y );

			slider = new SpringPositionSlider( 0.06, 1, 0.3 );
		//	slider.addEventListener( Slider.UPDATE, HandleSliderUpdate );
			slider.addEventListener( Slider.STOP, HandleSliderStop );
			slider.Position = P0;

		//	subjectDisplay.addEventListener( Event.ENTER_FRAME, Render );

			switch( index )
			{
				case 0:
				{
					arrow = new Right();
					break;
				}

				case 1:
				{
					arrow = new Up();
					break;
				}

				case 2:
				{
					arrow = new Left();
					break;
				}

				case 3:
				{
					arrow = new Down();
					break;
				}
			}

			subjectDisplay.addChild( arrow );
		}

		//---------------------------------------------------------------------
		public function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

				switch( state )
				{
					case ENABLED:
					{
						Enable();
						break;
					}

					case DISABLED:
					{
						Disable();
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		public function Appear():void
		{
			if( state == ENABLED )
			{
				if( !objectDisplay.contains( subjectDisplay ) )
				{
					objectDisplay.addChild( subjectDisplay );
				}

				subjectDisplay.addEventListener( Event.ENTER_FRAME, Render );
				slider.Slide( P1 );
			}
		}

		//---------------------------------------------------------------------
		public function Disappear():void
		{
			subjectDisplay.addEventListener( Event.ENTER_FRAME, Render );
			slider.Slide( P0 );
		}

		//---------------------------------------------------------------------
		public function HitTest( object:DisplayObject ):Boolean
		{
			return object.hitTestObject( subjectDisplay );
		}

		//---------------------------------------------------------------------
		protected function Enable():void
		{
			subjectDisplay.buttonMode = true;
			subjectDisplay.addEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );
		}

		//---------------------------------------------------------------------
		protected function Disable():void
		{
			subjectDisplay.buttonMode = false;
			subjectDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );

			if( objectDisplay.contains( subjectDisplay ) )
			{
				Disappear();
			}
		}

	/*
		//---------------------------------------------------------------------
		private function HandleSliderUpdate( event:Event ):void
		{
			subjectDisplay.x = slider.Position.x;
			subjectDisplay.y = slider.Position.y;
		}
	*/

		//---------------------------------------------------------------------
		protected function Render( event:Event = null ):void
		{
			subjectDisplay.x = slider.Position.x;
			subjectDisplay.y = slider.Position.y;
		}

		//---------------------------------------------------------------------
		private function HandleSliderStop( event:Event ):void
		{
			subjectDisplay.removeEventListener( Event.ENTER_FRAME, Render );
			Render();

			if( slider.Position.equals( P0 ) )
			{
				HandleDisappeared();
			}
		}

		//---------------------------------------------------------------------
		protected function HandleDisappeared():void
		{
			if( objectDisplay.contains( subjectDisplay ) )
			{
				objectDisplay.removeChild( subjectDisplay );
			}
		}

		//---------------------------------------------------------------------
		protected function HandleMouseEvent( event:MouseEvent ):void
		{
			switch( event.type )
			{
				case MouseEvent.MOUSE_DOWN:
				{
					dispatchEvent( new Event( SELECT ) );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		public function Destroy():void
	//	override public function Destroy():void
		{}
	}
}