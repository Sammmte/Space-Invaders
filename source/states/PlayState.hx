package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sprites.Disparo;
import sprites.Enemigo;
import sprites.Nave;
import Reg;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	private var nave:Nave;
	private var enemigos:FlxTypedGroup<Enemigo>;
	private var timer:FlxTimer;
	
	
	override public function create():Void
	{
		super.create();
		
		Reg.random = new FlxRandom();
		
		nave = new Nave(Reg.playerX, Reg.playerY);
		add(nave);
		
		enemigos = new FlxTypedGroup<Enemigo>(Reg.cantidadEnemigos);
		
		for (i in 0... Reg.enemigosFilas)
		{
			for (j in 0... Reg.enemigosColumnas)
			{
				enemigos.add(new Enemigo(Reg.xComienzoEnemigos, Reg.yComienzoEnemigos));
				Reg.xComienzoEnemigos += Reg.espacioEntreEnemigos;
			}
			Reg.yComienzoEnemigos += Reg.espacioEntreEnemigos;
			Reg.xComienzoEnemigos = 20;
		}
		
		add(enemigos);
		
		//Reseteo las posiciones por default de la clase Enemigo
		Reg.xComienzoEnemigos = 20;
		Reg.yComienzoEnemigos = 10;
		
		//timer = new FlxTimer();
		//timer.start(segundos, funcionQueLlamaCuandoTermina:Void --(Debe ser :Void)-- , cantidad de veces que lo va a hacer --(0 es loop infito)--);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function EnemigoRandomDispara():Void
	{
		Reg.random.int(0, 54);
		
		enemigos.members[random]
	}
}
