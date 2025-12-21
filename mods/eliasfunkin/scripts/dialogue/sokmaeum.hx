import flixel.group.FlxTypedSpriteGroup;
import flixel.util.FlxSpriteUtil;
import backend.CoolUtil;
import openfl.display.Shape;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;

var antialiasing = ClientPrefs.data.antialiasing;

var buttomGroup = new FlxTypedSpriteGroup(0, 0);
buttomGroup.cameras = [camOther];

var buttom = new FlxSprite(380, -180, Paths.image('dialogue/emote/sokmaeum'));
buttom.scale.set(0.13, 0.13);
buttom.updateHitbox();
buttom.origin.set(2121, 2121);
buttom.exists = false;
buttom.antialiasing = antialiasing;
buttomGroup.add(buttom);

var buttom_hitbox = new FlxSprite(1100, 550);
buttom_hitbox.makeGraphic(150, 150);
buttom_hitbox.visible = false;
buttom_hitbox.exists = false;
buttomGroup.add(buttom_hitbox);

var particle_emitter = new FlxTypedEmitter(1200, 730);
var particle_matrix = new Matrix();
var particle_shape = new Shape();
var particle_bmp = new BitmapData(100, 200, true, FlxColor.TRANSPARENT);
particle_matrix.createGradientBox(100, 200, 90 * Math.PI/180, 0, 0);
particle_shape.graphics.beginGradientFill(
    0,
    [0xFFA762B2, 0xFFA762B2, 0xFFA762B2],
    [0, 0.5, 0],
    [0, 100, 255],
    particle_matrix
);

particle_shape.graphics.moveTo(0, 200);
particle_shape.graphics.lineTo(100, 200);
particle_shape.graphics.lineTo(75, 0);
particle_shape.graphics.lineTo(25, 0);
particle_shape.graphics.lineTo(0, 200);
particle_shape.graphics.endFill();

particle_bmp.draw(particle_shape);

for (i in 0...10)
{
    var particle = new FlxParticle();
    particle.loadGraphic(particle_bmp);
    particle.exists = false;
    particle.alpha = 0;
    particle.lifespan = FlxG.random.float(2, 3);
    particle.origin.set(50, 0);
    particle_emitter.add(particle);
}

particle_emitter.cameras = [camOther];
add(particle_emitter);

particle_emitter.launchAngle.set(0, 0);
particle_emitter.speed.set(0, 0);
particle_emitter.angularVelocity.set(-5, 5, 0, 0);
particle_emitter.angle.set(30, 280);
particle_emitter.start(false, 0.5, 0);
particle_emitter.exists = false;

add(buttomGroup);

var gradient = new FlxSprite(0, 0);
var gradient_matrix = new Matrix();
var gradient_shape = new Shape();
var gradient_bmp = new BitmapData(1280, 720, true, FlxColor.TRANSPARENT);
gradient_matrix.createGradientBox(1280, 720, 0, 0, 0);
gradient_shape.graphics.beginGradientFill(
    1,
    [0xFFA762B2, 0xFFA762B2],
    [0.5, 0],
    [255, 200],
    gradient_matrix
);

gradient_shape.graphics.lineTo(1280, 0);
gradient_shape.graphics.lineTo(1280, 720);
gradient_shape.graphics.lineTo(0, 720);
gradient_shape.graphics.lineTo(0, 0);
gradient_shape.graphics.endFill();

gradient_bmp.draw(gradient_shape);

gradient.loadGraphic(gradient_bmp);
gradient.cameras = [camOther];
gradient.alpha = 0;
add(gradient);

var sokmaeumEnabled = false;
var buttomPressed = false;

function onPrintDialogue(info:Array<Dynamic>, ?prev:Array<Dynamic>)
{
    if (info.sokmaeum != null || sokmaeumEnabled)
    {
        buttom.exists = true;
        buttom_hitbox.exists = true;
        FlxG.mouse.visible = true;
    }
    else
    {
        buttom.exists = false;
        buttom_hitbox.exists = false;
        FlxG.mouse.visible = false;
    }
}

function onUpdate(elapsed:Float)
{
    if (buttom.exists)
    {
        if (FlxG.mouse.justPressed && checkCollision())
        {
            buttomPressed = true;
            FlxTween.cancelTweensOf(buttom.scale);
            FlxTween.tween(buttom.scale, {x: 0.11, y:0.11}, 0.15, {ease: FlxEase.quartOut});
        }
        else if (FlxG.mouse.justReleased && buttomPressed && checkCollision())
        {
            buttomPressed = false;
            sokmaeumEnabled = !sokmaeumEnabled;
            FlxTween.cancelTweensOf(buttom.scale);
            FlxTween.tween(buttom.scale, {x: 0.13, y:0.13}, 0.25, {ease: FlxEase.quartOut});
            particle_emitter.exists = sokmaeumEnabled;
            if (sokmaeumEnabled)
            {
                gradient.scale.set(1, 1);
                FlxTween.cancelTweensOf(gradient);
                FlxTween.cancelTweensOf(gradient.scale);
                FlxTween.tween(PlayState.instance.variables.get('dialogue_black'), {alpha: 0.5}, 0.25, {ease: FlxEase.quartOut});
                FlxTween.tween(gradient, {alpha: 1}, 0.25, {ease: FlxEase.quartOut, 
                onComplete: function()
                {
                    FlxTween.tween(gradient.scale, {x: 1.1, y:1.1}, 1, {ease: FlxEase.sineInOut, type: 4});
                }});
                PlayState.instance.callOnScripts('onPrintDialogue', [Dialogue[Line-2].sokmaeum]);
            }
            else
            {
                FlxTween.cancelTweensOf(gradient);
                FlxTween.cancelTweensOf(gradient.scale);
                FlxTween.tween(PlayState.instance.variables.get('dialogue_black'), {alpha: 0}, 0.25, {ease: FlxEase.quartOut});
                FlxTween.tween(gradient, {alpha: 0}, 0.25, {ease: FlxEase.linear});
                PlayState.instance.callOnScripts('onPrintDialogue', [Dialogue[Line-2], null, true]);
            }
            PlayState.instance.setOnScripts('Line', Line-1);
        }
        else if (FlxG.mouse.justReleased && buttomPressed)
        {
            buttomPressed = false;
            FlxTween.cancelTweensOf(buttom.scale);
            FlxTween.tween(buttom.scale, {x: 0.13, y:0.13}, 0.25, {ease: FlxEase.quartOut});
        }
    }
}

function onUpdatePost(elapsed:Float)
{
    for (i in 0...particle_emitter.length)
    {
        var particle = particle_emitter.members[i];
        if (particle.exists)
        {
            var halfLife = particle.lifespan / 2;
            if (particle.age < halfLife)
                particle.alpha =  particle.age / halfLife;
            else if (particle.age >= halfLife)
                particle.alpha = 1 - ((particle.age - halfLife) / halfLife);
        }
    }
}

function checkCollision()// objectsOverlap() screw this it's too buggy
{
    var mousePos = FlxG.mouse.getScreenPosition(camOther);
    //code from https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection

    if (buttom_hitbox.x < mousePos.x && buttom_hitbox.x + buttom_hitbox.width > buttom_hitbox.x &&
        buttom_hitbox.y < mousePos.y && buttom_hitbox.y + buttom_hitbox.height > mousePos.y)
        return true;
    else
        return false;
}