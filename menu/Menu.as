package kp.menu
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kp.VisualObject;
	import kp.TextButton;

	//-------------------------------------------------------------------------
	// Menu
	//-------------------------------------------------------------------------
	public class Menu extends VisualObject
	{
		public static const SELECT_STATE:String = "selectState";
		private const BUTTON_SPACE:int = 6;
		private var state:int = -1;
		private var menuButtons:Array = null;
		private var selectedState:int = -1;

		//---------------------------------------------------------------------
		public function Menu():void
		{
			subjectDisplay = new Sprite();

			var buttonTexts:Array = new Array( "Karta", "Förråd" );
			menuButtons = new Array( buttonTexts.length );
			var i:int = 0;
			var menuButton:TextButton = null;
			var P:Point = new Point( 0, 0 );

			for( i = 0; i < buttonTexts.length; i++ )
			{
				menuButton = new TextButton( buttonTexts[ i ] );
				menuButton.x = P.x;
				menuButton.y = P.y;
				menuButton.addEventListener( TextButton.SELECT, HandleMenuButtonEvent );
				subjectDisplay.addChild( menuButton );
				P.x += menuButton.width + BUTTON_SPACE;
				menuButtons[ i ] = menuButton;
			}
		}

		//---------------------------------------------------------------------
		public function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				var menuButton:TextButton = null;

				if( this.state >= 0 )
				{
					menuButton = menuButtons[ this.state ];
					menuButton.Enable();
				}

				this.state = state;
				menuButton = menuButtons[ state ];
				menuButton.Disable();
			}
		}

		//---------------------------------------------------------------------
		private function HandleMenuButtonEvent( event:Event ):void
		{
			var menuButton:TextButton = TextButton( event.target );
			selectedState = menuButtons.indexOf( menuButton );
			dispatchEvent( new Event( SELECT_STATE ) );
		}

		//---------------------------------------------------------------------
		public function GetSelectedState():int
		{
			return selectedState;
		}

		//---------------------------------------------------------------------
		override public function Destroy():void
		{
			super.Destroy();
		}
	}
}