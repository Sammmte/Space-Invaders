package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sprites.Disparo;
import sprites.Enemigo;
import sprites.Nave;
import Reg;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	private var nave:Nave;
	private var enemigos:FlxTypedGroup<Enemigo>;
	private var direccionIzqEnemigos:Bool = false;
	private var timer:FlxTimer;
	private var perdio:Bool = false;
	private var gano:Bool = false;
	private var enemigosMuertosIndex:Array<Int>;
	
	override public function create():Void
	{
		super.create();
		
		Reg.random = new FlxRandom();
		
		nave = new Nave(Reg.playerX, Reg.playerY);
		add(nave);
		
		InitEnemigos();
		
		//Reseteo las posiciones por default de la clase Enemigo
		Reg.xComienzoEnemigos = 20;
		Reg.yComienzoEnemigos = 10;
		
		timer = new FlxTimer();
		timer.start(Reg.enemigosDisparoDelay, OnComplete, 0);
		
		enemigosMuertosIndex = new Array();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		CambiarDireccionEnemigos();
		ColisionEnemigo(nave.disparo, enemigos);
		ColisionJugador(enemigos, nave);
		RegularFramesEnemigos();
		//ComprobarPerdio();
		//ComprobarGano();
		
	}
	
	private function ComprobarPerdio():Void
	{
		if (perdio)
		{
			//pasa algo
		}
	}
	
	private function ComprobarGano():Void
	{
		if (gano)
		{
			//pasa algo
		}
	}
	
	private function InitEnemigos():Void
	{
		enemigos = new FlxTypedGroup<Enemigo>(Reg.cantidadEnemigos);
		
		for (i in 0... Reg.enemigosFilas)
		{
			for (j in 0... Reg.enemigosColumnas)
			{
				var enemigo = new Enemigo(Reg.xComienzoEnemigos, Reg.yComienzoEnemigos);
				if (i == 0)
				{
					enemigo.CargarSprite(3);
				}
				else if (i == 1 || i == 2)
				{
					enemigo.CargarSprite(2);
				}
				else if (i == 3 || i == 4)
				{
					enemigo.CargarSprite(1);
				}
				enemigos.add(enemigo);
				Reg.xComienzoEnemigos += Reg.espacioEntreEnemigos;
			}
			Reg.yComienzoEnemigos += Reg.espacioEntreEnemigos;
			Reg.xComienzoEnemigos = 14;
		}
		
		add(enemigos);
	}
	
	private function RegularFramesEnemigos():Void
	{
		if (Reg.framesVelocidadEnemigos <= 0.021)
		{
			Reg.framesVelocidadEnemigos = 0.021;
		}
	}
	
	private function ColisionEnemigo(disparo:Disparo, aliens:FlxTypedGroup<Enemigo>):Void
	{
		if (disparo != null)
		{
			for (i in 0... aliens.length)
			{
				if (FlxG.overlap(disparo, aliens.members[i]))
				{
					aliens.members[i].animation.play("muerte", 1);
					disparo.destroy();
					nave.puedeDisparar = true;
					Reg.framesVelocidadEnemigos -= Reg.aceleracionEnemigos;
					enemigosMuertosIndex.push(i);
				}
			}
		}
	}
	
	private function ColisionJugador(aliens:FlxTypedGroup<Enemigo>, jugador:Nave):Void
	{
		
			for (i in 0... aliens.length)
			{
				if (aliens.members[i].disparo != null)
				{	
					if (FlxG.overlap(aliens.members[i].disparo, jugador))
					{
						nave.Muerte();
					}
				}
			}	
	}
	
	private function CambiarDireccionEnemigos():Void
	{
		for (i in 0... enemigos.length)
		{
			
			if (enemigos.members[i].x == Reg.rightXLimit + 6)
				{
					for (j in 0... enemigos.length)
					{
						
						enemigos.members[j].direccion = -1;
						enemigos.members[j].auxY = Reg.YBajadaEnemigos;
						
					}
					break;
				}
				if (enemigos.members[i].x == Reg.leftXLimit + 4)
				{
					for (j in 0... enemigos.length)
					{
						
						enemigos.members[j].direccion = 1;
						enemigos.members[j].auxY = Reg.YBajadaEnemigos;
						
					}
					break;
				}	
			
		}
	}
	
	private function OnComplete(timer:FlxTimer):Void
	{
		EnemigoRandomDispara();
	}
	
	private function EnemigoRandomDispara():Void
	{
		var aux:Int = Reg.random.int(0, Reg.cantidadEnemigos - 1);
		
		while (!AprobarRandom(aux))
		{
			aux = Reg.random.int(0, Reg.cantidadEnemigos - 1);
			if (Reg.contEnemigos == Reg.cantidadEnemigos)
			{
				gano = true;
			}
		}
		
		if (enemigos.members[aux].puedeDisparar && enemigos.members[aux].murio == false)
		{
			enemigos.members[aux].disparo = enemigos.members[aux].Disparar();
			FlxG.state.add(enemigos.members[aux].disparo);
		}
	}
	
	private function AprobarRandom(random:Int):Bool
	{
		for (i in 0... Reg.cantidadEnemigos)
		{
			if (random == enemigosMuertosIndex[i])
			{
				return false;
			}
		}
		
		return true;
	}
}
