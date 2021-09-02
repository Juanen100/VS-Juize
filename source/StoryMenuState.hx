package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	//Warning: All related with "nohard" was a shitty test I made
	
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Wake-Up', 'Rolling', 'Remix'],
		['Ignite', 'Bruh'],
		['U cant play']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, false, true];

	var weekCharacters:Array<Dynamic> = [
		['juize', 'bf', 'gf'],
		['juize', 'bf', 'gf'],
		['juizealt', 'bfalt', 'gfalt']
	];

	var weekNames:Array<String> = [
		"Vs Juize",
		"Juize is angry",
		"?"
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist1:FlxSprite;
	var txtTracklist2:FlxSprite;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var Week1SelectEpic:FlxSprite;
	var Week2SelectEpic:FlxSprite;
	var weekWhatSelectEpic:FlxSprite;
	var weekNote1:FlxSprite;
	var weekNote2:FlxSprite;
	var weekLocked:FlxSprite;
	var weekWhat:FlxSprite;
	var juizeepic:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		if (FlxG.save.data.progress > 0)
			{
				weekUnlocked[1] = true;
				weekUnlocked[3] = true;
				if (FlxG.save.data.progress > 1)
				{
					weekUnlocked[2] = true;
					weekUnlocked[3] = true;
				}
			}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(350, 6).makeGraphic(FlxG.width, 500, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		Week1SelectEpic = new FlxSprite(210, 50);
		Week1SelectEpic.frames = Paths.getSparrowAtlas('story/campaign_menu_UI_assets', 'shared');
		Week1SelectEpic.animation.addByPrefix('idle', 'EpicJuzSelect', 24, true);
		Week1SelectEpic.scale.y = 0.50;
		Week1SelectEpic.scale.x = 0.50;
		Week1SelectEpic.antialiasing = true;
		add(Week1SelectEpic);

		Week2SelectEpic = new FlxSprite(210, 160);
		Week2SelectEpic.frames = Paths.getSparrowAtlas('story/campaign_menu_UI_assets', 'shared');
		Week2SelectEpic.animation.addByPrefix('idle', 'EpicJuzSelect', 24, true);
		Week2SelectEpic.scale.y = 0.50;
		Week2SelectEpic.scale.x = 0.50;
		Week2SelectEpic.antialiasing = true;
		add(Week2SelectEpic);
		
		weekWhatSelectEpic = new FlxSprite(210, 270);
		weekWhatSelectEpic.frames = Paths.getSparrowAtlas('story/campaign_menu_UI_assets', 'shared');
		weekWhatSelectEpic.animation.addByPrefix('idle', 'EpicJuzSelect', 24, true);
		weekWhatSelectEpic.scale.y = 0.50;
		weekWhatSelectEpic.scale.x = 0.50;
		weekWhatSelectEpic.antialiasing = true;
		add(weekWhatSelectEpic);

		Week1SelectEpic.animation.play('idle');
		Week2SelectEpic.animation.play('idle');
		weekWhatSelectEpic.animation.play('idle');

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[1])
			{
				weekLocked = new FlxSprite(-50, 470);
				weekLocked.frames = Paths.getSparrowAtlas('story/weekLocked', 'shared');
				weekLocked.animation.addByPrefix('lock', 'weekLockedEpicamente');
				weekLocked.scale.x = 0.85;
				weekLocked.scale.y = 0.85;
				weekLocked.animation.play('lock');
				weekLocked.antialiasing = true;
				add(weekLocked);
			}
			else if (weekUnlocked[2])
			{
				remove(weekLocked);
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(700, 550);
		leftArrow.frames = ui_tex;
		leftArrow.scale.x = 1.5;
		leftArrow.scale.y = 1.5;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(850, 550);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.scale.x = 1.5;
		sprDifficulty.scale.y = 1.5;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(1250, 550);
		rightArrow.frames = ui_tex;
		rightArrow.scale.x = 1.5;
		rightArrow.scale.y = 1.5;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");
		
		add(yellowBG);
		add(grpWeekCharacters);

		juizeepic = new FlxSprite(420, -90).loadGraphic(Paths.image("story/hehehehehe", "shared"));
		add(juizeepic);

		txtTracklist1 = new FlxSprite(380, 460).loadGraphic(Paths.image("story/Trackwek1", "shared"));
		txtTracklist1.antialiasing = true;
		txtTracklist1.scale.y = 0.55;
		txtTracklist1.scale.x = 0.55;
		add(txtTracklist1);

		txtTracklist2 = new FlxSprite(380, 460).loadGraphic(Paths.image("story/trackwek2", "shared"));
		txtTracklist2.antialiasing = true;
		txtTracklist2.scale.y = 0.55;
		txtTracklist2.scale.x = 0.55;
		add(txtTracklist2);

		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 165");
		
		weekNote1 = new FlxSprite(-15, 100).loadGraphic(Paths.image("story/week0", "shared"));
		weekNote1.antialiasing = true;
		weekNote1.scale.y = 0.85;
		weekNote1.scale.x = 0.85;
		add(weekNote1);

		weekNote2 = new FlxSprite(-15, 210).loadGraphic(Paths.image("story/week1", "shared"));
		weekNote2.antialiasing = true;
		weekNote2.scale.y = 0.85;
		weekNote2.scale.x = 0.85;
		add(weekNote2);

		weekWhat = new FlxSprite(-15, 320).loadGraphic(Paths.image("story/weekwhat", "shared"));
		weekWhat.antialiasing = true;
		weekWhat.scale.y = 0.85;
		weekWhat.scale.x = 0.85;
		add(weekWhat);

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (curWeek == 0)
			{
				Week1SelectEpic.visible = true;
				Week2SelectEpic.visible = false;
				weekWhatSelectEpic.visible = false;
				txtTracklist1.visible = true;
				txtTracklist2.visible = false;
				juizeepic.visible = false;
				weekWhat.visible = false;
			}
		else if (curWeek == 1)
			{
				Week1SelectEpic.visible = false;
				Week2SelectEpic.visible = true;
				weekWhatSelectEpic.visible = false;
				txtTracklist1.visible = false;
				txtTracklist2.visible = true;
				juizeepic.visible = false;
				weekWhat.visible = false;
			}
		else if (curWeek == 2)
			{
				Week1SelectEpic.visible = false;
				Week2SelectEpic.visible = false;
				weekWhatSelectEpic.visible = true;
				txtTracklist1.visible = false;
				txtTracklist2.visible = false;
				weekWhat.visible = true;
				juizeepic.visible = true;
			}

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
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

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				if (curWeek == 0)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}
				else if (curWeek == 1)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}
				else if (curWeek == 2)
				{
					FlxG.sound.play(Paths.sound('terrorambiencefnafsoundcredits'));
				}

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}
			
			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
				case 3:
					diffic = '-nohard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (curWeek == 2)
				{
					FlxG.switchState(new StoryMenuState());
				}
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 3:
				sprDifficulty.animation.play('nohard');
				sprDifficulty.offset.x = 70;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
