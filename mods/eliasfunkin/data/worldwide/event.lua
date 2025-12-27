function onCreate()
    precacheImage('overlay')
    makeLuaSprite('overlay', 'overlay', 0, 0)
    setObjectCamera('overlay', 'hud')
    scaleObject('overlay', 1.1636, 1.1822)
    setProperty('overlay.alpha', 0)
    addLuaSprite('overlay', false)
end

function onCreatePost()

    setProperty('camHUD.alpha', 0.001)
    setProperty('iconP1.alpha', 0)
    setProperty('iconP2.alpha', 0)
    --setProperty('healthBar.alpha', 0)

    setProperty('camGame.zoom', 1.1)
    setProperty('defaultCamZoom', 1.1)
    setProperty('camZoomingMult', 0)

    setCameraFollowPoint(900, 700)
    setCameraScroll(900, 700)
    triggerEvent('Camera Follow Pos', 900, 700)

    makeLuaSprite('graphic')
    makeGraphic('graphic', screenWidth, screenHeight, '000000')
    setObjectCamera('graphic', 'other')
    addLuaSprite('graphic', false)

    -- not shadersEnabled and flashingLights
    if not shadersEnabled and flashingLights then
        makeLuaSprite('flashWithoutShader')
        makeGraphic('flashWithoutShader', screenWidth, screenHeight, 'FFFFFF')
        setObjectCamera('flashWithoutShader', 'other')
        addLuaSprite('flashWithoutShader', false)
        setProperty('flashWithoutShader.alpha', 0)
    end
end

function onSpawnNote(index, noteData, noteType)
    if noteType == 'NoteBump' then
        setPropertyFromGroup('notes', index, 'multSpeed', 0.05)
        setPropertyFromGroup('notes', index, 'multAlpha', 0.5)
    end
end

function onUpdatePost(elapsed)
    for i = 0, getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', i, 'noteType') == 'NoteBump' then
            setPropertyFromGroup('notes', i, 'multSpeed', getPropertyFromGroup('notes', i, 'multSpeed') + elapsed / 3)
            if getPropertyFromGroup('notes', i, 'strumTime') - getSongPosition() < 800 then
                setPropertyFromGroup('notes', i, 'multAlpha', 1)
            end
        end
    end
end

function onSongStart()
    StrumDefX = {
        defaultOpponentStrumX0, --opponent
        defaultOpponentStrumX1, 
        defaultOpponentStrumX2, 
        defaultOpponentStrumX3,

        defaultPlayerStrumX0, --player
        defaultPlayerStrumX1, 
        defaultPlayerStrumX2, 
        defaultPlayerStrumX3
    }
    doTweenAlpha('black', 'graphic', 0, 7)
    doTweenZoom('camGame', 'camGame', 0.45, 12, 'sineOut')
    setProperty('defaultCamZoom', 0.45)

    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
    end
end

function onPause()
    if curStep >= 1280 then
        return Function_Stop
    else
        return Function_Continue
    end
end

