var gradient:FunkinSprite = null;

var introVid:VideoSprite = null;
var videoLoaded:Bool = false;

var bgShaderTween:Null<NumTween> = null;

function onCreate():Void {
	skipArrowStartTween = true;
}

function onStartCountdown():Void {
	if (videoLoaded) {
		return;
	}
	
	introVid = new VideoSprite().preload('songs/miss-me/intro', [VideoSprite.MUTED]);
	introVid.onReady.addOnce(() -> {
		introVid.setGraphicSize(FlxG.width);
		introVid.updateHitbox();
		introVid.cameras = [camOther];
		
		videoLoaded = true;
		skipCountdown = true;
		startCountdown();
	});
	
	add(introVid);
	
	return Function_Stop;
}

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

	gradient = new FunkinSprite(0.0, -200.0);
	gradient.loadGraphic(FlxGradient.createGradientBitmapData(2, 800, [0xff808080, 0x00808080], 1, 90));
	gradient.screenCenter(FlxAxes.X);
	gradient.scale.set(2000.0, 1.0);
	gradient.cameras = [camGame];
	addBehindGF(gradient);
	gradient.scrollFactor.set();
	
	ncGame.alpha.snap(0.0, true);
	
	uiGroup.alpha = 0.0001;
	
	for (note in playerStrums) {
		note.alpha = 0.0001;
	}
}

