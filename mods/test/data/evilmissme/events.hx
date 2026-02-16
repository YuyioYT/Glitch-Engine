
import lime.app.Application;
import Sys;
import flixel.FlxG;


//coded in 2 minutes by smokey(5 not 99) ok
var fuckingShader;

var OGDadX:Float = 0;
var OGDadY:Float = 0;

var evilZib:FlxSprite;
function onCreate():Void {
	skipArrowStartTween = true;


	introVid = new VideoSprite().preload('songs/miss-me/giygas-earthbound', [VideoSprite.MUTED,VideoSprite.LOOPING]);
	introVid.onReady.addOnce(() -> {
		introVid.cameras = [camGame];
		introVid.setGraphicSize(FlxG.width * 8);
		introVid.updateHitbox();
		introVid.screenCenter();
		videoLoaded = true;
		skipCountdown = true;
		startCountdown();
	});

	addBehindGF(introVid);
	introVid.alpha = 0; 
	introVid.playVideo();


	



	fuckingShader  = createRuntimeShader("red");
	



	camHUD.filters = [new ShaderFilter(fuckingShader)];
	// game.uiGroup.forEach(function(spr:FlxSprite)
	// 	{
	// 		spr.setColorTransform(1.0, 0.0,0.0,1.0, 0.0,0.0,0.0,0.0);

	// 	});

	// game.strumLineNotes.forEach(function(spr:FlxSprite)
	// 	{
	// 		spr.setColorTransform(1.0, 0.0,0.0,1.0, 0.0,0.0,0.0,0.0);

	// 	});
	
}






function onBeatHit()
{
	if (curBeat == 64)
	{

		FlxG.camera.flash(FlxColor.WHITE,0.5);
		introVid.alpha = 1;
		boyfriend.setColorTransform(1.0, 0.0,0.0,1.0, 0.0,0.0,0.0,0.0);
		iconP1.setColorTransform(1.0, 0.0,0.0,1.0, 0.0,0.0,0.0,0.0);
		


	}

	if (curBeat == 194)
	{

		FlxG.camera.flash(FlxColor.WHITE,0.5);
		fuckingShader.setFloat("uActive",1.0);
		
		


	}

	if (curBeat == 258)
	{

		evilZib = dadMap.get("zibevil");

		OGDadX = evilZib.x;
		OGDadY = evilZib.y;
		remove(evilZib);
		
		evilZib.cameras = [camOther];
		evilZib.screenCenter();
		add(evilZib);
		fuckingShader.setFloat("uActive",1.0);
		
		


	}

	if (curBeat == 273)
	{

		evilZib.x = OGDadX;
		evilZib.y = OGDadY;
		evilZib.cameras = [camGame];
		fuckingShader.setFloat("uActive",1.0);
		
		


	}




}


function onEndSong()
{

	//get the fuck out
	FlxG.fullscreen = false;
	Application.current.window.alert("FUCK YOU", "FUCK YOU");
    Sys.exit(0);
	trace("Hello");


}