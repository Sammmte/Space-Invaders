package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
 
class Nave extends FlxSprite
{
	private var shot:Disparo;
	static public var disparo:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(15, 15);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		ControlarNave();
	}
	
	public function ControlarNave():Void
	{
		if (FlxG.keys.pressed.RIGHT)
		{
			x += Reg.playerVelX;
			LimitPosition();
		}
		if (FlxG.keys.pressed.LEFT)
		{
			x -= Reg.playerVelX;
			LimitPosition();
		}
		if (FlxG.keys.justPressed.X)
		{
			Disparar();
		}
	}
	
	private function Disparar():Void
	{
		if (!disparo)
		{
			shot = new Disparo();
			shot.x = x + width/2;
			shot.y = y - shot.height;
		
			FlxG.state.add(shot);
			
			disparo = true;
		}
	}
	
	private function LimitPosition()
	{
		if (x < Reg.leftXLimit)
		{
			x = Reg.leftXLimit;
		}
		if (x > Reg.rightXLimit)
		{
			x = Reg.rightXLimit;
		}
	}
	
}