package;
import flixel.math.FlxRandom;

/**
 * ...
 * @author ...
 */
class Reg
{
	static public var highscore:Int = 0;
	inline static public var playerVelX:Int = 2;
	inline static public var playerX:Int = 70;
	inline static public var playerY:Int = 110;
	inline static public var shotVelocity:Int = -100;
	inline static public var leftXLimit:Int = 9;
	inline static public var rightXLimit:Int = 135;
	inline static public var cantidadEnemigos:Int = 55;
	static public var xComienzoEnemigos:Int = 20;
	static public var yComienzoEnemigos:Int = 10;
	inline static public var enemigosFilas:Int = 5;
	inline static public var enemigosColumnas:Int = 11;
	inline static public var espacioEntreEnemigos:Int = 11;
	static public var random:FlxRandom;
	
	public function new() 
	{
		
	}
	
}