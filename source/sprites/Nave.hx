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
	private var disparo:Disparo;
	static public var puedeDisparar:Bool = true;

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
		if (puedeDisparar)
		{
			if (FlxG.keys.justPressed.X)
			{
				Disparar();
			}
		}
		if (!puedeDisparar)
		{
			if (disparo.Colisiono())
			{
				puedeDisparar = true;
				disparo.destroy();
			}
		}
	}
	
	private function Disparar():Void
	{
		disparo = new Disparo();
		disparo.x = x + width/2;
		disparo.y = y - disparo.height;
		
		FlxG.state.add(disparo);
			
		puedeDisparar = false;
	}
	
	private function LimitPosition():Void
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