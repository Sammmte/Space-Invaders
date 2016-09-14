package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class HUD extends FlxSprite
{
	private var score:FlxText;
	private var highScore:FlxText;
	private var vidasSprite:FlxSprite;
	private var vidasText:FlxText;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		score = new FlxText(5, 1, 0, "Score: " + Reg.score, 5, true);
		score.font = Fonts.pixeledFont;
		highScore = new FlxText(65, 1, 0, "Hi-Score: " + Reg.highScore, 5, true);
		highScore.font = Fonts.pixeledFont;
		vidasText = new FlxText(140, 1, 0, " = " + Reg.vidas, 5, true);
		vidasText.font = Fonts.pixeledFont;
		
		vidasSprite = new FlxSprite(129, 3);
		vidasSprite.loadGraphic(AssetPaths.jugadorlala__png, true, 13, 9);
		
		FlxG.state.add(score);
		FlxG.state.add(highScore);
		FlxG.state.add(vidasText);
		FlxG.state.add(vidasSprite);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
	}
	
	public function UpdateScore(puntos:Int):Void
	{
		Reg.score += puntos;
		if (Reg.score > Reg.highScore)
		{
			Reg.highScore += puntos;
		}
		
		FlxG.state.remove(score);
		FlxG.state.remove(highScore);
		score.text = "Score: " + Reg.score;
		highScore.text = "Hi-Score: " + Reg.highScore;
		FlxG.state.add(score);
		FlxG.state.add(highScore);
	}
	
	public function UpdateVidas():Void
	{
		FlxG.state.remove(vidasText);
		vidasText.text = " = " + Reg.vidas;
		FlxG.state.add(vidasText);
	}
}