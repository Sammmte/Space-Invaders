package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sprites.Presentacion;
import states.ResultState;

class MenuState extends FlxState
{
	private var splashScreen:Presentacion;
	
	override public function create():Void
	{
		super.create();
		
		splashScreen = new Presentacion(0, 0);
		
		add(splashScreen);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (splashScreen.termino)
		{
			splashScreen.destroy();
			FlxG.switchState(new ResultState());
		}
	}
}
