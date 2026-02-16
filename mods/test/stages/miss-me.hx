/*
var bgGradient:FlxSprite;
var bgShader;
var bgShaderTween;
var bg;
var introVid;

// i need autocomplete ok
var neoCam:Neocam = ncGame;
var neoCamHUD:Neocam = ncHUD;

var zibOffsetScale:Float = 16;
var bfOffsetScale:Float = 12;

var bfZoom:Float = 0.87;
var zibZoom:Float = 0.7;
var onFocusZoom:Bool = false;

function onCreate() {
	bg = new FlxSprite();
	bg.makeGraphic(1280 * 1.75, 730 * 1.75, 0xffff0000);
	bg.cameras = [camGame];
	bg.scrollFactor.set(0, 0);
	bg.screenCenter();
	addBehindGF(bg);

	
	bgGradient = new FlxSprite();
	bgGradient.loadGraphic(FlxGradient.createGradientBitmapData(2, 400, [0xff4f4f4f, 0x00434242], 1, 90));
	bgGradient.scale.set(2000, 2);
	bgGradient.updateHitbox();
	bgGradient.setPosition(-1000, -200);
	bgGradient.cameras = [camGame];
	//bgGradient.scrollFactor.set(0.1, 0.1);
	addBehindGF(bgGradient);
	
	bgShader = createRuntimeShader("missme");
	bgShader.setFloat("u_mix", 0);
	bg.shader = bgShader;
	
	game.skipCountdown = true;
}

function onReady() {
	introVid = new VideoSprite().preload('songs/missme/intro', [VideoSprite.MUTED]);
	introVid.onReady.addOnce(() -> {
		introVid.setGraphicSize(FlxG.width);
		introVid.updateHitbox();
		introVid.cameras = [camHUD];
	});	
	add(introVid);

	isCameraOnForcedPos = true;
	


}

function onUpdate(elapsed:Float):Void {
	bgShader.setFloatArray("u_offset", [neoCam.position.x.applied / bg.width / 2,
		neoCam.position.y.applied / bg.height / 2]);
	bgShader.setFloat("u_time", getShaderTime());


	if (FlxG.keys.justPressed.TWO)
		remove(introVid);

	var zibPos = getCharacterFocusPosition(1);
	var bfPos = getCharacterFocusPosition(0);
	bgGradient.angle = -neoCam.angle.cur;
	bgGradient.y = FlxMath.remapToRange(neoCam.position.x.cur,zibPos[0],bfPos[0],-700,-1000);

	//trace(bgGradient.y);
	//trace(neoCam.zoom.cur);
}

function opponentNoteHitPre(note:Note) {
	switch (note.noteType) {
		case "Shig":
			note.animSuffix = "-shig";
	}
}

function onEvent(name:String, v1:String, v2:String, strumTime:Float) {
	switch (name) {
		case "Laugh":
			dad.playAnim("lol", true);
			dad.specialAnim = true;

			var length = (Conductor.stepCrochet / 1000) * 1.2;
			//neoCam.angle.target += 3;
			//neoCam.zoom.target += 0.2;
			neoCam.angle.halfLife = 0;
			neoCam.angle.tween(null,neoCam.angle.target + 4,length * 1.5,"expoOut");
			neoCam.zoom.tween(null,neoCam.zoom.target + 0.07,length  * 1.5,"expoOut");

		
		case "Center Camera":
			centerCamera();


		case "Step Zoom":

			var mult = Std.parseFloat(v1);
			if (Math.isNaN(mult)) mult = 1;

			var amt = Std.parseFloat(v2);
			if (Math.isNaN(amt)) amt = -0.06;
			var length = (Conductor.stepCrochet / 1000);
			neoCam.zoom.halfLife = 0;
			neoCam.zoom.tween(null,neoCam.zoom.target + amt,length * mult,"cubeOut");
	}
}


function onSongStart() {
	FlxTween.globalManager.cancelTweensOf(bgGradient, ["y"]);	
	neoCam.setBumpPattern(new IntMap(), 16, 0, true);
	neoCamHUD.setBumpPattern(new IntMap(), 16, 0, true);
	introVid.playVideo();
	moveCamera(true);
	
}


var stepEvents:IntMap<()->Void> = [
	111 => function() {
		// stage.getDad().animation.timeScale = 1;
		FlxTween.globalManager.cancelTweensOf(bgGradient, ["y"]);

		// //doEvent("PlayAnimation", {target: "opponent", anim: "okay", force: true});
		neoCamHUD.alpha.snap(0,true);
		dad.playAnim("okay", true);
		dad.specialAnim = true;
		var beatLength:Float = Conductor.crochet / 1000;
		//FlxTween.tween(bgGradient, {y: -600, alpha: 0.0001}, beatLength * 2.75, {ease: FlxEase.expoIn});
	},

	116 => function() {
		var beatLength:Float = Conductor.crochet / 1000;
		neoCam.zoom.halfLife = 0.1;
		neoCam.position.x.halfLife = 0.1;
		neoCam.position.y.halfLife = 0.1;
		neoCam.position.x.tween(null, 800, beatLength * 1.6, "cubeIn");
		neoCam.position.y.tween(null, 400, beatLength * 1.6, "cubeIn");
		neoCam.zoom.tween(null, 0.6, beatLength * 1.4, "cubeIn");
	},

	128 => function() {
		neoCam.position.x.halfLife = 0.25;
		neoCam.position.y.halfLife = 0.25;
		neoCam.zoom.halfLife = 0.3;
		//neoCam.zoom.tween(null, 0.8, 1, "expoout");
		neoCam.setBumpPattern([0 => 0.015], 16, 128, true);
		neoCamHUD.alpha.halfLife = 0.3;
		neoCamHUD.alpha.tween(null, 1, 0.5, "cubeout");
		neoCamHUD.setBumpPattern([0 => 0.015], 16, 128, true);
		// //doEvent("FocusCamera", {char: 1}); // opponent
		moveCamera(true);
		onFocusZoom = true;
	},

	160 => function() {
		// //doEvent("FocusCamera", {char: 0}); // player
	},

	192 => function() {
		//neoCam.zoom.tween(null, 0.75, 1, "expoout");
		// //doEvent("FocusCamera", {char: 1}); // opponent
	},


	242 => function() {
		//neoCam.zoom.tween(null, 0.6, 1.5, "cubeout");
	},

	248 => function() {
		var pos = getCharacterFocusPosition(1);
		neoCam.position.x.tween(null,pos[0],0.3,"cubeOut");
		neoCam.position.y.tween(null,pos[1] - 50,0.3,"cubeOut");
	},

	255 => function() {
		neoCam.setBumpPattern([0 => 0.015, 4 => 0.01, 12 => 0.01], 16, 256, true);
		neoCamHUD.setBumpPattern([0 => -0.01, 4 => -0.01, 12 => -0.01], 16, 256, true);
	},

	256 => function() {
		neoCam.zoom.tween(null, 0.5, 0.8, "expoOut");
		neoCam.angle.tween(null,0,1.2,"expoOut");
		zibOffsetScale = 25;
		onFocusZoom = false;
		neoCam.noteOffsetScale = zibOffsetScale;
		neoCam.timeScale = 1.1;
	},

	288 => function() {
		// doEvent("FocusCamera", {char: 0}); // player
	},

	320 => function() {
		// doEvent("FocusCamera", {char: 1}); // opponent
	},

	352 => function() {
		// doEvent("FocusCamera", {char: 0}); // player
	},

	368 => function() {
		neoCam.zoom.tween(null, 0.65, 2, "quartout");
	},

	376 => function()
	{
		var pos = getCharacterFocusPosition(1);
		var length = (Conductor.stepCrochet / 1000) * 6;
		neoCam.position.x.halfLife = 0;
		neoCam.position.y.halfLife = 0;
		neoCam.position.x.tween(null,pos[0],length,"cubeOut");
		neoCam.position.y.tween(null,pos[1],length,"cubeOut");

	},

	384 => function()
	{
		neoCam.position.x.halfLife = 0.3;
		neoCam.position.y.halfLife = 0.3;
		neoCam.zoom.halfLife = 0.1;
		neoCam.zoom.cancelTween();
		neoCam.zoom.tween(null, 0.9, 5.55, "linear");

	},

	448 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
		centerCamera();
	},

	480 => function() {
		neoCam.zoom.tween(null, 0.75, 1, "expoout");
		// doEvent("FocusCamera", {char: 0}); // player
	},


	496 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
	},

	512 => function() {
		neoCam.zoom.tween(null, 0.5, 12, "expoout");
		// doEvent("FocusCamera", {char: 1}); // opponent
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		bgShaderTween = FlxTween.num(0, 0.1, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(_) {
				bgShader.setFloat("u_mix", 0.1);
				bgShaderTween = null;
			}
		}, function(v:Float) {
			bgShader.setFloat("u_mix", v);
		});
	},

	640 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
		// //doEvent("FocusCamera", {char: 1}); // opponent
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		bgShaderTween = FlxTween.num(0.1, 0.25, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(_) {
				bgShader.setFloat("u_mix", 0.25);
				bgShaderTween = null;
			}
		}, function(v:Float) {
			bgShader.setFloat("u_mix", v);
		});
	},

	704 => function() {
		// doEvent("FocusCamera", {char: 0}); // player
	},

	751 => function() {
		neoCam.setBumpPattern(new IntMap(), 16, 752, true);
		neoCamHUD.setBumpPattern(new IntMap(), 16, 752, true);
	},

	752 => function() {
		neoCam.zoom.tween(null, 0.65, 1, "quartout");
		centerCamera();
		// doEvent("PlayAnimation", {target: "opponent", anim: "wiggle_no_loop", force: true});
	},

	767 => function() {
		neoCam.setBumpPattern([0 => 0.015, 4 => 0.01, 12 => 0.01], 16, 768, true);
		neoCamHUD.setBumpPattern([0 => 0.015, 4 => 0.01, 12 => 0.01], 16, 768, true);
	},

	768 => function() {
		neoCam.zoom.tween(null, 0.7, 0.25, "expoout");
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		bgShaderTween = FlxTween.num(0.25, 0.5, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(_) {
				bgShader.setFloat("u_mix", 0.5);
				bgShaderTween = null;
			}
		}, function(v:Float) {
			bgShader.setFloat("u_mix", v);
		});
	},

	832 => function() {
		neoCam.zoom.tween(null, 0.75, 1, "expoout");
	},

	888 => function() {
		neoCam.zoom.tween(null, 0.7, 1.5, "cubeout");
	},

	896 => function() {
		neoCam.zoom.tween(null, 0.75, 1, "expoout");
		// doEvent("FocusCamera", {char: 1}); // opponent
	},

	912 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
	},

	928 => function() {
		neoCam.zoom.tween(null, 0.75, 1, "expoout");
		// doEvent("FocusCamera", {char: 0}); // player
	},

	944 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
	},

	946 => function() {
		// doEvent("PlayAnimation", {target: "opponent", anim: "groove", force: true});
	},

	960 => function() {
		neoCam.zoom.tween(null, 0.75, 1, "expoout");
	},

	992 => function() {},

	1008 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
	},

	1023 => function() {
		neoCam.setBumpPattern([0 => 0.015], 16, 1024, true);
		neoCamHUD.setBumpPattern([0 => 0.015], 16, 1024, true);
	},

	1024 => function() {
		neoCam.zoom.tween(null, 0.8, 1, "expoout");
		// doEvent("FocusCamera", {char: 1}); // opponent
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		bgShaderTween = FlxTween.num(0.5, 0, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(_) {
				bgShader.setFloat("u_mix", 0);
				bgShaderTween = null;
			}
		}, function(v:Float) {
			bgShader.setFloat("u_mix", v);
		});
	},

	1056 => function() {
		neoCam.zoom.tween(null, 0.7, 1, "expoout");
		// doEvent("FocusCamera", {char: 0}); // player
	},

	1088 => function() {
		// doEvent("FocusCamera", {char: 1}); // opponent
	},

	1120 => function() {
		// doEvent("FocusCamera", {char: 0}); // player
	},

	1138 => function() {
		neoCam.zoom.tween(null, 0.6, 1.5, "cubeout");
	},

	1151 => function() {
		neoCam.setBumpPattern([0 => 0.02], 64, 1152, true);
		neoCamHUD.setBumpPattern([0 => 0.02], 64, 1152, true);
	}
];


function onStepHit() {
	if (stepEvents.exists(curStep)) {
		stepEvents.get(curStep)();
	}
}


function getShaderTime():Float {
	if (bgShader == null) {
		return 0;
	}
	
	var x:Float = Conductor.songPosition / Conductor.crochet;
	var n:Float = 16;
	var l:Array<Float> = [8, 11];
	
	var skip:Float = 0;
	for (i in 0...l.length) {
		skip += Math.floor(FlxMath.mod(x, n) / l[i]);
	}
	
	skip += Math.floor(x / n) * (l.length + 1);
	
	return Conductor.songPosition / 1000 / 4 + skip * 100;
}



function onMoveCamera(char:String) {
	switch (char) {
		case "dad":
			neoCam.noteOffsetScale = zibOffsetScale;
			neoCam.noteOffset.x.halfLife = 0.1;
			neoCam.noteOffset.y.halfLife = 0.1;
			if (onFocusZoom) neoCam.zoom.target = zibZoom;
		case "boyfriend":
			neoCam.noteOffsetScale = bfOffsetScale;
			neoCam.noteOffset.x.halfLife = 0.3;
			neoCam.noteOffset.y.halfLife = 0.3;
			if (onFocusZoom) neoCam.zoom.target = bfZoom;
	}
}
*/

