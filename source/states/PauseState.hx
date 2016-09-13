package states;

import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class PauseState extends FlxSubState
{
	private var timer:FlxTimer;

	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		if (!Reg.pausa)
		{
			Reg.pausa = true;
			timer = new FlxTimer();
			timer.start(Reg.delayDeMuerte, Reset, 1);
		}
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
	
	private function Reset(timer:FlxTimer):Void
	{
		timer.destroy();
		Reg.pausa = false;
		close();
	}
	
}