package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sprites.Disparo;
import sprites.Nave;
import Reg;

class PlayState extends FlxState
{
	private var ship:Nave;
	
	override public function create():Void
	{
		super.create();
		
		ship = new Nave(Reg.playerX, Reg.playerY);
		
		add(ship);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
