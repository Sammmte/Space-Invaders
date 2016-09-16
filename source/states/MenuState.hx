package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.ResultState;
import openfl.Assets;
import flixel.util.FlxColor;
import Fonts;
import Sounds;

class MenuState extends FlxState
{
	private var splashScreen:FlxSprite;
	private var aux:Bool = false;
	private var titulo:FlxSprite;
	private var presentacion:Bool = false;
	private var text:FlxText;
	private var sonidoOhYes:FlxSound;
	private var sonidoSeleccion:FlxSound;
	
	override public function create():Void
	{
		super.create();
		
		Fonts.Init();
		Sounds.Init();
		
		splashScreen = new FlxSprite(0, 0);
		splashScreen.loadGraphic(Assets.getBitmapData("assets/images/splash.jpeg"));
		splashScreen.alpha = 0;
		
		text = new FlxText(3, 70);
		text.size = 5;
		text.fieldWidth = 160;
		text.alignment = "center";
		text.text = "PRESS START\n\n\nPAPUS STUDIOS\n\nLICENSED TO GAMES ON ACID";
		text.alpha = 0;
		text.font = Fonts.pixeledFont;
		
		titulo = new FlxSprite(10, 200);
		titulo.loadGraphic(Assets.getBitmapData("assets/images/titulo.png"));
		
		sonidoOhYes = Sounds.sonidoOhYes;
		sonidoOhYes.onComplete = PresentacionTrue;
		
		sonidoSeleccion = Sounds.sonidoSeleccion;
		sonidoSeleccion.onComplete = Switch;
		
		add(titulo);
		add(text);
		add(splashScreen);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (!aux)
		{
			SplashScreen();
		}
		else
		{
			Menu();
		}
	}
	
	private function SplashScreen():Void
	{
		if (!presentacion)
		{
			splashScreen.alpha += 0.015;
			if (splashScreen.alpha == 1)
			{
				sonidoOhYes.play();
			}
		}
		
		if (presentacion)
		{
			splashScreen.alpha -= 0.015;
			if (splashScreen.alpha == 0)
			{
				aux = true;
			}
		}
		
	}
	
	private function PresentacionTrue():Void
	{
		presentacion = true;
	}
	
	private function Menu():Void
	{
		
		if (titulo.y <= 5)
		{
			text.alpha += 0.015;
			if (FlxG.keys.justPressed.ENTER)
			{
				sonidoSeleccion.play();
			}
		}
		else
		{
			titulo.y -= 0.7;
		}
	}
	
	private function Switch():Void
	{
		splashScreen.destroy();
		titulo.destroy();
		FlxG.switchState(new ResultState());
	}
}
