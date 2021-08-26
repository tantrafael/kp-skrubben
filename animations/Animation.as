package kp.animations
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//-------------------------------------------------------------------------
	// Animation
	//-------------------------------------------------------------------------
	public class Animation extends MovieClip
	{
		private var active:Boolean = false;
		protected var position:Point = null;
		protected var bounds:Rectangle = null;
		protected var boundingBox:Rectangle = null;

		//---------------------------------------------------------------------
		public function Animation():void
		{
		//	stop();
		}

		//---------------------------------------------------------------------
	//	public function Initialize( bounds:Rectangle = null ):void
		public function Initialize( position:Point = null, bounds:Rectangle = null ):void
		{
			this.position = position;
			this.bounds = bounds;
		//	trace( position );
		}

		//---------------------------------------------------------------------
		public function Activate():void
		{
			SetActivity( true );
		}

		//---------------------------------------------------------------------
		public function Deactivate():void
		{
			SetActivity( false );
		}

		//---------------------------------------------------------------------
		private function SetActivity( value:Boolean ):void
		{
			if( active != value )
			{
				active = value;

				if( active == true )
				{
					StartActivity();
				}
				else
				{
					StopActivity();
				}
			}
		}

		//---------------------------------------------------------------------
		protected function StartActivity():void
		{
		//	play();
		}

		//---------------------------------------------------------------------
		protected function StopActivity():void
		{
		//	stop();
		}

		//---------------------------------------------------------------------
		protected function Destroy():void
		{}
	}
}