package kp.rooms.browser
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;

	//-------------------------------------------------------------------------
	// RoomNavigationEdit
	//-------------------------------------------------------------------------
	public class RoomNavigationEdit extends RoomNavigation
	{
		private var state:int = -1;

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
						if( subjectDisplay.stage )
						{
							subjectDisplay.stage.addEventListener( MouseEvent.MOUSE_MOVE, HandleMouseEvent );
						}

						break;
					}

					case 1:
					{
						if( subjectDisplay.stage )
						{
							subjectDisplay.stage.removeEventListener( MouseEvent.MOUSE_MOVE, HandleMouseEvent );
						}

						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		override protected function CreateDoor( objectDisplay:Sprite, position:Point, direction:Point, index:int ):Door
		{
			return new DoorEdit( objectDisplay, position, direction, index );
		}

		//---------------------------------------------------------------------
		public function HitTestDirection( object:DisplayObject ):int
		{
			var hit:Boolean = false;
			var i:int = 0;
			var door:Door = null;

			while( !hit && ( i < 4 ) )
			{
				door = doors[ i ];

				if( door.HitTest( object ) )
				{
					hit = true;
				}
				else
				{
					i++;
				}
			}

			if( hit )
			{
				return i;
			}
			else
			{
				return -1;
			}
		}
	}
}