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
	static public var sonidoPausa:FlxSound;
	static public var sonidoOhYes:FlxSound;
	static public var sonidoSeleccion:FlxSound;
	
	static public function Init():Void
	{
		sonEneUno = FlxG.sound.load(AssetPaths.sonEne1__wav, 1, false);
		sonEneDos = FlxG.sound.load(AssetPaths.sonEne2__wav, 1,false);
		sonEneTres = FlxG.sound.load(AssetPaths.sonEne3__wav, 1,false);
		sonEneCuatro = FlxG.sound.load(AssetPaths.sonEne4__wav, 1,false);
		muerteNave = FlxG.sound.load(AssetPaths.explosion__wav, 1,false);
		muerteEnemigo = FlxG.sound.load(AssetPaths.invaderkilled__wav, 1,false);
		disparo = FlxG.sound.load(AssetPaths.shoot__wav, 1,false);
		sonidoOvni = FlxG.sound.load(AssetPaths.ufo__wav, 1, true);
		sonidoPausa = FlxG.sound.load(AssetPaths.pausa__wav, 1, false);
		sonidoOhYes = FlxG.sound.load(AssetPaths.ohyes__wav, 1, false);
		sonidoSeleccion = FlxG.sound.load(AssetPaths.seleccion__wav, 1, false);
	}
	
	public function new() 
	{
		
	}
	
}