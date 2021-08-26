package kp.animations.walkers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import kp.animations.Simulation;

	//-------------------------------------------------------------------------
	// Walker
	//-------------------------------------------------------------------------
	public class Walker extends Simulation
	{
		protected const MOVE_LEFT:int = 1;
		protected const MOVE_RIGHT:int = 2;
		protected var radius:Number = 10;
		protected var speed:Number = 1;
		private var V:Point = null;

		//---------------------------------------------------------------------
		public function Walker():void
		{}

		//---------------------------------------------------------------------
		override public function Initialize( position:Point = null, bounds:Rectangle = null ):void
		{
			super.Initialize( position, bounds );
			V = new Point();
		}

		//---------------------------------------------------------------------
		override protected function StartActivity():void
		{
			super.StartActivity();
		}

		//---------------------------------------------------------------------
		override protected function StopActivity():void
		{
			super.StopActivity();
		}

		//---------------------------------------------------------------------
		override protected function EnterStateRest():void
		{
			super.EnterStateRest();
			StopSimulation();
			DisplayAnimation( REST );
			SetActionTimer( 1000 + Math.random() * 5000 );
		}

		//---------------------------------------------------------------------
		override protected function EnterStateMove():void
		{
			super.EnterStateMove();
			StartSimulation();

			if( Math.random() < 0.5 )
			{
				Walk( -1 );
			}
			else
			{
				Walk( 1 );
			}

			SetActionTimer( 1000 + Math.random() * 5000 );
		}

		//---------------------------------------------------------------------
		protected function Walk( direction:int ):void
		{
			if( direction > 0 )
			{
				V.x = speed;
				DisplayAnimation( MOVE_RIGHT );
			}
			else
			{
				V.x = -speed;
				DisplayAnimation( MOVE_LEFT );
			}
		}

		//---------------------------------------------------------------------
		override protected function Update( event:Event = null ):void
		{
			P.x += V.x;

			if( ( P.x < bounds.left - parent.x + radius ) && ( V.x < 0 ) )
			{
				Walk( 1 );
			}
			else if( ( P.x > bounds.right - parent.x - radius ) && ( V.x > 0 ) )
			{
				Walk( -1 );
			}
		}

		//---------------------------------------------------------------------
		override protected function Destroy():void
		{
			super.Destroy();
		}
	}
}