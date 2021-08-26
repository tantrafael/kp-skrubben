package kp.animations
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	//-------------------------------------------------------------------------
	// StateAnimation
	//-------------------------------------------------------------------------
	public class StateAnimation extends Animation
	{
		protected const STATE_REST:int = 0;
		protected const STATE_MOVE:int = 1;
		protected const REST:int = 0;
		protected var state:int = -1;
		protected var animation:MovieClip = null;
		protected var actionTimer:Timer = null;

		//---------------------------------------------------------------------
		public function StateAnimation():void
		{
			DisplayAnimation( REST );

			var rect:Rectangle = this.getBounds( this );
			this.x = -rect.left;
			this.y = -rect.top;
		}

		//---------------------------------------------------------------------
	//	override public function Initialize( bounds:Rectangle = null ):void
		override public function Initialize( position:Point = null, bounds:Rectangle = null ):void
		{
		//	super.Initialize( bounds );
			super.Initialize( position, bounds );
			this.x = this.y = 0;
			actionTimer = new Timer( 1, 1 );
			actionTimer.addEventListener( TimerEvent.TIMER_COMPLETE, HandleActionTimer );
		}

		//---------------------------------------------------------------------
		override protected function StartActivity():void
		{
			super.StartActivity();
			buttonMode = true;
			addEventListener( MouseEvent.MOUSE_DOWN, HandleMouseClick );
			EnterState( STATE_REST );
		//	EnterStateRest();
		}

		//---------------------------------------------------------------------
		override protected function StopActivity():void
		{
			super.StopActivity();
			buttonMode = false;
			StopActionTimer();
			removeEventListener( MouseEvent.MOUSE_DOWN, HandleMouseClick );
			DisplayAnimation( REST );
			state = -1;
		}

		//---------------------------------------------------------------------
		protected function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

				switch( state )
				{
					case STATE_REST:
					{
						EnterStateRest();
						break;
					}

					case STATE_MOVE:
					{
						EnterStateMove();
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		protected function EnterStateRest():void
		{
			StopActionTimer();
		//	DisplayAnimation( STATE_REST );
		}

		//---------------------------------------------------------------------
		protected function EnterStateMove():void
		{
			StopActionTimer();
		//	DisplayAnimation( STATE_MOVE );
		}

		//---------------------------------------------------------------------
		protected function GetAnimation( id:int ):MovieClip
		{
			return null;
		}

		//---------------------------------------------------------------------
		protected function DisplayAnimation( id:int ):void
		{
			if( animation && contains( animation ) )
			{
				removeChild( animation );
				animation = null;
			}

			animation = GetAnimation( id );

			if( animation != null )
			{
				addChild( animation );
			}
		}

		//---------------------------------------------------------------------
		protected function SetActionTimer( time:int ):void
		{
			StopActionTimer();
			actionTimer.delay = time;
			actionTimer.repeatCount = 1;
			actionTimer.start();
		}

		//---------------------------------------------------------------------
		protected function StopActionTimer():void
		{
			if( actionTimer.running )
			{
				actionTimer.stop();
			}
		}

		//---------------------------------------------------------------------
		protected function HandleActionTimer( event:TimerEvent ):void 
		{

			switch( state )
			{
				case STATE_REST:
				{
					EnterState( STATE_MOVE );
					break;
				}

				case STATE_MOVE:
				{
					EnterState( STATE_REST );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		protected function HandleMouseClick( event:MouseEvent ):void 
		{
			EnterState( STATE_MOVE );
		}

		//---------------------------------------------------------------------
		override protected function Destroy():void
		{
			super.Destroy();
		}
	}
}