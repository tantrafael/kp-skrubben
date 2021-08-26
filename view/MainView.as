package kp.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import kp.Main;
	import kp.server.ServerConnection;

	//-------------------------------------------------------------------------
	// MainView
	//-------------------------------------------------------------------------
	public class MainView extends Main
	{
		//---------------------------------------------------------------------
		public function MainView():void
		{
		//	serverConnection.LoadInitialData( 0 );
			serverConnection.Initialize( user, ServerConnection.VIEW );

			var roomBrowserDisplay:Sprite = new Sprite();
			var mapDisplay:Sprite = new Sprite();

			mapDisplay.x = 18;
			mapDisplay.y = 280;

			addChild( mapDisplay );
			addChild( roomBrowserDisplay );

			roomBrowser.Embody( roomBrowserDisplay );

			map.Embody( mapDisplay );
		}

		//---------------------------------------------------------------------
		override protected function Destroy( event:Event = null ):void
		{}
	}
}