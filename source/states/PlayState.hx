package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import sprites.Disparo;
import sprites.Enemigo;
import sprites.Estructura;
import sprites.HUD;
import sprites.Nave;
import Reg;
import Fonts;
import Sounds;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import sprites.Ovni;
import states.PauseState;
import states.ResultState;
import flixel.system.FlxAssets.FlxGraphicAsset;

class PlayState extends FlxState
{
	//Sprites importantes
	private var hud:HUD;
	private var nave:Nave;
	private var enemigos:FlxTypedGroup<Enemigo>;
	private var ovniBonus:Ovni;
	private var estructuras:FlxTypedGroup<Estructura>;
	
	//Auxiliar
	private var direccionIzqEnemigos:Bool = false;
	private var timer:FlxTimer;
	private var enemigosMuertosIndex:Array<Int>;
	private var vidasSprite:Nave;
	private var limite:Int;
	private var sonidoNum:Int = 1;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		
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
		
		//Inicializar la posicion de las estructuras colisionables
		InitEstructuras();
		
		//Reseteo las posiciones por default de la clase Enemigo
		Reg.xComienzoEnemigos = 15;
		Reg.yComienzoEnemigos = 25;
		
		//Timer auxiliar para manejar el momento en que uno miembro del grupo de enemigos debe disparar
		timer = new FlxTimer();
		timer.start(Reg.enemigosDisparoDelay, OnComplete, 0);
		
		//Este array se usara para asegurarse de que, terminado un ciclo del timer, un enemigo dispare
		//mediante el descarte de los enemigos que fueron destruidos
		enemigosMuertosIndex = new Array();
		