var stepEvents:IntMap<()->Void> = [
	0 => function() {
		ncGame.setBumpPattern(new IntMap(), 16, 0);
		ncHUD.setBumpPattern(new IntMap(), 16, 0);
		
		introVid.playVideo();
	},
	
	110 => function():Void {
		ncGame.alpha.snap(1.0, true);
		
		ncGame.position.x.snap(400.0, true);
		ncGame.position.y.snap(100.0, true);
		ncGame.position.x.locked = true;
		ncGame.position.y.locked = true;
		
		ncGame.zoom.snap(1.2, true);
		
		ncGame.angle.snap(1.5, true);
		
		opponent.playAnim('okay', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	112 => function() {
		remove(introVid);
		introVid.visible = false;
		
		opponent.playAnim('okay', true);
		
		FlxTween.tween(gradient, {alpha: 0.0001}, 1.25, {ease: FlxEase.cubeIn});
	},
	
	116 => function():Void {
		ncGame.position.x.locked = false;
		ncGame.position.y.locked = false;
		ncGame.position.x.halfLife = 0.05;
		ncGame.position.y.halfLife = 0.05;
		ncGame.position.x.tween(null, 800.0, 0.75, 'quartin');
		ncGame.position.y.tween(null, 350.0, 0.75, 'quartin');
		ncGame.position.x.locked = true;
		ncGame.position.y.locked = true;
		
		ncGame.zoom.halfLife = 0.05;
		ncGame.zoom.tween(null, 0.6, 0.75, 'quartin');
		
		ncGame.angle.halfLife = 0.1;
		ncGame.angle.tween(null, 0.5, 0.75, 'cubein');
	},
	
	128 => function():Void {
		ncGame.position.x.locked = false;
		ncGame.position.y.locked = false;
		ncGame.position.x.halfLife = 0.2;
		ncGame.position.y.halfLife = 0.2;
		moveCamera(true);
		
		ncGame.zoom.halfLife = 0.2;
		ncGame.zoom.tween(null, 0.8, 0.25, 'expoout');
		
		ncGame.setBumpPattern([
			0 => 0.015
		], 32, 128);
		
		ncHUD.setBumpPattern([
			0 => 0.03
		], 32, 128);
		
		opponent.playAnim('idle', true);
		opponent.skipDance = false;

		gradient.alpha = 0.0001;
		
		FlxTween.tween(uiGroup, {alpha: 1}, 0.5, {ease: FlxEase.cubeIn});
		
		for (note in playerStrums) {
			FlxTween.tween(note, {alpha: 1}, 0.5, {ease: FlxEase.cubeIn});
		}
	},
	
	144 => function():Void {
		uiGroup.alpha = 1.0;
		
		for (note in playerStrums) {
			note.alpha = 1.0;
		}
	},
	
	238 => function():Void {
		ncGame.zoom.tween(null, 0.7, 0.5, 'cubein');
	},
	
	248 => function():Void {
		moveCamera(true);
		
		ncGame.position.x.halfLife = 0.05;
		ncGame.position.y.halfLife = 0.05;
		ncGame.position.x.tween(null, 490.0, 0.25, 'quartout');
		ncGame.position.y.tween(null, 170.0, 0.25, 'quartout');
		
		ncGame.zoom.halfLife = 0.05;
		ncGame.zoom.tween(null, 0.75, 0.2, 'expoout');
		
		ncGame.angle.halfLife = 0.05;
		ncGame.angle.tween(null, -1, 0.2, 'quartout');
		
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
		
		gradient.alpha = 0.1;
	},
	
	250 => function():Void {
		ncGame.position.x.tween(null, 480.0, 0.2, 'quartout');
		ncGame.position.y.tween(null, 160.0, 0.2, 'quartout');
		
		ncGame.zoom.tween(null, 0.8, 0.2, 'expoout');
		
		ncGame.angle.tween(null, -2, 0.2, 'quartout');
		
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
		
		gradient.alpha = 0.2;
	},
	
	252 => function():Void {
		ncGame.position.x.tween(null, 470.0, 0.2, 'quartout');
		ncGame.position.y.tween(null, 150.0, 0.2, 'quartout');
		
		ncGame.zoom.tween(null, 0.85, 0.2, 'expoout');
		
		ncGame.angle.tween(null, -3, 0.2, 'quartout');
		
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
		
		gradient.alpha = 0.3;
	},
	
	254 => function():Void {
		ncGame.position.x.tween(null, 460.0, 0.2, 'quartout');
		ncGame.position.y.tween(null, 140.0, 0.2, 'quartout');
		
		ncGame.zoom.tween(null, 0.9, 0.2, 'expoout');
		
		ncGame.angle.tween(null, -4, 0.2, 'quartout');
		
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
		
		gradient.alpha = 0.4;
	},
	
	255 => function() {
		ncGame.setBumpPattern([0 => 0.015, 4 => 0.01, 12 => 0.01], 16, 256);
		ncHUD.setBumpPattern([0 => 0.03, 4 => 0.02, 12 => 0.02], 16, 256);
	},
	
	256 => function():Void {
		moveCamera(true);
		
		ncGame.position.x.halfLife = 0.2;
		ncGame.position.y.halfLife = 0.2;
		
		ncGame.zoom.halfLife = 0.2;
		ncGame.zoom.tween(null, 0.5, 0.2, 'expoout');
		
		ncGame.angle.halfLife = 0.2;
		ncGame.angle.tween(null, 0, 0.2, 'quartout');
		
		opponent.specialAnim = false;
		opponent.skipDance = false;
		
		FlxTween.tween(gradient, {alpha: 0.0001}, 1.0, {ease: FlxEase.cubeOut});
	},
	
	264 => function():Void {
		gradient.alpha = 0.0001;
	},
	
	292 => function():Void {
		opponent.playAnim('dance1', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	313 => function():Void {
		opponent.specialAnim = false;
		opponent.skipDance = false;
	},
	
	314 => function():Void {
		moveCamera(true);
	},
	
	316 => function():Void {
		ncGame.zoom.tween(null, 0.63, 0.25, 'expoout');
	},
	
	320 => function():Void {
		ncGame.zoom.tween(null, 0.5, 0.2, 'expoout');
	},
	
	356 => function():Void {
		opponent.playAnim('dance1', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	379 => function():Void {
		opponent.specialAnim = false;
		opponent.skipDance = false;
	},
	
	
	
	448 => function():Void {
		centerCamera();
		
		ncGame.position.x.locked = true;
		ncGame.position.y.locked = true;
		
		
	},
	
	479 => function():Void {
		ncGame.position.x.locked = false;
		ncGame.position.y.locked = false;
	},
	
	480 => function():Void {
		ncGame.zoom.tween(null, 0.7, 0.5, 'expoout');
	},
	
	496 => function():Void {
		ncGame.zoom.tween(null, 0.8, 0.5, 'expoout');
	},
	
	508 => function():Void {
		ncGame.zoom.tween(null, 0.65, 0.5, 'expoout');
	},
	
	512 => function():Void {
		bgShaderTween = FlxTween.num(0, 0.1, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(t:FlxTween):Void {
				bgShader.setFloat('u_mix', 0.1);
				bgShaderTween = null;
			}
		}, function(v:Float):Void {
			bgShader.setFloat('u_mix', v);
		});
	},
	
	528 => function():Void {
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	530 => function():Void {
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
	},
	
	535 => function():Void {
		opponent.specialAnim = false;
		opponent.skipDance = false;
	},
	
	640 => function():Void {
		ncGame.zoom.tween(null, 0.5, 0.5, 'expoout');
		
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		
		bgShaderTween = FlxTween.num(0.1, 0.25, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(t:FlxTween):Void {
				bgShader.setFloat('u_mix', 0.25);
				bgShaderTween = null;
			}
		}, function(v:Float):Void {
			bgShader.setFloat('u_mix', v);
		});
	},
	
	
	
	768 => function():Void {
		centerCamera();
		
		ncGame.position.x.locked = true;
		ncGame.position.y.locked = true;
		
	
		
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		
		bgShaderTween = FlxTween.num(0.25, 0.5, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(t:FlxTween):Void {
				bgShader.setFloat('u_mix', 0.5);
				bgShaderTween = null;
			}
		}, function(v:Float):Void {
			bgShader.setFloat('u_mix', v);
		});
	},
	
	832 => function():Void {
	
		
		opponent.playAnim('dance3', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	881 => function():Void {
		opponent.specialAnim = false;
		opponent.skipDance = false;
	},
	
	895 => function():Void {
		ncGame.position.x.locked = false;
		ncGame.position.y.locked = false;
	},
	
	914 => function():Void {
		opponent.playAnim('dance2', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	927 => function():Void {
		opponent.specialAnim = false;
		opponent.skipDance = false;
	},
	
	946 => function():Void {
		opponent.playAnim('dance2', true, false, 21);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	955 => function():Void {
		opponent.specialAnim = false;
		opponent.skipDance = false;
	},
	
	1024 => function():Void {
	
		
		if (bgShaderTween != null) {
			bgShaderTween.cancel();
			bgShaderTween.destroy();
			bgShaderTween = null;
		}
		
		bgShaderTween = FlxTween.num(0.5, 0, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(t:FlxTween):Void {
				bgShader.setFloat('u_mix', 0);
				bgShaderTween = null;
			}
		}, function(v:Float):Void {
			bgShader.setFloat('u_mix', v);
		});
	},
	
	
	
	1152 => function():Void {
		centerCamera();
		
		ncGame.position.x.locked = true;
		ncGame.position.y.locked = true;
		
		ncGame.setBumpPattern(new IntMap(), 16, 0);
		ncGame.bump(0.02);
		
		ncHUD.setBumpPattern(new IntMap(), 16, 0);
		ncHUD.bump(0.04);
		
		ncGame.zoom.tween(null, 0.65, 0.5, 'expoout');
	},
	
	1156 => function():Void {
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
		opponent.skipDance = true;
	},
	
	1158 => function():Void {
		opponent.playAnim('laugh', true);
		opponent.specialAnim = true;
	},
	
	1162 => function():Void {
		opponent.skipDance = false;
	}
];	

function onStepHit():Void {
	if (stepEvents.exists(curStep)) {
		stepEvents.get(curStep)();
		stepEvents.remove(curStep);
	}
}

function onSongTimeSet(time:Float, step:Int) {
	var indices:Array<Int> = new Array();
	for (idx in stepEvents.keys()) {
		indices.push(idx);
	}
	
	ArraySort.sort(indices, function(a:Int, b:Int):Int {
		if (a < b) {
			return -1;
		} else if (a > b) {
			return 1;
		}
		
		return 0;
	});
	
	for (i in 0...indices.length) {
		var idx:Int = indices[i];
		if (idx > step) {
			break;
		}
		
		stepEvents.get(idx)();
		stepEvents.remove(idx);
	}
}

function onDestroy():Void {
	if (introVid != null) {
		remove(introVid, true);
		introVid.destroy();
	}
}

var bg:FunkinSprite = null;

var bgShader:FlxRuntimeShader = null;


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