function onStepHit()
    if curStep == 112 then
        doTweenAlpha('camHUD', 'camHUD', 1, 2.5)
    elseif curStep == 128 then
        setProperty('overlay.alpha', 0.8)
        setProperty('camZoomingMult', 0.5)
    elseif curStep == 192 then
        for i = 0, 3 do
            noteTweenAlpha('opponent noteTween'..i, i, 1, 1)
        end
    elseif curStep == 376 then
        doTweenY('DramaBar1', 'DramaBar1', lerp(screenHeight / 2 * -1, 0, 1), 0.86, 'quartIn')
        doTweenY('DramaBar2', 'DramaBar2', lerp(screenHeight, screenHeight / 2, 1), 0.86, 'quartIn')

        doTweenZoom('camZoom', 'camGame', 1.1, 0.86, 'quartIn')
    elseif curStep == 632 then
        doTweenY('DramaBar1', 'DramaBar1', lerp(screenHeight / 2 * -1, 0, 1), 0.86, 'quartIn')
        doTweenY('DramaBar2', 'DramaBar2', lerp(screenHeight, screenHeight / 2, 1), 0.86, 'quartIn')

        doTweenZoom('camZoom', 'camGame', 1.1, 0.86, 'quartIn')
    elseif curStep == 888 then
        doTweenY('DramaBar1', 'DramaBar1', lerp(screenHeight / 2 * -1, 0, 1), 0.86, 'quartIn')
        doTweenY('DramaBar2', 'DramaBar2', lerp(screenHeight, screenHeight / 2, 1), 0.86, 'quartIn')

        doTweenZoom('camZoom', 'camGame', 1.1, 0.86, 'quartIn')
    elseif curStep == 1152 then
        doTweenAlpha('camHUD', 'camHUD', 0, 2.5)

        for i = 0, 7 do
            noteTweenAlpha('strumLine alpha'..i, i + 1, 0, 1.5)
            if i < 4 then
                noteTweenX('strumLine x'..i, i, StrumDefX[i + 1] - 50, 1.5, 'sineOut')
            elseif i >= 4 then
                noteTweenX('strumLine x'..i, i, StrumDefX[i + 1] + 50, 1.5, 'sineOut')
            end
        end
    elseif curStep == 1216 then
        doTweenAlpha('camHUD', 'camHUD', 1, 1)
        for i = 0, 7 do
            noteTweenAlpha('strumLine alpha'..i, i + 1, 1, 1.5)
            if i < 4 then
                noteTweenX('strumLine x'..i, i, StrumDefX[i + 1], 1.5, 'sineOut')
            elseif i >= 4 then
                noteTweenX('strumLine x'..i, i, StrumDefX[i + 1], 1.5, 'sineOut')
            end
        end
    elseif curStep == 1264 then
        runHaxeCode([[
            var camDAD = PlayState.instance.variables.get("camDAD");
            var camBF = PlayState.instance.variables.get("camBF");
            FlxTween.tween(camDAD, {zoom: 1.05}, 0.15, {ease: FlxEase.quartOut});
            FlxTween.tween(camBF, {zoom: 1.05}, 0.15, {ease: FlxEase.quartOut});
        ]])
    elseif curStep == 1268 then
        runHaxeCode([[
            var camDAD = PlayState.instance.variables.get("camDAD");
            var camBF = PlayState.instance.variables.get("camBF");
            FlxTween.tween(camDAD, {zoom: 1.1}, 0.15, {ease: FlxEase.quartOut});
            FlxTween.tween(camBF, {zoom: 1.1}, 0.15, {ease: FlxEase.quartOut});
        ]])
    elseif curStep == 1272 then
        runHaxeCode([[
            var camDAD = PlayState.instance.variables.get("camDAD");
            var camBF = PlayState.instance.variables.get("camBF");
            FlxTween.tween(camDAD, {zoom: 1.15}, 0.15, {ease: FlxEase.quartOut});
            FlxTween.tween(camBF, {zoom: 1.15}, 0.15, {ease: FlxEase.quartOut});
        ]])
    elseif curStep == 1276 then
        setProperty('defaultCamZoom', 0.75)
        doTweenZoom('camZoom', 'camGame', 0.75, 0.15, 'quartOut')

        runHaxeCode([[
            var camDAD = PlayState.instance.variables.get("camDAD");
            var camBF = PlayState.instance.variables.get("camBF");
            FlxTween.tween(camDAD, {zoom: 1.2}, 0.15, {ease: FlxEase.quartOut});
            FlxTween.tween(camBF, {zoom: 1.2}, 0.15, {ease: FlxEase.quartOut});
        ]])
    elseif curStep == 1280 then
        doTweenZoom('camZoom', 'camGame', 0.45, 7, 'quartOut')
        doTweenAlpha('camHUD', 'camHUD', 0, 2.5)
        doTweenAlpha('black', 'graphic', 1, 7)
        for i = 0, 7 do
            noteTweenAlpha('strumLine alpha'..i, i + 1, 0, 1.5)
            if i < 4 then
                noteTweenX('strumLine x'..i, i, StrumDefX[i + 1] - 50, 1.5, 'sineOut')
            elseif i >= 4 then
                noteTweenX('strumLine x'..i, i, StrumDefX[i + 1] + 50, 1.5, 'sineOut')
            end
        end
    end
end

function onEvent(event, value1, value2, strumTime)
    if event == '' then 
        if value1 == 'bright flash' then
            BrightFlash(value2)
        elseif value1 == 'camera target' then
            cameraSetTarget(value2)
        end
    end
end

function BrightFlash(value)
    if flashingLights then
        if shadersEnabled then
            setShaderFloat('bloom', 'dim', value)
        else
            setProperty('flashWithoutShader.alpha', value / 2.1)
        end
    end
end

function onUpdate(elapsed)
    if flashingLights then
        if shadersEnabled then
            flashWithShader(elapsed)
        else
            flashWithoutShader(elapsed)
        end
    end
end

function flashWithShader(elapsed)
    if not shadersEnabled then return end

    if getShaderFloat('bloom', 'dim') < 2 then
        setShaderFloat('bloom', 'dim', getShaderFloat('bloom', 'dim') + elapsed)
    elseif getShaderFloat('bloom', 'dim') > 2 then
        setShaderFloat('bloom', 'dim', 2)
    end
end

function flashWithoutShader(elapsed)
    if shadersEnabled then return end

    if getProperty('flashWithoutShader.alpha') > 0 then
        setProperty('flashWithoutShader.alpha', getProperty('flashWithoutShader.alpha') - elapsed)
    else
        setProperty('flashWithoutShader.alpha', 0)
    end
end

local _cameraMove_amount = 50

function opponentNoteHit(index, noteData, noteType, isSustain)
    if  not isSustain and noteType == 'NoteBump' then
        local cameraPos = {
            x = 900,
            y = 700
        }
        if noteData == 0 then
            triggerEvent('Camera Follow Pos', cameraPos.x - _cameraMove_amount, cameraPos.y)
        elseif noteData == 1 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y + _cameraMove_amount)
        elseif noteData == 2 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y - _cameraMove_amount)
        elseif noteData == 3 then
            triggerEvent('Camera Follow Pos', cameraPos.x + _cameraMove_amount, cameraPos.y)
        end
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if  not isSustain and noteType == 'NoteBump' then
        local cameraPos = {
            x = 900,
            y = 700
        }
        if noteData == 0 then
            triggerEvent('Camera Follow Pos', cameraPos.x - _cameraMove_amount, cameraPos.y)
        elseif noteData == 1 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y + _cameraMove_amount)
        elseif noteData == 2 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y - _cameraMove_amount)
        elseif noteData == 3 then
            triggerEvent('Camera Follow Pos', cameraPos.x + _cameraMove_amount, cameraPos.y)
        end
    end
end

function lerp(a, b, t)
	return a + (b - a) * t
end