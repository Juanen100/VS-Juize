package;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.*;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;


class AudiphonesState extends MusicBeatState
{
	var thx:FlxSprite;
	var thx_en:FlxSprite;
	var music:FlxSound;
	var wentout:Bool = false;
	override function create()
	{
		super.create();
		FlxG.sound.music.fadeIn(0.5, 0.7, 0.1);
		if(FlxG.save.data.language)
		{
			thx = new FlxSprite(0, 0).loadGraphic(Paths.image('warning', 'preload'));
			add(thx);
			remove(thx_en);
		}
		else
		{
			thx_en = new FlxSprite(0, 0).loadGraphic(Paths.image('warning_en', 'preload'));
			add(thx_en);
			remove(thx);
		}
		
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && !wentout)
		{
			wentout = true;
			FlxG.sound.music.fadeIn(0.5, 0.1, 0.7);
			if(FlxG.save.data.language)
			{
				FlxG.switchState(new MainMenuStateSpanish());
			}
			else
			{
				FlxG.switchState(new MainMenuState());
			}
		}
		super.update(elapsed);
	}
	
}