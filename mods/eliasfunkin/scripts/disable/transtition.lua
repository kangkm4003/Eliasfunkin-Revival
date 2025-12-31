function onCreatePost()



    local backColor = 
    {
        r = ( 163 ) / 255,
        g = ( 223 ) / 255,
        b = ( 114 ) / 255
    }

    --makeLuaSprite('star', 'star')
    --setProperty('star.colorTransform.redOffset', 163)
    --setProperty('star.colorTransform.greenOffset', 223)
    --setProperty('star.colorTransform.blueOffset', 114)
    --setSpriteShader('star', 'invert')
    --setShaderFloatArray('star', 'backColor', {163/255, 223/255, 114/255})
    --setProperty('camOther.bgColor', getColorFromName('RED'))


    makeLuaSprite('star', 'star')
    screenCenter('star', 'xy')

    initLuaShader('invert')
    makeLuaSprite('invert')
    makeGraphic('invert', screenWidth, screenHeight)
    setSpriteShader('invert', 'invert')
    setShaderFloatArray('invert', 'backColor', {163/255, 223/255, 114/255})
    runHaxeCode([[
        import flixel.FlxCamera;

        var camTransition = new FlxCamera();
        camTransition.bgColor = FlxColor.TRANSPARENT;

        var star = PlayState.instance.variables.get("star");
        star.scale.set(5, 5);
        star.cameras = [camTransition];
        add(star);
        FlxG.cameras.remove(camHUD, false);
        FlxG.cameras.remove(camOther, false);
        //FlxG.cameras.add(camTransition, false);
        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.add(camOther, false);
        FlxG.cameras.add(camTransition, false);
        camTransition.setFilters([new ShaderFilter(PlayState.instance.variables.get("invert").shader)]);
    ]])
    
end

function onUpdate(elapsed)
    if keyboardJustPressed('S') then
        openCustomSubstate('transition', false)
    elseif keyboardJustPressed('D') then
        closeCustomSubstate()
    end
end

function onCustomSubstateCreate(name)
    runHaxeCode([[
        var star = PlayState.instance.variables.get("star");
        star.angle = 0;
        FlxTween.cancelTweensOf(star.angle);
        FlxTween.cancelTweensOf(star.scale);
        FlxTween.tween(star.scale, {x:0, y:0}, 1);
        FlxTween.tween(star, {angle: 360 * 1}, 1);
    ]])
end

function onCustomSubstateDestroy(name)
    runHaxeCode([[
        var star = PlayState.instance.variables.get("star");
        star.angle = 0;
        FlxTween.cancelTweensOf(star.angle);
        FlxTween.cancelTweensOf(star.scale);
        FlxTween.tween(star.scale, {x:5, y:5}, 1);
        FlxTween.tween(star, {angle: 360 * 1}, 1);
    ]])
end