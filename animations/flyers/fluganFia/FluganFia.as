package kp.animations.flyers.fluganFia
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import kp.animations.flyers.Flyer;

	//-------------------------------------------------------------------------
	// FluganFia
	//-------------------------------------------------------------------------
	public class FluganFia extends Flyer
	{
		//---------------------------------------------------------------------
		public function FluganFia():void
		{
			speed = 1;
			f_translation = 0.1;
			radius = 8;
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

				case MOVE:
				{
					animation = new Move();
					break;
				}
			}

			return animation;
		}
	}
}