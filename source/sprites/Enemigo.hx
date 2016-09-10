package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Enemigo extends FlxSprite
{
	private var disparos:FlxTypedGroup<Disparo>;
	private var timer:FlxTimer;
	public var direccionIzq:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.enemigo1x8__png, true, 8, 8);
		animation.add("uno", [0], 0, false);
		animation.add("dos", [1], 0, false);
		animation.play("uno");
		
		timer = new FlxTimer();
		timer.start(1, MoverEnemigos, 0);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
	}
	
	public function Disparar():Void
	{
		
	}

	
	private function MoverEnemigos(Timer:FlxTimer):Void
	{
		if (direccionIzq)
		{
			x -= 1;
		}
		else if (!direccionIzq)
		{
			x += 1;
		}
		
		if (animation.name == "uno")
		{
			animation.play("dos");
		}
		else
		{
			animation.play("uno");
		}
	}
	
}