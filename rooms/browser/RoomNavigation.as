package kp.rooms.browser
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import kp.VisualObject;

	//-------------------------------------------------------------------------
	// RoomNavigation
	//-------------------------------------------------------------------------
	public class RoomNavigation extends VisualObject
	{
		private const INDENT:int = 8;
		private const R2:int = 2200;
		private const SIZE:Point = new Point( 570, 286 );
		private const N:int = 4;
		private var positions:Array = null;
		protected var doors:Array = null;
		private var clickedDoor:Door = null;
		private var activeIndex:int = -1;
		private var activeDoor:Door = null;
		private var i:int = 0;
		private var P:Point = null;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var d2:Number = 0;

		//---------------------------------------------------------------------
		public function RoomNavigation():void
		{
			subjectDisplay = new Sprite();

			var names:Array = new Array( "right", "top", "left", "bottom" );
			var center:Point = new Point( 0.5 * SIZE.x, 0.5 * SIZE.y );

			var directions:Array = new Array( N );
			directions[ 0 ] = new Point( -1,  0  );
			directions[ 1 ] = new Point(  0,  1  );
			directions[ 2 ] = new Point(  1,  0  );
			directions[ 3 ] = new Point(  0, -1  );

			positions = new Array( N );
			positions[ 0 ] = new Point( SIZE.x - INDENT, center.y );
			positions[ 1 ] = new Point( center.x, INDENT );
			positions[ 2 ] = new Point( INDENT, center.y );
			positions[ 3 ] = new Point( center.x, SIZE.y - INDENT );

			doors = new Array( N );
			var door:Door = null;

			for( var i:int = 0; i < N; i++ )
			{
				door = CreateDoor( subjectDisplay, positions[ i ], directions[ i ], i );
				door.addEventListener( Door.SELECT, HandleDoorEvent );
				doors[ i ] = door;
			}

			subjectDisplay.addEventListener( Event.ADDED_TO_STAGE, HandleStage );
		}

		//---------------------------------------------------------------------
		protected function CreateDoor( objectDisplay:Sprite, position:Point, direction:Point, index:int ):Door
	//	protected function CreateDoor():Door
		{
			return new Door( objectDisplay, position, direction, index );
		}

		//---------------------------------------------------------------------
		private function HandleStage( event:Event ):void
		{
			subjectDisplay.removeEventListener( Event.ADDED_TO_STAGE, HandleStage );
			subjectDisplay.stage.addEventListener( MouseEvent.MOUSE_MOVE, HandleMouseEvent );
		}

		//---------------------------------------------------------------------
	//	private function HandleMouseEvent( event:MouseEvent ):void
		protected function HandleMouseEvent( event:MouseEvent ):void
		{
			i = 0;
			d2 = R2 + 1;
			
			while( ( d2 > R2 ) && ( i < N ) )
			{
				P = positions[ i ];
				dx = event.stageX - P.x;
				dy = event.stageY - P.y;
				d2 = dx * dx + dy * dy;

				if( d2 <= R2 )
				{
					if( activeIndex != i )
					{
						activeIndex = i;
						Door( doors[ i ] ).Appear();
					}

					break;
				}

				i++;
			}

			if( ( d2 > R2 ) && activeIndex >= 0 )
			{
				Door( doors[ activeIndex ] ).Disappear();
				activeIndex = -1;
			}
		}

	/*
		//---------------------------------------------------------------------
		private function ActivateDoor( index:int ):void
		{
			if( activeDoor != null )
			{
				activeDoor.Disappear();
			}
		}
	*/

		//---------------------------------------------------------------------
		private function HandleDoorEvent( event:Event ):void
		{
			switch( event.type )
			{
				case Door.SELECT:
				{
					clickedDoor = Door( event.target );
					dispatchEvent( event );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		public function Update( array:Array ):void
		{
			var door:Door = null;

			for( var i:int = 0; i < array.length; i++ )
			{
				door = doors[ i ];

				if( array[ i ] > 0 )
				{
					door.EnterState( Door.ENABLED );
				}
				else
				{
					door.EnterState( Door.DISABLED );
				}
			}
		}

		//---------------------------------------------------------------------
		public function GetRequestedDirection():int
		{
			return doors.indexOf( clickedDoor );
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}