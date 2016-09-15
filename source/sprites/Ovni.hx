package sprites;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Ovni extends Enemigo
{
	public var sonido:FlxSound;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		sonido = Sounds.sonidoOvni;
		murio = false;
		sonido.play();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		ComprobarDisparoY();
		MoverPersonaje();
		
		if (x <= -width)
		{
			Muerte();
		}
	}
	
	override private function OnComplete(timer:FlxTimer):Void
	{
		if (!Reg.gano || !Reg.perdio)
		{
			if ((Reg.random.int(1, 100) % 5 == 0) && !murio && puedeDisparar)
			{
				Disparar();
			}
			else if (murio)
			{
				Muerte();
			}
		}
	}
	
	override private function MoverPersonaje():Void
	{
		if (!murio)
		{
			x -= 0.4;
		}
	}
	
	override public function Muerte():Void
	{
		trace("hola");
		FlxG.state.remove(this);
		murio = false;
		puedeDisparar = false;
		Reg.musicaEnemigos = true;
		Reg.musicaOvni = false;
		sonido.stop();
		destroy();
	}
}