package kp.rooms.browser
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;

	//-------------------------------------------------------------------------
	// DoorEdit
	//-------------------------------------------------------------------------
	public class DoorEdit extends Door
	{
		private var content:Sprite = null;
		private var lock:Sprite = null;

		//---------------------------------------------------------------------
		public function DoorEdit( objectDisplay:Sprite, position:Point, direction:Point, index:int ):void
		{
			super( objectDisplay, position, direction, index );
			lock = new Lock();
			content = arrow;
		}

		//---------------------------------------------------------------------
		override public function Appear():void
		{
			if( !objectDisplay.contains( subjectDisplay ) )
			{
				objectDisplay.addChild( subjectDisplay );
			}

			subjectDisplay.addEventListener( Event.ENTER_FRAME, Render );
			slider.Slide( P1 );
		}

		//---------------------------------------------------------------------
		override protected function Enable():void
		{
			SetContent( arrow );
			super.Enable();
		}

		//---------------------------------------------------------------------
		override protected function Disable():void
		{
			subjectDisplay.buttonMode = false;
			subjectDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );
			SetContent( lock );

		/*
			if( objectDisplay.contains( subjectDisplay ) )
			{
				Disappear();
			}
			else
			{
				SetContent( lock );
			}
		*/
		}

	/*
		//---------------------------------------------------------------------
		override protected function HandleDisappeared():void
		{
		//	super.HandleDisappeared();

			if( ( state == DISABLED ) && ( content != lock ) )
			{
				SetContent( lock );
				Appear();
			}
			else
			{
				super.HandleDisappeared();
			}
		}
	*/

		//---------------------------------------------------------------------
		private function SetContent( sprite:Sprite ):void
		{
			content = sprite;

			if( subjectDisplay.numChildren > 0 )
			{
				if( subjectDisplay.getChildAt( 0 ) != sprite )
				{
					subjectDisplay.removeChildAt( 0 );
				}

				subjectDisplay.addChild( sprite );
			}
			else
			{
				subjectDisplay.addChild( sprite );
			}
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}