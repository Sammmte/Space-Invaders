package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Sounds
{
	static public var sonEneUno:FlxSound;
	static public var sonEneDos:FlxSound;
	static public var sonEneTres:FlxSound;
	static public var sonEneCuatro:FlxSound;
	static public var muerteNave:FlxSound;
	static public var muerteEnemigo:FlxSound;
	static public var disparo:FlxSound;
	static public var sonidoOvni:FlxSound;
	
	static public function Init():Void
	{
		sonEneUno = FlxG.sound.load(AssetPaths.sonEne1__wav, false);
		sonEneDos = FlxG.sound.load(AssetPaths.sonEne2__wav, false);
		sonEneTres = FlxG.sound.load(AssetPaths.sonEne3__wav, false);
		sonEneCuatro = FlxG.sound.load(AssetPaths.sonEne4__wav, false);
		muerteNave = FlxG.sound.load(AssetPaths.explosion__wav, false);
		muerteEnemigo = FlxG.sound.load(AssetPaths.invaderkilled__wav, false);
		disparo = FlxG.sound.load(AssetPaths.shoot__wav, false);
		sonidoOvni = FlxG.sound.load(AssetPaths.ufo_lowpitch__wav, true);
	}
	
	public function new() 
	{
		
	}
	
}