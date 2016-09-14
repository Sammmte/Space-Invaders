package states;

import flixel.FlxState;
import flixel.text.FlxText;
import Reg;
import Fonts;
import flixel.util.FlxTimer;
import flixel.FlxG;
import source.states.MenuState;
import source.states.PlayState;

/**
 * ...
 * @author ...
 */
class ResultState extends FlxState
{
	private var text:FlxText;
	private var timer:FlxTimer;
	
	override public function create() 
	{
		super.create();
		
		text = new FlxText(9, 50, (FlxG.width - (Reg.leftXLimit * 2)), "", 8, true);
		text.alignment = "center";
		DeterminarTexto();
		
	    timer = new FlxTimer();
		timer.start(1, OnComplete, 1);
	}
	
	private function OnComplete(timer:FlxTimer):Void
	{
		FlxG.state.add(text);
		
		timer.start(4, DestruirTodo, 1);
		
	}
	
	private function DeterminarTexto():Void
	{
		if (Reg.gano)
		{
			Reg.resets++;
			Reg.gano = false;
			Reg.contEnemigos = 0;
			
			text.text = "              Preparate!                                                            Oleada numero " + Reg.resets;
			
		}
		else if (Reg.perdio)
		{
			text.text = "Perdiste";
			Reg.vidas = 3;
			Reg.resets = 1;			
			Reg.gano = false;
			Reg.contEnemigos = 0;
			Reg.aceleracionEnemigos = 0.014;
			Reg.score = 0;
			
		}
		else if (!Reg.gano && !Reg.perdio)
		{
			text.text = "              Preparate!                                                            Oleada numero " + Reg.resets;
			
		}
	}
	
	private function DestruirTodo(timer:FlxTimer):Void
	{
		if (Reg.perdio)
		{
			FlxG.state.remove(text);
			Reg.perdio = false;
			text.destroy();
			timer.destroy();
			FlxG.switchState(new MenuState());
		}
		else
		{
			FlxG.state.remove(text);
			text.destroy();
			timer.destroy();
			FlxG.switchState(new PlayState());
		}
	}
	
}