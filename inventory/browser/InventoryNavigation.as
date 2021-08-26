package kp.inventory.browser
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import kp.TextButton;
//	import kp.VisualObject;

	//-------------------------------------------------------------------------
	// InventoryNavigation
	//-------------------------------------------------------------------------
//	public class InventoryNavigation extends VisualObject
	public class InventoryNavigation extends EventDispatcher
	{
		public static const SELECT_TYPE:String = "selectType";
		public static const SELECT_DIRECTION:String = "selectDirection";
		public static const SELECT_PAGE:String = "selectPage";
		private const MAX_PAGE_BUTTONS:int = 29;
		private const BUTTON_SPACE:int = 6;
		private var objectDisplay:Sprite = null;
		private var pagesDisplay:Sprite = null;
		private var menuButtons:Array = null;
		private var arrowButtons:Array = null;
		private var pageButtons:Array = null;
		private var clickedMenuButton:Sprite = null;
		private var clickedArrowButton:SimpleButton = null;
		private var clickedPageButton:Sprite = null;
		private var type:int = -1;
		private var pages:int = 0;
		private var page:int = -1;
		private var nrPageButtons:int = 0;

		//---------------------------------------------------------------------
		public function InventoryNavigation( objectDisplay:Sprite ):void
		{
			this.objectDisplay = objectDisplay;

			var buttonTexts:Array = new Array( "Bakgrunder", "Prylar" );
			menuButtons = new Array( buttonTexts.length );
			var i:int = 0;
			var menuButton:TextButton = null;
			var P:Point = new Point( 150, 10 );

			for( i = 0; i < buttonTexts.length; i++ )
			{
				menuButton = new TextButton( buttonTexts[ i ] );
				menuButton.x = P.x;
				menuButton.y = P.y;
				menuButton.addEventListener( TextButton.SELECT, HandleMenuEvent );
				objectDisplay.addChild( menuButton );
				P.x += menuButton.width + BUTTON_SPACE;
				menuButtons[ i ] = menuButton;
			}

			var arrowNames:Array = new Array( "left", "right" );
			arrowButtons = new Array( arrowNames.length );
			var arrowButton:SimpleButton = null;

			for( i = 0; i < arrowNames.length; i++ )
			{
				arrowButton = SimpleButton( objectDisplay.getChildByName( arrowNames[ i ] ) );
				arrowButton.addEventListener( MouseEvent.MOUSE_DOWN, HandleArrowEvent );
				arrowButtons[ i ] = arrowButton;
				objectDisplay.removeChild( arrowButton );
			}

			pageButtons = new Array();
			pagesDisplay = Sprite( objectDisplay.getChildByName( "pages" ) );
			objectDisplay.removeChild( pagesDisplay );
		}

		//---------------------------------------------------------------------
		private function HandleMenuEvent( event:Event ):void
		{
			switch( event.type )
			{
				case TextButton.SELECT:
				{
					clickedMenuButton = TextButton( event.target );
					dispatchEvent( new Event( SELECT_TYPE ) );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleArrowEvent( event:MouseEvent ):void
		{
			switch( event.type )
			{
				case MouseEvent.MOUSE_DOWN:
				{
				//	clickedArrowButton = Sprite( event.target );
					clickedArrowButton = SimpleButton( event.target );
					dispatchEvent( new Event( SELECT_DIRECTION ) );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandlePageEvent( event:MouseEvent ):void
		{
			switch( event.type )
			{
				case MouseEvent.MOUSE_DOWN:
				{
					clickedPageButton = Sprite( event.target.parent );
					dispatchEvent( new Event( SELECT_PAGE ) );
					break;
				}
			}
		}

		//---------------------------------------------------------------------
		public function GetSelectedType():int
		{
			return menuButtons.indexOf( clickedMenuButton );
		}

		//---------------------------------------------------------------------
		public function GetSelectedDirection():int
		{
			var direction:int = 0;

			if( arrowButtons.indexOf( clickedArrowButton ) == 0 )
			{
				direction = -1;
			}
			else
			{
				direction = 1;
			}

			return direction;
		}

		//---------------------------------------------------------------------
		public function GetSelectedPage():int
		{
			return pageButtons.indexOf( clickedPageButton );
		}

		//---------------------------------------------------------------------
		public function SetPages( pages:int ):void
		{
			this.pages = pages;
			nrPageButtons = Math.min( pages, MAX_PAGE_BUTTONS );
			var button:Sprite = null;

			while( pageButtons.length < nrPageButtons )
			{
				button = new PageButton();
				button.buttonMode = true;
				button.addEventListener( MouseEvent.MOUSE_DOWN, HandlePageEvent );
				button.x = 37 + 16 * pageButtons.length;
				button.y = 3;
				button.alpha = 0.5;
				pageButtons.push( button );
				pagesDisplay.addChild( button );
			}

			while( pageButtons.length > nrPageButtons )
			{
				button = pageButtons.pop();
				button.removeEventListener( MouseEvent.MOUSE_DOWN, HandlePageEvent );
				pagesDisplay.removeChild( button );
				button = null;
			}

			if( pages > 1 )
			{
				if( !objectDisplay.contains( pagesDisplay ) )
				{
					objectDisplay.addChild( pagesDisplay );
				}
			}
			else
			{
				if( objectDisplay.contains( pagesDisplay ) )
				{
					objectDisplay.removeChild( pagesDisplay );
				}
			}
		}

		//---------------------------------------------------------------------
		public function DisplayType( type:int ):void
		{
			if( this.type != type )
			{
				var menuButton:TextButton = null;

				if( this.type >= 0 )
				{
					menuButton = menuButtons[ this.type ];
					menuButton.Enable();
				}

				this.type = type;
				menuButton = menuButtons[ type ];
				menuButton.Disable();
			}
		}

		//---------------------------------------------------------------------
		public function DisplayPage( page:int ):void
		{
			if( page > 0 )
			{
				if( !objectDisplay.contains( arrowButtons[ 0 ] ) )
				{
					objectDisplay.addChild( arrowButtons[ 0 ] );
				}
			}
			else
			{
				if( objectDisplay.contains( arrowButtons[ 0 ] ) )
				{
					objectDisplay.removeChild( arrowButtons[ 0 ] );
				}
			}

			if( page < pages - 1 )
			{
				if( !objectDisplay.contains( arrowButtons[ 1 ] ) )
				{
					objectDisplay.addChild( arrowButtons[ 1 ] );
				}
			}
			else
			{
				if( objectDisplay.contains( arrowButtons[ 1 ] ) )
				{
					objectDisplay.removeChild( arrowButtons[ 1 ] );
				}
			}

			var pageButton:Sprite = null;

			if( ( this.page >= 0 ) && ( this.page < nrPageButtons ) )
			{
				pageButton = pageButtons[ this.page ];
				pageButton.alpha = 0.5;
				pageButton.buttonMode = true;
			}

			this.page = page;

			if( ( this.page >= 0 ) && ( this.page < nrPageButtons ) )
			{
				pageButton = pageButtons[ this.page ];
				pageButton.alpha = 1;
				pageButton.buttonMode = false;
			}
		}

		//---------------------------------------------------------------------
		public function Destroy():void
	//	override public function Destroy():void
		{
		//	super.Destroy();
		}
	}
}