package source.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.ResultState;
import openfl.Assets;
import flixel.util.FlxColor;
import Fonts;

class MenuState extends FlxState
{
	private var splashScreen:FlxSprite;
	private var aux:Bool = false;
	private var titulo:FlxSprite;
	private var presentacion:Bool = false;
	private var text:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		Fonts.Init();
		
		splashScreen = new FlxSprite(0, 0);
		splashScreen.loadGraphic(Assets.getBitmapData("assets/images/splash.png"));
		splashScreen.alpha = 0;
		
		text = new FlxText(3, 70);
		text.size = 5;
		text.fieldWidth = 160;
		text.alignment = "center";
		text.text = "PRESS START\n\n\nPAPUS STUDIOS\n\nLICENSED TO GAMES ON ACID";
		text.alpha = 0;
		text.font = Fonts.pixeledFont;
		
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
				Sys.sleep(2);
				presentacion = true;
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
	
	private function Menu():Void
	{
		text.alpha += 0.015;
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(new ResultState());
		}
	}
}
