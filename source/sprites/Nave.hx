package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
 
class Nave extends FlxSprite
{
	public var disparo:Disparo;
	public var puedeDisparar:Bool = true;
	private var timerAux:FlxTimer;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.jugadorlala__png, true, 13, 9);
		animation.add("normal", [0], 0, false);
		animation.add("muerte", [1, 2], 10, true);
		animation.play("normal");
		
		timerAux = new FlxTimer();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		ControlarNave();
		ComprobarDisparoY();
	}
	
	public function Muerte():Void
	{
		if (disparo != null)
		{
			disparo.destroy();
		}
		
		animation.play("muerte");
		
		timerAux.start(Reg.delayDeMuerte, PierdeUnaVida, 1);
		
	}
	
	private function PierdeUnaVida(timer:FlxTimer):Void
	{
		animation.play("normal");
		Reg.vidas--;
	}
	
	private function ComprobarDisparoY():Void
	{
		if (!puedeDisparar)
		{
			if (disparo.IsOutStage())
			{
				puedeDisparar = true;
				disparo.destroy();
			}
		}
	}
	
	public function ControlarNave():Void
	{
		if (FlxG.keys.pressed.RIGHT)
		{
			x += Reg.playerVelX;
			LimitarPosicion();
		}
		if (FlxG.keys.pressed.LEFT)
		{
			x -= Reg.playerVelX;
			LimitarPosicion();
		}
		if (puedeDisparar)
		{
			if (FlxG.keys.justPressed.X)
			{
				Disparar();
			}
		}
	}
	
	private function Disparar():Void
	{
		disparo = new Disparo();
		disparo.x = (x + width/2) - disparo.width/2;
		disparo.y = y - disparo.height;
		disparo.velocity.y = Reg.disparoVelocityPlayer;
		
		FlxG.state.add(disparo);
			
		puedeDisparar = false;
	}
	
	private function LimitarPosicion():Void
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