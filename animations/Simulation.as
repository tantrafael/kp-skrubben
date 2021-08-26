package kp.animations
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	//-------------------------------------------------------------------------
	// Simulation
	//-------------------------------------------------------------------------
	public class Simulation extends StateAnimation
	{
		protected var updateTimer:Timer = null;
		protected var P:Point = null;

		//---------------------------------------------------------------------
		public function Simulation():void
		{}

		//---------------------------------------------------------------------
	//	override public function Initialize( bounds:Rectangle = null ):void
		override public function Initialize( position:Point = null, bounds:Rectangle = null ):void
		{
		//	super.Initialize( bounds );
			super.Initialize( position, bounds );
			updateTimer = new Timer( 10 );
			updateTimer.addEventListener( TimerEvent.TIMER, Update );
			P = new Point();

		/*
			if( position != null )
			{
				P = position.clone();
			}
		*/
		}

	/*
		//---------------------------------------------------------------------
		override protected function StartActivity():void
		{
			super.StartActivity();
		}
	*/

		//---------------------------------------------------------------------
		override protected function StopActivity():void
		{
			super.StopActivity();
			StopSimulation();
			P.x = P.y = 0;
			Render();
		}

		//---------------------------------------------------------------------
		protected function StartSimulation():void
		{
			if( updateTimer.running == false )
			{
				updateTimer.start();
			}

			if( hasEventListener( Event.ENTER_FRAME ) == false )
			{
				addEventListener( Event.ENTER_FRAME, Render );
			}
		}

		//---------------------------------------------------------------------
		protected function StopSimulation():void
		{
			if( updateTimer.running == true )
			{
				updateTimer.stop();
			}

			if( hasEventListener( Event.ENTER_FRAME ) == true )
			{
				removeEventListener( Event.ENTER_FRAME, Render );
			}
		}

		//---------------------------------------------------------------------
		protected function Update( event:Event = null ):void
		{
		//	CheckBounds();
		}

		//---------------------------------------------------------------------
		protected function Render( event:Event = null ):void
		{
			this.x = P.x;
			this.y = P.y;
		}

		//---------------------------------------------------------------------
		override protected function Destroy():void
		{
			super.Destroy();
		}
	}
}