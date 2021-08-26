package kp.animations.balls.fotboll
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kp.animations.balls.Ball;

	//-------------------------------------------------------------------------
	// Fotboll
	//-------------------------------------------------------------------------
	public class Fotboll extends Ball
	{
		//---------------------------------------------------------------------
		public function Fotboll():void
		{
			gravity = 1;
			elasticity = 0.9;
			f_translation = 0.01;
			spinFactor = 4;
			radius = 16;
		}

	/*
		//---------------------------------------------------------------------
		override protected function Impulse():void
		{
			V.x = 6 * ( 1 - 2 * Math.random() );
			V.y = -10 - 15 * Math.random();
		}
	*/

		//---------------------------------------------------------------------
		override protected function GetAnimation( id:int ):MovieClip 
		{
			return new Rest();
		}
	}
}