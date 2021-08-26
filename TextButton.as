package kp
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;

	//-------------------------------------------------------------------------
	// TextButton
	//-------------------------------------------------------------------------
	public class TextButton extends Sprite
	{
		public static const SELECT:String = "select";
		private const ENABLED:int = 0;
		private const DISABLED:int = 1;
		public var background:Sprite = null;
		public var textField:TextField = null;
		private var area:Sprite = null;
		private var state:int = -1;
		private var margin:int = 0; 

		//---------------------------------------------------------------------
		public function TextButton( text:String = null ):void
		{
			textField.autoSize = TextFieldAutoSize.LEFT;
			margin = 2 * textField.x;

			hitArea = new Sprite();
			hitArea.graphics.beginFill( 0x000000, 0 );
			hitArea.graphics.drawRect( 0, 0, background.width, background.height );
			addChild( hitArea );

			if( text != null )
			{
				SetText( text );
			}

			Enable();
		}

		//---------------------------------------------------------------------
		public function SetText( text:String ):void
		{
			if( text != null )
			{
				textField.text = text;
				background.width = textField.width + margin;
				hitArea.width = background.width;
			}
		}

		//---------------------------------------------------------------------
		public function Enable():void
		{
			EnterState( ENABLED );
		}

		//---------------------------------------------------------------------
		public function Disable():void
		{
			EnterState( DISABLED );
		}

		//---------------------------------------------------------------------
		private function EnterState( state:int ):void
		{
			if( this.state != state )
			{
				this.state = state;

				switch( state )
				{
					case ENABLED:
					{
						hitArea.buttonMode = true;
						background.alpha = 0.5;
						hitArea.addEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );
						hitArea.addEventListener( MouseEvent.MOUSE_OVER, HandleMouseEvent );
						hitArea.addEventListener( MouseEvent.MOUSE_OUT,  HandleMouseEvent );
						break;
					}

					case DISABLED:
					{
						hitArea.buttonMode = false;
						background.alpha = 1;
						hitArea.removeEventListener( MouseEvent.MOUSE_DOWN, HandleMouseEvent );
						hitArea.removeEventListener( MouseEvent.MOUSE_OVER, HandleMouseEvent );
						hitArea.removeEventListener( MouseEvent.MOUSE_OUT,  HandleMouseEvent );
						break;
					}
				}
			}
		}

		//---------------------------------------------------------------------
		private function HandleMouseEvent( event:MouseEvent ):void
		{
			switch( event.type )
			{
				case MouseEvent.MOUSE_DOWN:
				{
					dispatchEvent( new Event( SELECT ) );
					break;
				}

				case MouseEvent.MOUSE_OVER:
				{
					background.alpha = 1;
					break;
				}

				case MouseEvent.MOUSE_OUT:
				{
					background.alpha = 0.5;
					break;
				}
			}
		}
	}
}