package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<String> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Nombre - Icono - Descripcion - Link - Color del fondo
			['Creditos VS Juize'],
			['JUIZEPANKA',		'nothing',		'Director y cosas de sprites', '',	0xFFFFD94F],
			['EDGARXAMMAR',		'nothing',		'Dibujante', '',	0xFFF28bb1],
			['JUANEN100',		'nothing',		'Programador', '',	0xFFffeb23],
			['SAMURAMOGEDEV',		'nothing',		'Charter', '',	0xFF828b1d],
			['KHARY',		'nothing',		'Voces (No se porque tenemos "voces" lol)', '',	0xFF728b5d],
			['BITFOXORIGINAL', 'nothing', 'Instrumental', '', 0xFFF28bb1],
			['NEXXOS',		'nothing',		'Arreglo de sprites y personas del fondo', '',	0xFF328b4f],
			[''],
			["Creador del Engine"],
			['KADE DEV',			'nothing',	'El que creo el Kade Engine (Sos alto capo)', 'https://www.youtube.com/channel/UCoYksltIxNuSHz_ERzoRP6g',	0xFFffd700],
			[''],
			["Gracias especiales"],
			['MDC',			'nothing',	'Por la ayuda en su server\nDe discord',			'https://www.youtube.com/channel/UCFYmRctVlFLZWOXhqq7L9Sg',	0xFF67ce8e],
			['SHRUKEN6057',			'nothing',	'Por sus tutoriales\nDe Youtube',			'https://www.youtube.com/channel/UCSglueqfzKFFat7T7PPHfDw',	0xFF4166f5],
			['PABLOELPROXD210',		'nothing',		'El que implemento algunas cosas fachas',	'https://www.tiktok.com/@furrosdemoniofreefire',	0xFF228b22],
			['ELSLENDYTUBERO',		'nothing',		'El que ayudó con el sistema de traducción',	'https://www.youtube.com/channel/UCDc6xlBIlQejgCpL9aiOwgw',	0xFF228b22]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	private var intendedColor:Int;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Credits", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}

		if (controls.BACK)
		{
			FlxTween.cancelTweensOf(bg);
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(FlxG.save.data.language)
			{
				FlxG.switchState(new MainMenuStateSpanish());
			}
			else
			{
				FlxG.switchState(new MainMenuState());
			}
		}
		if(controls.ACCEPT) {
			fancyOpenURL(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			FlxTween.cancelTweensOf(bg);
			intendedColor = newColor;
			FlxTween.color(bg, 1, bg.color, intendedColor);
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
