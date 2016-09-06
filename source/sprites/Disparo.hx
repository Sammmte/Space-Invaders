package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import sprites.Nave;

/**
 * ...
 * @author ...
 */
class Disparo extends FlxSprite
{
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(2, 5);
		
		velocity.y = Reg.shotVelocity;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (y < 0)
		{
			destroy();
			Nave.disparo = false;
		}
	}
	
}