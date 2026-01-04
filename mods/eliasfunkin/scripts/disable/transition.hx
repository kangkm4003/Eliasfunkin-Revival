import flixel.FlxCamera;

var backColor = [
    163/255, 
    223/255, 
    114/255
];

var camTransition = new FlxCamera();
camTransition.bgColor = FlxColor.TRANSPARENT;

var invert = new FlxSprite();
invert.makeGraphic(FlxG.width, FlxG.height);
var shader0 = game.createRuntimeShader('invert');
invert.shader = shader0;
invert.shader.setFloatArray('backColor', [backColor[0], backColor[1], backColor[2]]);

var star = new FlxSprite(0, 0, Paths.image('star'));
function onCreatePost()
{
    star.scale.set(5, 5);
    star.cameras = [camTransition];
    add(star);
    star.screenCenter();

    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.remove(camOther, false);
    FlxG.cameras.add(camHUD, false);
    FlxG.cameras.add(camOther, false);
    FlxG.cameras.add(camTransition, false);
    camTransition.setFilters([new ShaderFilter(shader0)]);
}

function onUpdate()
{
    if (FlxG.keys.justPressed.S)
    {
        FlxTween.cancelTweensOf(star.angle);
        FlxTween.cancelTweensOf(star.scale);
        star.angle = 0;
        FlxTween.tween(star.scale, { x:0, y:0 }, 1);
        FlxTween.tween(star, { angle: 360 }, 1);
    }
    else if (FlxG.keys.justPressed.D)
    {
        FlxTween.cancelTweensOf(star.angle);
        FlxTween.cancelTweensOf(star.scale);
        star.angle = 0;
        FlxTween.tween(star.scale, { x:5, y:5 }, 1);
        FlxTween.tween(star, { angle: 360 }, 1);
    }
}