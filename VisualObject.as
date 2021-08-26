package kp
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	//-------------------------------------------------------------------------
	// VisualObject
	//-------------------------------------------------------------------------
	public class VisualObject extends EventDispatcher
	{
		protected var objectDisplay:Sprite = null;
		protected var subjectDisplay:Sprite = null;

		//---------------------------------------------------------------------
		public function VisualObject():void
		{}

		//---------------------------------------------------------------------
		public function Embody( objectDisplay:Sprite, depth:int = -1 ):void
		{
			if( objectDisplay != null )
			{
				this.objectDisplay = objectDisplay;

				if( depth >= 0 )
				{
					objectDisplay.addChildAt( subjectDisplay, depth );
				}
				else
				{
					objectDisplay.addChild( subjectDisplay );
				}
			}
		}

		//---------------------------------------------------------------------
		public function Disembody():void
		{
			if( objectDisplay )
			{
				if( subjectDisplay && objectDisplay.contains( subjectDisplay ) )
				{
					objectDisplay.removeChild( subjectDisplay );
				}

				objectDisplay = null;
			}
		}

		//---------------------------------------------------------------------
		public function Destroy():void
		{
			Disembody();
		}
	}
}