package;
import flixel.FlxSprite;
import flixel.FlxG;

class Ending extends MusicBeatState
{

	public function new() 
	{
		super();
		bgColor = 0xFF000000;
	}
	
	override function create() 
	{
		super.create();
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("epic_ending", "shared"));
		add(bg);
		
	}
	
	
	override function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		if (controls.ACCEPT){
			FlxG.switchState(new MainMenuState());
		}
		
	}
}