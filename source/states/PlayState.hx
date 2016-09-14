package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import lime.graphics.Image;
import sprites.Disparo;
import sprites.Enemigo;
import sprites.HUD;
import sprites.Nave;
import Reg;
import Fonts;
import Sounds;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import states.PauseState;
import states.ResultState;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	//Sprites importantes
	private var hud:HUD;
	private var nave:Nave;
	private var enemigos:FlxTypedGroup<Enemigo>;
	
	//Auxiliar
	private var direccionIzqEnemigos:Bool = false;
	private var timer:FlxTimer;
	private var enemigosMuertosIndex:Array<Int>;
	private var sonidoMusicaEnemigos:FlxSound;
	private var vidasSprite:Nave;
	
	
	override public function create():Void
	{
		super.create();
		
		Fonts.Init();
		Sounds.Init();
		
		hud = new HUD();
		
		//Random estatico para cualquier necesidad
		Reg.random = new FlxRandom();
		
		Reg.aceleracionEnemigos += Reg.aumentoAceleracion;
		Reg.framesVelocidadEnemigos = 1;
		
		nave = new Nave(Reg.playerX, Reg.playerY);
		add(nave);
		
		//Inicializar la posicion de los enemigos
		InitEnemigos();
		
		//Reseteo las posiciones por default de la clase Enemigo
		Reg.xComienzoEnemigos = 15;
		Reg.yComienzoEnemigos = 15;
		
		//Timer auxiliar para manejar el momento en que uno miembro del grupo de enemigos debe disparar
		timer = new FlxTimer();
		timer.start(Reg.enemigosDisparoDelay, OnComplete, 0);
		
		//Este array se usara para asegurarse de que, terminado un ciclo del timer, un enemigo dispare
		//mediante el descarte de los enemigos que fueron destruidos
		enemigosMuertosIndex = new Array();
		
		//Musica
		sonidoMusicaEnemigos = new FlxSound();
		sonidoMusicaEnemigos = Sounds.sonEneUno;
		
	}
	
	/*<<<<<<<<<<UPDATE>>>>>>>>>>>*/

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		CambiarDireccionEnemigos();
		ComprobarEnemigosColision(nave.disparo);
		ComprobarColisionJugador();
		RegularFramesEnemigos();
		ComprobarPerdio();
		Pausar();
		MusicaEnemigos();
		ComprobarGano();
		if (nave.puedeDisparar)
		{
			hud.UpdateVidas();
		}
	}
	
	
	
	
	/*<<<<<<<<<COLISIONES>>>>>>>>>*/
	
	
	
	
	//Para cualquier colision con un enemigo
	private function ColisionEnemigo(disparo:Disparo, alien:Enemigo):Bool
	{
		if (disparo != null)
		{
			if (alien.murio == false)
			{
				if (FlxG.overlap(disparo, alien))
				{
					alien.animation.play("muerte", 1);
					disparo.destroy();
					nave.puedeDisparar = true;
					alien.murio = true;
					hud.UpdateScore(alien.puntaje);
					Reg.framesVelocidadEnemigos -= Reg.aceleracionEnemigos;
					alien.sonidoMuerte.play();
					return true;
				}	
			}
		}
		
		return false;
	}
	
	//Para separar el proceso de comprobar si colisiono y la colision misma
	private function ComprobarEnemigosColision(disparo:Disparo):Void
	{
		for (i in 0... enemigos.length)
		{
			if (ColisionEnemigo(disparo, enemigos.members[i]))
			{
				enemigosMuertosIndex.push(i);
			}
		}
	}
	
	//Para cualquier colision contra el jugador
	private function ColisionJugador(aliens:FlxTypedGroup<Enemigo>, jugador:Nave):Bool
	{
		
			for (i in 0... aliens.length)
			{
				if (aliens.members[i].disparo != null)
				{	
					if (FlxG.overlap(aliens.members[i].disparo, jugador))
					{
						return true;
					}
					else if (FlxG.overlap(aliens.members[i], jugador))
					{
						Reg.perdio = true;
						return true;
					}
				}
			}	
			
			return false;
	}
	
	
	private function ComprobarColisionJugador():Void
	{
		if (ColisionJugador(enemigos, nave) && nave.murio == false)
		{
			nave.murio = true;
			nave.Muerte();
		}
	}
	
	/*<<<<<<<<<<<<CAMBIOS DE STATES>>>>>>>>>>>>>>>*/
	
	private function ComprobarGano():Void
	{
		if (Reg.contEnemigos == Reg.cantidadEnemigos)
		{
			Reg.gano = true;
		}
		
		if (Reg.gano)
		{
			FlxG.switchState(new ResultState());
		}
	}
	
	private function Pausar():Void
	{
		if (Reg.pausa == false)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				Reg.pausa = true;
			}
		}
		
		if (Reg.pausa == true)
		{
			openSubState(new PauseState());
		}
	}
	
	private function ComprobarPerdio():Void
	{
		if (Reg.vidas == 0)
		{
			Reg.perdio = true;
		}
		
		if (Reg.perdio)
		{
			FlxG.switchState(new ResultState());
		}
	}
	
	/*<<<<<<<<<<<<<METODOS PARA ENEMIGOS>>>>>>>>>>>>>>>>>>*/
	
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
					enemigo.tipo = 3;
					enemigo.CargarSprite();
				}
				else if (i == 1 || i == 2)
				{
					enemigo.tipo = 2;
					enemigo.CargarSprite();
				}
				else if (i == 3 || i == 4)
				{
					enemigo.tipo = 1;
					enemigo.CargarSprite();
				}
				enemigos.add(enemigo);
				Reg.xComienzoEnemigos += Reg.espacioEntreEnemigos;
			}
			Reg.yComienzoEnemigos += Reg.espacioEntreEnemigos;
			Reg.xComienzoEnemigos = 14;
		}
		
		add(enemigos);
	}
	
	//Este metodo evita que el timer que usan los enemigos se detenga y el grupo entero se trabe
	private function RegularFramesEnemigos():Void
	{
		if (Reg.framesVelocidadEnemigos <= Reg.aceleracionEnemigos + 0.001)
		{
			Reg.aceleracionEnemigos = 0.02;
			Reg.framesVelocidadEnemigos = 0.021;
		}
	}
	
	
	
	//Este metodo hace que los enemigos cambien su sentido y bajen hacia el jugador
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
		if (Reg.pausa == false)
		{
			EnemigoRandomDispara();
		}
	}
	
	//Metodo para hacer disparar a los enemigos
	private function EnemigoRandomDispara():Void
	{
		var aux:Int = Reg.random.int(0, Reg.cantidadEnemigos - 1);
		
		while (!AprobarRandom(aux))
		{
			aux = Reg.random.int(0, Reg.cantidadEnemigos - 1);
			
			if (Reg.contEnemigos == Reg.cantidadEnemigos)
			{
				break;
			}
		}
		
		if (enemigos.members[aux].puedeDisparar && enemigos.members[aux].murio == false)
		{
			enemigos.members[aux].trick = true;
		}
	}
	
	//Filtro para asegurarse de que los enemigos disparan cada vez que el timer logra un ciclo
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
	
	private function MusicaEnemigos():Void
	{
		if (Reg.musicaEnemigos)
		{
			sonidoMusicaEnemigos.play();
			Reg.musicaEnemigos = false;
			
			if (sonidoMusicaEnemigos == Sounds.sonEneUno)
			{
				sonidoMusicaEnemigos = Sounds.sonEneDos;
			}
			else if (sonidoMusicaEnemigos == Sounds.sonEneDos)
			{
				sonidoMusicaEnemigos = Sounds.sonEneTres;
			}
			else if (sonidoMusicaEnemigos == Sounds.sonEneTres)
			{
				sonidoMusicaEnemigos = Sounds.sonEneCuatro;
			}
			else if (sonidoMusicaEnemigos == Sounds.sonEneCuatro)
			{
				sonidoMusicaEnemigos = Sounds.sonEneUno;
			}
		}
	}
}
