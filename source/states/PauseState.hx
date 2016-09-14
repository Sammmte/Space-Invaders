package states;

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class PauseState extends FlxSubState
{
	private var textoOleada:FlxText;

	public function new(BGColor:FlxColor = FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (Reg.pausa)
		{
			Despausar();
		}
	}
	
	private function Despausar():Void
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			Reg.pausa = false;
			close();
		}
	}
}