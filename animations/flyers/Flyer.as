package kp.animations.flyers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import kp.animations.Simulation;

	//-------------------------------------------------------------------------
	// Flyer
	//-------------------------------------------------------------------------
	public class Flyer extends Simulation
	{
		protected const MOVE:int = 1;
	//	private const DEG:Number = 180 / Math.PI;
		protected var speed:Number = 1;
		protected var f_translation:Number = 0.1;
	//	protected var f_rotation:Number = 0.1;
		protected var radius:Number = 10;
		private var V:Point = null;
		private var F:Point = null;
	/*
		private var D:Point = null;
		private var a:Number = 0;
		private var w:Number = 0;
		private var t:Number = 0;
		private var v:Number = 0;
		private var f:Number = 0;
	*/

		//---------------------------------------------------------------------
		public function Flyer():void
		{}

		//---------------------------------------------------------------------
		override public function Initialize( position:Point = null, bounds:Rectangle = null ):void
		{
			super.Initialize( position, bounds );
			V = new Point();
			F = new Point();
		//	D = new Point();
		//	a = 0.5 * Math.PI;
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
			super.StopActivity();
		}

		//---------------------------------------------------------------------
		override protected function EnterStateRest():void
		{
			super.EnterStateRest();
			StopSimulation();
			DisplayAnimation( STATE_REST );
			V.x = V.y = 0;
			F.x = F.y = 0;
			SetActionTimer( 1000 + Math.random() * 5000 );
		}

		//---------------------------------------------------------------------
		override protected function EnterStateMove():void
		{
			super.EnterStateMove();
			DisplayAnimation( STATE_MOVE );
			StartSimulation();
		//	a = Math.random() * 2 * Math.PI;
			SetActionTimer( 1000 + Math.random() * 5000 );
		}

		//---------------------------------------------------------------------
		override protected function Update( event:Event = null ):void 
		{
		/*
			t = 0.05 * ( 1 - 2 * Math.random() ) - f_rotation * w;
			w += t;
			a += w;
			f = 2 * Math.random() - f_translation * v;
			v += f;
			P.x += v * Math.cos( a );
			P.y += v * Math.sin( a );
		*/

			F.x = speed * ( 1 - 2 * Math.random() ) - f_translation * V.x;
			F.y = speed * ( 1 - 2 * Math.random() ) - f_translation * V.y;

			if( P.x < bounds.left - parent.x + radius )
			{
				F.x += speed;
			}
			else if( P.x > bounds.right - parent.x - radius )
			{
				F.x -= speed;
			}

			if( P.y < bounds.top - parent.y + radius )
			{
				F.y += speed;
			}
			else if( P.y > bounds.bottom - parent.y - radius )
			{
				F.y -= speed;
			}

			V.x += F.x;
			V.y += F.y;
			P.x += V.x;
			P.y += V.y;
		}

	/*
		//---------------------------------------------------------------------
		override protected function Render( event:Event = null ):void
		{
			super.Render();
			this.rotation = a * DEG;
		}
	*/

	//---------------------------------------------------------------------
		override protected function Destroy():void
		{
			super.Destroy();
		}
	}
}