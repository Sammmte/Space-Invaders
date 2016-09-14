package sprites;

import flash.utils.Timer;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Enemigo extends FlxSprite
{
	public var disparo:Disparo;
	private var timer:FlxTimer;
	public var direccion:Int;
	public var auxY:Int;
	public var puedeDisparar:Bool = true;
	public var murio:Bool = false;
	public var trick:Bool = false;
	public var sonidoMuerte:FlxSound;
	
	
	//Tipo 1: 10 puntos , Tipo 2: 20 , Tipo 3: 30 , Tipo 4: Random
	public var tipo:Int = 0;
	public var puntaje:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		direccion = 1;
		auxY = 0;
		
		timer = new FlxTimer();
		timer.start(Reg.framesVelocidadEnemigos, OnComplete, 0);
		
		sonidoMuerte = Sounds.muerteEnemigo;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		ComprobarDisparoY();
		if (trick)
		{
			Disparar();
		}
		timer.time = Reg.framesVelocidadEnemigos;
	}
	
	/*<<<<<<<<<<<<INICIALIZACION>>>>>>>>>>>>>>*/
	
	public function CargarSprite():Void
	{
		if (tipo == 3)
		{
			loadGraphic(AssetPaths.enemigo1prov__png, true, 8, 8);
			animation.add("uno", [0], 0, false);
			animation.add("dos", [1], 0, false);
			animation.add("muerte", [2], 0, false);
			animation.play("uno");
			puntaje = 30;
		}
		else if (tipo == 2)
		{
			loadGraphic(AssetPaths.enemigo3prov__png, true, 11, 8);
			animation.add("uno", [0], 0, false);
			animation.add("dos", [1], 0, false);
			animation.add("muerte", [2], 0, false);
			animation.play("uno");
			puntaje = 20;
		}
		else if (tipo == 1)
		{
			loadGraphic(AssetPaths.enemigo2prov__png, true, 10, 7);
			animation.add("uno", [0], 0, false);
			animation.add("dos", [1], 0, false);
			animation.add("muerte", [2], 0, false);
			animation.play("uno");
			puntaje = 10;
		}
		/*else if(tipo == 4)
		{
			...
		}*/
	}
	
	/*<<<<<<<<<<<<CONTROLES>>>>>>>>>>>>>>*/
	
	public function Disparar():Void
	{
		disparo = new Disparo();
		disparo.x = (x + width/2) - disparo.width/2;
		disparo.y = y + height;
		disparo.velocity.y = Reg.disparoVelocityEnemy;
		
		puedeDisparar = false;
		
		FlxG.state.add(disparo);
		
		trick = false;
	}
	
	private function OnComplete(timer:FlxTimer):Void
	{
		if (!Reg.pausa)
		{
			Reg.musicaEnemigos = true;
			MoverPersonaje();
			if (murio)
			{
				Muerte();
			}
		}
	}
	
	private function MoverPersonaje():Void
	{
		y += auxY;
		x += direccion;
		
		if (auxY != 0)
		{
			auxY = 0;
		}
		
		if (animation.name == "uno")
		{
			animation.play("dos");
		}
		else if(animation.name == "dos")
		{
			animation.play("uno");
		}
	}
	
	/*<<<<<<<<<<<<AUXILIARES>>>>>>>>>>>>>>*/
	
	private function Muerte():Void
	{
		timer.destroy();
		Reg.contEnemigos++;
		destroy();
	}
	
	private function ComprobarDisparoY():Void
	{
		if (!puedeDisparar && disparo != null)
		{
			if (disparo.IsOutStage())
			{
				puedeDisparar = true;
				disparo.destroy();
			}
		}
	}
	
	
	
}