package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Estructura extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.estructura__png, true, 15, 8);
		animation.add("uno", [0], 0, false);
		animation.add("dos", [1], 0, false);
		animation.add("tres", [2], 0, false);
		animation.add("cuatro", [3], 0, false);
		animation.add("cinco", [4], 0, false);
		animation.play("uno");
	}
	
	public function CambiarAnimacion():Void
	{
		if (animation.name == "uno")
		{
			animation.play("dos");
		}
		else if(animation.name == "dos")
		{
			animation.play("tres");
		}
		else if(animation.name == "tres")
		{
			animation.play("cuatro");
		}
		else if(animation.name == "cuatro")
		{
			animation.play("cinco");
		}
		else if(animation.name == "cinco")
		{
			destroy();
		}
	}
	
}