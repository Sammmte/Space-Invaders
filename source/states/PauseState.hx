package states;

import flixel.FlxSubState;
import flixel.system.FlxSound;
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
	private var sonido:FlxSound;

	public function new(BGColor:FlxColor = FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		Sounds.Init();
		
		sonido = new FlxSound();
		sonido = Sounds.sonidoPausa;
		sonido.play();
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