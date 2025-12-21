import openfl.display.Shape;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;


var rightEmitter = new FlxTypedEmitter(925, 1200, 5);
var leftEmitter = new FlxTypedEmitter(925, 1200, 5);

function onCreate()
{
    var matrix = new Matrix();
    var shape = new Shape();
    var bmp = new BitmapData(200, 800, true, FlxColor.TRANSPARENT);

    matrix.createGradientBox(200, 800, 90 * Math.PI/180, 0, 0);
    shape.graphics.beginGradientFill
    (
        0,
        [0xffffff, 0xffffff, 0xffffff],
        [0, 0.15, 0],
        [0, 100, 255],
        matrix
    );

    shape.graphics.moveTo(0, 800);
    shape.graphics.lineTo(200, 800);
    shape.graphics.lineTo(150, 0);
    shape.graphics.lineTo(50, 0);
    shape.graphics.lineTo(0, 800);
    shape.graphics.endFill();

    bmp.draw(shape);

    var lightLensAmount:Int = 5; //How much light lens for each emitter (default : 5) ※No effect on frequency※

    for (i in 0...2)
    {
        for (j in 0...lightLensAmount)
        {
            var particle = new FlxParticle();
            particle.loadGraphic(bmp);
            particle.exists = false;
            particle.alpha = 0;
            particle.lifespan = FlxG.random.float(2, 3);
            particle.origin.set(100, -300);

            if (i == 0)
                rightEmitter.add(particle);
            else if (i == 1)
                leftEmitter.add(particle);
        }
    }

    add(rightEmitter);
    rightEmitter.launchAngle.set(0, 0);
    rightEmitter.speed.set(0, 0);
    rightEmitter.angularVelocity.set(-5, 5, 0, 0);
    rightEmitter.angle.set(-40, -110);
    rightEmitter.start(false, 0.75, 0);

    add(leftEmitter);
    leftEmitter.launchAngle.set(0, 0);
    leftEmitter.speed.set(0, 0);
    leftEmitter.angularVelocity.set(-5, 5, 0, 0);
    leftEmitter.angle.set(40, 110);
    leftEmitter.start(false, 0.75, 0);
}

function onUpdatePost(elapsed:Float)
{
    for (i in 0...rightEmitter.length)
    {
        var particle = rightEmitter.members[i];
        if (particle.exists)
        {
            var halfLife = particle.lifespan / 2;
            if (particle.age < halfLife)
                particle.alpha =  particle.age / halfLife;
            else if (particle.age >= halfLife)
                particle.alpha = 1 - ((particle.age - halfLife) / halfLife);
        }
    }

    for (i in 0...leftEmitter.length)
    {
        var particle = leftEmitter.members[i];
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