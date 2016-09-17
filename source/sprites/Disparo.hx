package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Disparo extends FlxSprite
{
	private var timer:FlxTimer;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.balaprov__png, true, 8, 7);
		animation.add("normal", [0], 0, false);
		animation.add("explosion", [1], 0, false);
		animation.play("normal");
		
		timer = new FlxTimer();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function IsOutStage():Bool
	{
		if (y < 0 || y > FlxG.height)
		{
			return true;
		}
		
		return false;
	}
	
	public function AnimacionDestruccion():Void
	{
		velocity.y = 0;
		solid = false;
		animation.play("explosion");
		timer.start(1, DestruirDisparo, 1);
	}
	
	private function DestruirDisparo(timer:FlxTimer):Void
	{
		destroy();
	}
	
}