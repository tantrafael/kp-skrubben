package kp.animations.balls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import kp.animations.Simulation;

	//-------------------------------------------------------------------------
	// Ball
	//-------------------------------------------------------------------------
	public class Ball extends Simulation
	{
		protected var gravity:Number = 1;
		protected var elasticity:Number = 0.9;
		protected var f_translation:Number = 0.1;
		protected var spinFactor:Number = 4;
		protected var radius:Number = 16;
		private var V:Point = null;
		private var F:Point = null;
		private var a:Number = 0;
		private var w:Number = 0;
		private var energy:Number = 0;

		//---------------------------------------------------------------------
		public function Ball():void
		{}

		//---------------------------------------------------------------------
		override public function Initialize( position:Point = null, bounds:Rectangle = null ):void
		{
			super.Initialize( position, bounds );
			V = new Point();
			F = new Point();
		}

		//---------------------------------------------------------------------
		override protected function StartActivity():void
		{
			super.StartActivity();
		}

		//---------------------------------------------------------------------
		override protected function StopActivity():void
		{
			V.x = V.y = 0;
			F.x = F.y = 0;
			a = w = 0;
			super.StopActivity();
		}

		//---------------------------------------------------------------------
		override protected function EnterStateRest():void
		{
			super.EnterStateRest();
			StopSimulation();
			V.x = V.y = 0;
			F.x = F.y = 0;
			SetActionTimer( 1000 + Math.random() * 5000 );
		}

		//---------------------------------------------------------------------
		override protected function EnterStateMove():void
		{
			super.EnterStateMove();
			Impulse();
			StartSimulation();
		}

		//---------------------------------------------------------------------
		override protected function HandleMouseClick( event:MouseEvent ):void 
		{
			super.HandleMouseClick( event );
			Impulse();
		}

		//---------------------------------------------------------------------
		protected function Impulse():void
		{
			V.x = 6 * ( 1 - 2 * Math.random() );
			V.y = -10 - 15 * Math.random();
		}

		//---------------------------------------------------------------------
		override protected function Update( event:Event = null ):void 
		{
			F.x = -f_translation * V.x;
			F.y = gravity - f_translation * V.y;

			V.x += F.x;
			V.y += F.y;

			P.x += V.x;
			P.y += V.y;

			w = spinFactor * V.x;
			a += w;

			if( P.y > -1 )
			{
				energy = V.x * V.x + V.y * V.y;

				if( energy < 0.285 )
				{
					EnterState( REST );
					Render();
					V.x = V.y = 0;
					w = 0;
				}
				if( P.y >= 0 )
				{
					P.y = 0;
					V.y = -elasticity * V.y;
				}
			}

			if( P.x < bounds.left - parent.x + radius )
			{
				P.x = bounds.left - parent.x + radius;
				V.x = -elasticity * V.x;
			}
			else if( P.x > bounds.right - parent.x - radius )
			{
				P.x = bounds.right - parent.x - radius;
				V.x = -elasticity * V.x;
			}
		}

		//---------------------------------------------------------------------
		override protected function Render( event:Event = null ):void
		{
			super.Render();
			this.rotation = a;
		}

		//---------------------------------------------------------------------
		override protected function Destroy():void
		{
			super.Destroy();
		}
	}
}