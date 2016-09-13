package;

import openfl.text.Font;
import openfl.Assets;

/**
 * ...
 * @author ...
 */
class Fonts
{
	static public var pixeledFont(default, null):String;
	
	static public function Init():Void
	{
        pixeledFont = Assets.getFont("assets/fonts/pixeled.ttf").fontName;
	}
	
	public function new() 
	{
		
	}
	
}