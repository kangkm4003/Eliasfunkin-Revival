function onCreatePost()
    createInstance('camBF', 'flixel.FlxCamera', {screenWidth, 0})
    createInstance('camDAD', 'flixel.FlxCamera', {-screenWidth, 0})
    callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camBF'), true})
    callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camDAD'), true})
    callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg('camHUD'), false})
    callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camHUD'), false})
    callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg('camOther'), false})
    callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camOther'), false})

    setProperty('camBF.scroll.x', 1250)
    setProperty('camBF.scroll.y', 600)

    setProperty('camDAD.scroll.x', -600)
    setProperty('camDAD.scroll.y', 500)

    if shadersEnabled and curStage == 'erpinStage2' then
        initLuaShader('bloomForCamSplit')
        makeLuaSprite('bloomForCamSplit')
        makeGraphic('bloomForCamSplit', screenWidth, screenHeight)
        setSpriteShader('bloomForCamSplit', 'bloom')
        setShaderFloat('bloomForCamSplit', 'dim', 1.8)
        setShaderFloat('bloomForCamSplit', 'Directions', 10.0)
        setShaderFloat('bloomForCamSplit', 'Quality', 3.0)
        setShaderFloat('bloomForCamSplit', 'Size', 1.5)
        runHaxeCode([[
            game.getLuaObject("camDAD").setFilters([new ShaderFilter(game.getLuaObject("bloomForCamSplit").shader)]);
            game.getLuaObject("camBF").setFilters([new ShaderFilter(game.getLuaObject("bloomForCamSplit").shader)]);
        ]])
    end
end

function onEvent(event, value1, value2, strumTime)
    if event == 'camSplit' then
        activated = not activated
        if value1 == 'dad open' then
            doTweenX('camDAD', 'camDAD', -(screenWidth / 2), value2, 'sineOut')
        elseif value1 == 'dad close' then
            doTweenX('camDAD', 'camDAD', -screenWidth, value2, 'sineOut')

        elseif value1 == 'bf open' then
            doTweenX('camBF', 'camBF', screenWidth / 2, value2, 'sineOut')
        elseif value1 == 'bf close' then
            doTweenX('camBF', 'camBF', screenWidth, value2, 'sineOut')

        elseif value1 == 'both open' then
            doTweenX('camDAD', 'camDAD', -(screenWidth / 2), value2, 'sineOut')
            doTweenX('camBF', 'camBF', screenWidth / 2, value2, 'sineOut')

        elseif value1 == 'both close' then
            doTweenX('camDAD', 'camDAD', -screenWidth, value2, 'sineOut')
            doTweenX('camBF', 'camBF', screenWidth, value2, 'sineOut')
        end
    end
end