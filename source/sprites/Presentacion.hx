package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Presentacion extends FlxSprite
{
	private var aux:Bool = false;
	public var termino:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.splash__png);
		alpha = 0;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		if (!aux)
		{
			alpha += 0.015;
		}
		
		if (alpha == 1)
		{
			Sys.sleep(2);
			aux = true;
		}
		
		if (aux)
		{
			alpha -= 0.015;
			if (alpha == 0)
			{
				termino = true;
			}
		}
	}
	
}