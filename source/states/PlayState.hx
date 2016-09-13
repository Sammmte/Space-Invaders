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
import sprites.Nave;
import Reg;
import Fonts;
import Sounds;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import states.AuxState;
import states.PauseState;
import flixel.system.FlxAssets.FlxGraphicAsset;

class PlayState extends FlxState
{
	private var nave:Nave;
	private var enemigos:FlxTypedGroup<Enemigo>;
	//Auxiliar para manejar la direccion del grupo de enemigos
	private var direccionIzqEnemigos:Bool = false;
	private var timer:FlxTimer;
	private var perdio:Bool = false;
	private var gano:Bool = false;
	private var enemigosMuertosIndex:Array<Int>;
	private var sonidoMusicaEnemigos:FlxSound;
	private var vidasSprite:Nave;
	
	//Aca estan los scores. Cualquier cosa, mirar parametros y metodos de objetos FlxText
	
	private var scoreText:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		Fonts.Init();
		Sounds.Init();
		
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
		
		//Se revisan las fuentes embebidas
		
		
		sonidoMusicaEnemigos = new FlxSound();
		sonidoMusicaEnemigos = Sounds.sonEneUno;
		
		//vidasSprite = new Nave(128, 3);
		//add(vidasSprite);
		
		//Aca se agregar los scores a la pantalla. Revisar comentarios en AddScores()
		AddScores();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		ComprobarGano();
		CambiarDireccionEnemigos();
		ComprobarEnemigosColision(nave.disparo);
		ComprobarColisionJugador();
		RegularFramesEnemigos();
		//ComprobarPerdio();
		Pausar();
		MusicaEnemigos();
	}
	
	private function Reset():Void
	{
		Reg.contEnemigos = 0;
		enemigos.destroy();
		nave.DestruirTodo();
		sonidoMusicaEnemigos.destroy();
		nave.destroy();
		timer.destroy();
		FlxG.resetState();
	}
	
	private function ComprobarGano():Void
	{
		if (gano)
		{	
			gano = false;
			Reg.pausa = false;
			openSubState(new PauseState());
			Reset();
		}
	}
	
	private function Pausar():Void
	{
		if (Reg.pausa == false)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				Reg.pausa = true;
				openSubState(new PauseState());
			}
		}
	}
	
	private function AddScores():Void
	{
		/*
		 Hay una clase Fonts para fuentes embebidas. Es estatica y publica y sus atributos y metodos tambien lo son
		 pixeledFont es la variable de tipo String que contiene la direccion al archivo de la fuente.
		 llamar escribiendo Fonts.pixeledFont
		 
		 
		 Hay dos variables para el score en la clase estatica Reg:
		 
		 score:Int = 0
		 highScore:Int = 0
		 
		 para actualizar el score, el mejor metodo seria utilizar una string con el texto "score: " (texto:String = "score: ") y que a la vez tenga sumado-
		 el numero del score (texto:String = "score: " + Reg.score)
		 
		 De esta manera se puede actualizar el numero del score en cualquier momento y lugar y no enloquecerse con la string del score.
		 
		*/
		 
		/*
		 Esta funcion es privada y esta exclusivamente para agregar los scores al PlayState
		 Para actualizar los scores conviene utilizar un metodo dedicado a eso
		 */
	}
	
	private function ComprobarPerdio():Void
	{
		if (perdio)
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
						perdio = true;
						return true;
					}
				}
			}	
			
			return false;
	}
	
	
	private function ComprobarColisionJugador():Void
	{
		if (ColisionJugador(enemigos, nave))
		{
			nave.Muerte();
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
				gano = true;
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