		limite = Reg.rightXLimit + 6;
		
	}
	
	/*<<<<<<<<<<UPDATE>>>>>>>>>>>*/

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//Cambia el sentido de los enemigos
		CambiarDireccionEnemigos();
		//Colisiones
		ComprobarEnemigosColision(nave.disparo);
		
		ComprobarColisionJugador(enemigos, ovniBonus, nave);
		
		ColisionEstructura();
		
		ColisionEnemigo(nave.disparo, ovniBonus);
		
		ColisionBalas();
		
		//Auxiliares
		SpawnOvni();
		RegularFramesEnemigos();
		MusicaEnemigos();
		
		//Cambios de States
		ComprobarPerdio();
		Pausar();
		ComprobarGano();
		
		if (nave.puedeDisparar)
		{
			hud.UpdateVidas();
		}
	}
	
	
	/*<<<<<<<<<ESTRUCTURAS COLISIONABLES>>>>>>>>>*/
	
	
	private function InitEstructuras():Void
	{
		estructuras = new FlxTypedGroup<Estructura>(Reg.cantidadEstructuras);
		
		var strX:Int = 20;
		var aux:Int = 33;
		
		for (i in 0... Reg.cantidadEstructuras)
		{
			var estructura = new Estructura(strX, Reg.yEstructuras);
			strX += aux;
			estructuras.add(estructura);
		}
		
		add(estructuras);
	}
	
	/*<<<<<<<<<COLISIONES>>>>>>>>>*/
	
	private function ColisionBalas():Void
	{
		for (i in 0... enemigos.length)
		{
			if (nave.disparo != null && enemigos.members[i].disparo != null)
			{
				if (FlxG.overlap(enemigos.members[i].disparo, nave.disparo))
				{
					enemigos.members[i].disparo.destroy();
					nave.disparo.AnimacionDestruccion();
					nave.puedeDisparar = true;
					enemigos.members[i].puedeDisparar = true;
				}
			}
		}
		
		if (nave.disparo != null && ovniBonus != null && ovniBonus.disparo != null)
			{
				if (FlxG.overlap(ovniBonus.disparo, nave.disparo))
				{
					ovniBonus.disparo.destroy();
					nave.disparo.AnimacionDestruccion();
					nave.puedeDisparar = true;
					ovniBonus.puedeDisparar = true;
				}
			}
	}
	
	
	//Colision contra estructuras
	private function ColisionEstructura():Void
	{
		if (nave.disparo != null)
		{
			for (i in 0... estructuras.length)
			{
				if (FlxG.overlap(estructuras.members[i], nave.disparo))
				{
					estructuras.members[i].CambiarAnimacion();
					nave.disparo.destroy();
					nave.puedeDisparar = true;
				}
			}
		}
		
		for (i in 0... enemigos.length)
		{
			if (enemigos.members[i].disparo != null)
			{
				for (j in 0... estructuras.length)
				{
					if (FlxG.overlap(estructuras.members[j], enemigos.members[i].disparo))
					{
						estructuras.members[j].CambiarAnimacion();
						enemigos.members[i].disparo.destroy();
						enemigos.members[i].puedeDisparar = true;
					}
					
					if (FlxG.overlap(estructuras.members[j], enemigos.members[i]))
					{
						estructuras.members[j].CambiarAnimacion();
					}
				}
			}
		}
		
		if (ovniBonus != null)
		{
			if (ovniBonus.disparo != null)
			{
				for (i in 0... estructuras.length)
				{
					if (FlxG.overlap(estructuras.members[i], ovniBonus.disparo))
					{
						estructuras.members[i].CambiarAnimacion();
						ovniBonus.disparo.destroy();
						ovniBonus.puedeDisparar = true;
					}
				}
			}
		}
	}
	
	
	//Para cualquier colision con un enemigo
	private function ColisionEnemigo(disparo:Disparo, alien:Enemigo):Bool
	{
		if (disparo != null && alien != null)
		{
			if (alien.murio == false)
			{
				if (FlxG.overlap(disparo, alien))
				{
					alien.animation.play("muerte", false, false, 1);
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
	private function ColisionJugador(aliens:FlxTypedGroup<Enemigo>, enemigo:Ovni, jugador:Nave):Bool
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
			
			if (enemigo != null && enemigo.disparo != null)
			{
				if (FlxG.overlap(enemigo.disparo, jugador))
				{
					return true;
				}
			}
			
			return false;
	}
	
	
	private function ComprobarColisionJugador(aliens:FlxTypedGroup<Enemigo>, enemigo:Ovni, jugador:Nave):Void
	{
		if (ColisionJugador(aliens, enemigo, jugador) && nave.murio == false)
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
			DestruirTodo();
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
				if (ovniBonus != null && ovniBonus.sonido != null)
				{
					ovniBonus.sonido.stop();
				}
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
			DestruirTodo();
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
				Reg.xComienzoEnemigos += Reg.espacioEntreEnemigosX;
			}
			Reg.yComienzoEnemigos += Reg.espacioEntreEnemigosY;
			Reg.xComienzoEnemigos = 14;
		}
		
		add(enemigos);
	}
	
	//Este metodo evita que el timer que usan los enemigos se detenga y el grupo entero se trabe
	private function RegularFramesEnemigos():Void
	{
		if (Reg.framesVelocidadEnemigos != 0.021)
		{
				if (Reg.framesVelocidadEnemigos <= Reg.aceleracionEnemigos + 0.001)
			{
				Reg.aceleracionEnemigos = 0.02;
				Reg.framesVelocidadEnemigos = 0.021;
			}
		}
	}
	
	
	
	//Este metodo hace que los enemigos cambien su sentido y bajen hacia el jugador
	private function CambiarDireccionEnemigos():Void
	{
		for (i in 0... enemigos.length)
		{
			
				if (enemigos.members[i].x >= limite && !direccionIzqEnemigos)
				{
					limite = Reg.leftXLimit + 4;
					direccionIzqEnemigos = true;
					enemigos.forEachAlive(BajarEnemigos);
					Reg.YBajadaEnemigos = 0;
					break;
				}
				if (enemigos.members[i].x <= limite && direccionIzqEnemigos)
				{
					limite = Reg.rightXLimit + 6;
					direccionIzqEnemigos = false;
					enemigos.forEachAlive(BajarEnemigos);
					Reg.YBajadaEnemigos = 0;
					break;
				}	
			
		}
	}
	
	private function BajarEnemigos(e:Enemigo):Void
	{
		e.direccion *= -1;
		e.y += Reg.YBajadaEnemigos;
	}
	
	private function OnComplete(timer:FlxTimer):Void
	{
		if (Reg.pausa == false)
		{
			EnemigoRandomDispara();
			Reg.spawnOvniTime++;
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
		if (Reg.musicaEnemigos && !Reg.musicaOvni)
		{
			Reg.musicaEnemigos = false;
			
			if (sonidoNum == 1)
			{
				sonidoNum = 2;
				Sounds.sonEneUno.play();
			}
			else if (sonidoNum == 2)
			{
				sonidoNum = 3;
				Sounds.sonEneDos.play();
			}
			else if (sonidoNum == 3)
			{
				sonidoNum = 4;
				Sounds.sonEneTres.play();
			}
			else if (sonidoNum == 4)
			{
				sonidoNum = 1;
				Sounds.sonEneCuatro.play();
			}
		}
	}
	
	private function SpawnOvni():Void
	{
		if (Reg.spawnOvniTime % 23 == 0)
		{
			ovniBonus = new Ovni(Reg.xComienzoOvni, Reg.yComienzoOvni);
			ovniBonus.tipo = 4;
			ovniBonus.CargarSprite();
			add(ovniBonus);
			Reg.spawnOvniTime++;
			
			Reg.musicaEnemigos = false;
			Reg.musicaOvni = true;
			
			if (Reg.spawnOvniTime == 100)
			{
				Reg.spawnOvniTime = 1;
			}
		}
	}
	
	private function DestruirTodo():Void
	{
		hud.destroy();
		nave.destroy();
		timer.destroy();
		enemigos.destroy();
		estructuras.destroy();
		if (ovniBonus != null)
		{
			ovniBonus.destroy();
		}
	}
}
