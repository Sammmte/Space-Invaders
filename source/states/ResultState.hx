package states;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import Reg;
import Fonts;
import flixel.util.FlxTimer;
import flixel.FlxG;
import states.MenuState;
import states.PlayState;

/**
 * ...
 * @author ...
 */
class ResultState extends FlxState
{
	private var text:FlxText;
	private var timer:FlxTimer;
	private var spriteUno:FlxSprite;
	private var spriteDos:FlxSprite;
	private var spriteTres:FlxSprite;
	private var spriteCuatro:FlxSprite;
	private var x:Int = 33;
	private var y:Int = 60;
	
	override public function create() 
	{
		super.create();
		
		FlxG.mouse.visible = false;
		
		text = new FlxText();
		text.size = 8;
		text.fieldWidth = 160;
		text.alignment = "center";
		DeterminarTexto();
		
	    timer = new FlxTimer();
		timer.start(1, OnComplete, 1);
		
		spriteUno = new FlxSprite(x,y);
		spriteDos = new FlxSprite(x+3,y+11);
		spriteTres = new FlxSprite(x+3,y+22);
		spriteCuatro = new FlxSprite(x+3,y+33);
		
		spriteUno.loadGraphic(AssetPaths.ovni__png);
		spriteDos.loadGraphic(AssetPaths.enemigo1__png);
		spriteTres.loadGraphic(AssetPaths.enemigo3__png);
		spriteCuatro.loadGraphic(AssetPaths.enemigo2__png);
	}
	
	private function OnComplete(timer:FlxTimer):Void
	{
		FlxG.state.add(text);
		if (!Reg.perdio)
		{
			FlxG.state.add(spriteUno);
			FlxG.state.add(spriteDos);
			FlxG.state.add(spriteTres);
			FlxG.state.add(spriteCuatro);
		}
		
		timer.start(5, DestruirTodo, 1);
		
	}
	
	private function DeterminarTexto():Void
	{
		if (Reg.gano)
		{
			Reg.resets++;
			Reg.gano = false;
			Reg.contEnemigos = 0;
			Reg.spawnOvniTime = 1;
			Reg.musicaEnemigos = true;
			Reg.musicaOvni = false;
			
			EntrePantalla();
		}
		else if (Reg.perdio)
		{
			text.text = "\n\n\n\n\n\nYOU LOSE\n\nSCORE = " + Reg.score + "\n\nHIGHSCORE = " + Reg.highScore;
			Reg.vidas = 3;
			Reg.resets = 1;			
			Reg.gano = false;
			Reg.contEnemigos = 0;
			Reg.aceleracionEnemigos = 0.014;
			Reg.score = 0;
			Reg.spawnOvniTime = 1;
			Reg.musicaEnemigos = true;
			Reg.musicaOvni = false;
		}
		else if (!Reg.gano && !Reg.perdio)
		{
			EntrePantalla();
		}
	}
	
	private function EntrePantalla():Void
	{
		text.text = "PLAY\n\n  SPACE       INVADERS\n\nSCORE  ADVANCE  TABLE\n\n     = ? MYSTERY\n    = 30 POINTS\n    = 20 POINTS\n    = 10 POINTS\n\nPRESS X TO SHOOT";
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
			FlxG.state.remove(spriteUno);
			FlxG.state.remove(spriteDos);
			FlxG.state.remove(spriteTres);
			FlxG.state.remove(spriteCuatro);
			FlxG.state.remove(text);
			text.destroy();
			timer.destroy();
			FlxG.switchState(new PlayState());
		}
	}
	
}