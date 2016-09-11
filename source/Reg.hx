package;
import flixel.math.FlxRandom;

/**
 * ...
 * @author ...
 */
class Reg
{
	static public var highscore:Int = 0;
	inline static public var playerVelX:Float = 0.7;
	inline static public var playerX:Int = 70;
	inline static public var playerY:Int = 225;
	inline static public var disparoVelocityPlayer:Int = -220;
	inline static public var disparoVelocityEnemy:Int = 170;
	inline static public var leftXLimit:Int = 9;
	inline static public var rightXLimit:Int = 199;
	static public var cantidadEnemigos:Int = 55;
	static public var xComienzoEnemigos:Int = 15;
	static public var yComienzoEnemigos:Int = 50;
	inline static public var enemigosFilas:Int = 5;
	inline static public var enemigosColumnas:Int = 11;
	inline static public var espacioEntreEnemigos:Int = 17;
	inline static public var YBajadaEnemigos:Int = 4;
	static public var framesVelocidadEnemigos:Float = 1;
	static public var enemigosDisparoDelay:Float = 2;
	static public var contEnemigos:Int = 0;
	static public var delayDeMuerte:Float = 2;
	static public var vidas:Int = 3;
	static public var aceleracionEnemigos:Float = 0.02;
	static public var random:FlxRandom;
	
	public function new() 
	{
		
	}
	
}