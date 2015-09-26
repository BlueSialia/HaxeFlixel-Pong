package ;

import flixel.util.FlxRandom;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

    private static inline var PLAYER_SPEED:Int = 250;

    private var _player_:FlxSprite;
    private var _enemy_:FlxSprite;
    private var _ball_:FlxSprite;
    private var _topWall_:FlxSprite;
    private var _bottomWall_:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        FlxG.mouse.visible = false;

        _player_ = new FlxSprite(10,180);
        _player_.makeGraphic(10, 100, FlxColor.WHITE);
        _player_.immovable = true;

        _enemy_ = new FlxSprite(620,180);
        _enemy_.makeGraphic(10, 100, FlxColor.WHITE);
        _enemy_.immovable = true;

        _ball_ = new FlxSprite(320, 240);
        _ball_.makeGraphic(6, 6, FlxColor.WHITE);
        _ball_.elasticity = 1;
        _ball_.maxVelocity.set(300, 500);
        _ball_.velocity.x = 100;
        _ball_.velocity.y = -100;

        _topWall_ = new FlxSprite(0, 0);
        _topWall_.makeGraphic(640, 10, FlxColor.GRAY);
        _topWall_.immovable = true;

        _bottomWall_ = new FlxSprite(0, 470);
        _bottomWall_.makeGraphic(640, 10, FlxColor.GRAY);
        _bottomWall_.immovable = true;

        add(_player_);
        add(_enemy_);
        add(_ball_);
        add(_topWall_);
        add(_bottomWall_);

    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

        if (_ball_.x < -10 || _ball_.x > 650)
        {
            FlxG.resetGame();
        }

        _player_.velocity.y = 0;
        _enemy_.velocity.y = 0;

        if (FlxG.keys.anyPressed(["UP", "W"]) && _player_.y > 10)
        {
            _player_.velocity.y = - PLAYER_SPEED;
        }
        else if (FlxG.keys.anyPressed(["DOWN", "S"]) && _player_.y < 370)
        {
            _player_.velocity.y = PLAYER_SPEED;
        }

        if (_player_.y < 10)
        {
            _player_.y = 10;
        }
        if (_player_.y > 370)
        {
            _player_.y = 370;
        }

        if (_enemy_.y+50 < _ball_.y+3)
        {
            _enemy_.velocity.y = PLAYER_SPEED;
        }
        if (_enemy_.y+50 > _ball_.y+3)
        {
            _enemy_.velocity.y = - PLAYER_SPEED;
        }
        if (_enemy_.y < 10)
        {
            _enemy_.y = 10;
        }
        if (_enemy_.y > 370)
        {
            _enemy_.y = 370;
        }


        FlxG.collide(_ball_, _player_, ping);
        FlxG.collide(_ball_, _enemy_, ping);
        FlxG.collide(_ball_, _topWall_);
        FlxG.collide(_ball_, _bottomWall_);
	}

    private function ping(Ball:FlxObject, Bat:FlxObject):Void
    {
        if (Ball.velocity.x > 0)
        {
            Ball.velocity.x += 25;
        }
        else
        {
            Ball.velocity.x -= 25;
        }

        var batmid:Int = Std.int(Bat.y) + 50;
        var ballmid:Int = Std.int(Ball.y) + 3;
        var diff:Int;

        if (ballmid < batmid)
        {
// Ball is on the left of the bat
            diff = batmid - ballmid;
            Ball.velocity.y = Ball.velocity.y - 3*diff;
        }
        else
        {
// Ball on the right of the bat
            diff = ballmid - batmid;
            Ball.velocity.y = Ball.velocity.y + 3*diff;
        }
    }
}