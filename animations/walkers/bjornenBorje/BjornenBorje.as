package kp.animations.walkers.bjornenBorje
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import kp.animations.walkers.Walker;

	//-------------------------------------------------------------------------
	// BjornenBorje
	//-------------------------------------------------------------------------
	public class BjornenBorje extends Walker
	{
		//---------------------------------------------------------------------
		public function BjornenBorje():void
		{
			speed = 1;
			radius = 30;
		}

		//---------------------------------------------------------------------
		override protected function GetAnimation( id:int ):MovieClip
		{
			var animation:MovieClip = null;

			switch( id )
			{
				case REST:
				{
					animation = new Rest();
					break;
				}

				case MOVE_LEFT:
				{
					animation = new MoveLeft();
					break;
				}

				case MOVE_RIGHT:
				{
					animation = new MoveRight();
					break;
				}
			}

			return animation;
		}
	}
}