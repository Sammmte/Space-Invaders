package;
import flixel.FlxSprite;
import flixel.math.FlxRandom;

/**
 * ...
 * @author ...
 */
class Reg
{
	/*<<<<<<<<<<<<POSICIONES>>>>>>>>>>>>>>*/
	
	inline static public var playerX:Int = 70;
	inline static public var playerY:Int = 133;
	inline static public var leftXLimit:Int = 9;
	inline static public var rightXLimit:Int = 135;
	static public var xComienzoEnemigos:Int = 15;
	static public var yComienzoEnemigos:Int = 25;
	inline static public var xComienzoOvni:Int = 160;
	inline static public var yComienzoOvni:Int = 15;
	inline static public var yEstructuras:Int = 110;
	
	/*<<<<<<<<<<<<PROPIEDADES>>>>>>>>>>>>>>*/
	
	inline static public var playerVelX:Float = 0.7;
	inline static public var disparoVelocityPlayer:Int = -100;
	inline static public var disparoVelocityEnemy:Int = 140;
	static public var cantidadEnemigos:Int = 40;
	inline static public var enemigosFilas:Int = 5;
	inline static public var enemigosColumnas:Int = 8;
	static public var framesVelocidadEnemigos:Float = 1;
	static public var aceleracionEnemigos:Float = 0.014;
	static public var perdio:Bool = false;
	static public var gano:Bool = false;
	static public var vidas:Int = 3;
	static public var score:Int = 0;
	static public var highScore:Int = 0;
	static public var cantidadEstructuras:Int = 4;
	
	/*<<<<<<<<<<<<AUXILIARES>>>>>>>>>>>>>>*/
	
	inline static public var espacioEntreEnemigosX:Int = 15;
	inline static public var espacioEntreEnemigosY:Int = 10;
	inline static public var YBajadaEnemigos:Int = 4;
	static public var enemigosDisparoDelay:Float = 2;
	static public var contEnemigos:Int = 0;
	static public var delayDeMuerte:Float = 2;
	static public var pausa:Bool = false;
	static public var musicaEnemigos:Bool = false;
	static public var musicaOvni:Bool = false;
	static public var aumentoAceleracion:Float = 0.01;
	static public var resets:Int = 1;
	static public var random:FlxRandom;
	static public var spawnOvniTime:Int = 1;
	
	public function new() 
	{
		
	}
	
}