var bg:FunkinSprite = null;

var bgShader:FlxRuntimeShader = null;

function onReady():Void {
	bg = new FunkinSprite().makeSolidColor(2400.0, 2400.0, 0xffff0000);
	bg.screenCenter();
	bg.cameras = [camGame];
	addBehindGF(bg);
	bg.scrollFactor.set();
	
	bgShader = createRuntimeShader('miss-me');
	bgShader.setFloatArray('u_scale', [2.0, 2.0]);
	bgShader.setFloat('u_time', 0.0);
	bgShader.setFloat('u_mix', 0.0);
	bg.shader = bgShader;
	
	setGlobalVar('bgShader', bgShader);
}

function onUpdatePost(elapsed:Float):Void {
	if (bgShader != null) {
		bgShader.setFloatArray('u_offset', [
			0.5 * ncGame.position.x.applied / 2400.0,
			0.5 * ncGame.position.y.applied / 2400.0
		]);
		
		bgShader.setFloat('u_time', getShaderTime());
	}
}

function getShaderTime():Float {
	var beatDec:Float = Conductor.songPosition / Conductor.crochet;
	return 100.0 * (Math.floor(FlxMath.mod(beatDec, 16.0) / 8.0) + Math.floor(FlxMath.mod(beatDec, 16.0) / 11.0) + 3.0 * Math.floor(beatDec / 16.0)) + 0.5 * Conductor.songPosition / 1000.0;
}