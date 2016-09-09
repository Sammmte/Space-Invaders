package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * ...
 * @author ...
 */
class Enemigo extends FlxSprite
{
	private var disparos:FlxTypedGroup<Disparo>;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(6, 6);
		
		disparo = new Disparo();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function Disparar():Void
	{
		
	}
}