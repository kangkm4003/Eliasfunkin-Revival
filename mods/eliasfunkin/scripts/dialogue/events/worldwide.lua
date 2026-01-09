
function onCreate()
    precacheImage('dialogue/character/erpin/er-grid')
    precacheImage('dialogue/character/bf/bf-grid')
    precacheImage('dialogue/cutscene/worldwide/1')
    precacheImage('dialogue/cutscene/worldwide/2')
    precacheMusic('35. Trick Or Treat')
    precacheMusic('33. This Is Awkward')
    precacheMusic('bird noise')
end

local dialogue_Mid_Event = false -- set true when print dialogue in mid-event
function onCreatePost()
    initLuaShader('shadow')
    setProperty('boyfriend.visible', false)
    setProperty('dad.visible', false)

    makeLuaSprite('er', '', 350, 450)
    loadGraphic('er', 'dialogue/character/erpin/er-grid', 847, 820)
    addAnimation('er', 'curious', '0')
    addAnimation('er', 'sad', '1')
    addAnimation('er', 'sob', '2')
    addAnimation('er', 'blankly', '3')
    addAnimation('er', 'angry', '4')

    --[[setSpriteShader('er', 'shadow')
    setShaderFloat('er', 'ang', 90)
    setShaderFloat('er', 'str', 1)
    setShaderFloat('er', 'dist', 15)
    setShaderFloat('er', 'thr', 0.4)

    setShaderFloat('er', 'brightness', -40)
    setShaderFloat('er', 'hue', -10)
    setShaderFloat('er', 'contrast', -12.5)
    setShaderFloat('er', 'saturation', -10)
    setShaderFloat('er', 'AA_STAGES', 2)]]

    setProperty('er.visible', false)
    addLuaSprite('er', true)

    makeLuaSprite('bf', '', 1050, 500)
    loadGraphic('bf', 'dialogue/character/bf/bf-grid', 847, 820)
    addAnimation('bf', 'happy', '0')
    addAnimation('bf', 'suprised', '1')
    addAnimation('bf', 'excited', '2')
    addAnimation('bf', 'curious', '3')
    addAnimation('bf', 'nervous1', '4')
    addAnimation('bf', 'nervous2', '5')

    setSpriteShader('bf', 'shadow')
    setShaderFloat('bf', 'ang', 90)
    setShaderFloat('bf', 'str', 1)
    setShaderFloat('bf', 'dist', 15)
    setShaderFloat('bf', 'thr', 0.1)

    setShaderFloat('bf', 'brightness', -30)
    setShaderFloat('bf', 'hue', -10)
    setShaderFloat('bf', 'contrast', -12.5)
    setShaderFloat('bf', 'saturation', -10)
    setShaderFloat('bf', 'AA_STAGES', 2)

    setShaderFloatArray('bf', 'dropColor', {87 / 255, 191 / 255, 244 / 255})
    setShaderFloatArray('bf', 'uFrameBounds', {0, 0, getProperty('boyfriend.width'), getProperty('boyfriend.height')})

    addLuaSprite('bf', true)
    playAnim('bf', 'nervous1')

    makeLuaSprite('cutscene1', 'dialogue/cutscene/worldwide/1')
    setObjectCamera('cutscene1', 'other')
    makeLuaSprite('cutscene2', 'dialogue/cutscene/worldwide/2')
    setObjectCamera('cutscene2', 'other')
end

local _prevEventID = 0
local _timerNum = 0
local _prevCamScroll = { 950, 700 }
local _prevCamZoom = 1.1

function LoadDialogue()
    playMusic('bird noise', 1, true)
end

function onPrintDialogue(info)
        --event skip
        if not dialogue_Mid_Event then
            cancelTween('gameZoom')
            for i = 1, _timerNum do
                cancelTimer('dialogueTimer-'.._prevEventID..'-'..i)
            end
            _timerNum = 0
            setCameraFollowPoint(_prevCamScroll[1], _prevCamScroll[2])
            setCameraScroll(_prevCamScroll[1], _prevCamScroll[2])
            setProperty('camGame.zoom', _prevCamZoom)
            cameraShake('game', 0, 0.5)
            cameraShake('other', 0, 0.5)
            if _prevEventID == 1 or _prevEventID == 6 then
                cancelTween('dialogueEvent1')
                setProperty('graphic.alpha', 0)
            elseif _prevEventID == 2 then
                setProperty('camGame.zoom', 0.6)
            elseif _prevEventID == 3 then
                cancelTween('erTween')
                setProperty('er.x', 700)
            elseif _prevEventID == 5 then
                cancelTween('erTween')
                setProperty('graphic.alpha', 1)
                setProperty('er.x', 1000)
            end
            _prevEventID = info.eventID
        end
        dialogue_Mid_Event = false
        --event
        if info.eventID == 1 then
            doTweenAlpha('dialogueEvent1', 'graphic', 0, 2, 'cubeIn')
            unDark('bf')
        elseif info.eventID == 2 then
            runTimer('dialogueTimer-'..info.eventID..'-1', 0.5)
            runTimer('dialogueTimer-'..info.eventID..'-2', 1.5)
            runTimer('dialogueTimer-'..info.eventID..'-3', 2.5)
            _prevCamScroll = {950, 700}
            _prevCamZoom = 0.6
            _timerNum = 3
        elseif info.eventID == 3 then
            playMusic('35. Trick Or Treat', 0, true)
            soundFadeIn(nil, 0.5, 0, 1)
            setProperty('er.visible', true)
            setProperty('er.color', FlxColor('BLACK'))
            setProperty('er.x', -2000)
            playAnim('er', 'blankly')
            doTweenX('erTween', 'er', 700, 0.5)

            setCameraFollowPoint(100, 800)
            setCameraScroll(100, 800)
            _prevCamScroll = {100, 800}
            setProperty('camGame.zoom', 1.1)
            _prevCamZoom = 1.1
            cameraShake('game', 0.015, 0.5)
            cameraShake('other', 0.015, 0.5)
        elseif info.eventID == 4 then
            setCameraFollowPoint(1400, 900)
            setCameraScroll(1400, 900)
            _prevCamScroll = {1400, 900}

            setProperty('er.x', 100)
            playAnim('bf', 'suprised')
            cameraShake('game', 0.015, 0.5)
            cameraShake('other', 0.015, 0.5)
        elseif info.eventID == 5 then
            runTimer('dialogueTimer-'..info.eventID..'-1', 0.15)
            doTweenX('erTween', 'er', 1000, 0.15)
            callOnHScript('bigbubble_doCloseAnim', {false})
        elseif info.eventID == 6 then
            playMusic('33. This Is Awkward', 1, true)
            setProperty('er.color', FlxColor('WHITE'))
            playAnim('er', 'angry')
            setProperty('er.x', 100)
            setSpriteShader('er', 'shadow')
            setShaderFloat('er', 'ang', 90)
            setShaderFloat('er', 'str', 1)
            setShaderFloat('er', 'dist', 15)
            setShaderFloat('er', 'thr', 0.4)

            setShaderFloat('er', 'brightness', -40)
            setShaderFloat('er', 'hue', -10)
            setShaderFloat('er', 'contrast', -12.5)
            setShaderFloat('er', 'saturation', -10)
            setShaderFloat('er', 'AA_STAGES', 2)

            setShaderFloatArray('er', 'dropColor', {91 / 255, 119 / 255, 255 / 255})
            setShaderFloatArray('er', 'uFrameBounds', {0, 0, getProperty('dad.width'), getProperty('dad.height')})

            playAnim('bf', 'nervous1')
            Dark('bf')
            unDark('er')

            removeLuaSprite('cutscene1', true)
            setProperty('graphic.alpha', 1)
            doTweenAlpha('dialogueEvent1', 'graphic', 0, 1)
            setCameraFollowPoint(950, 700)
            setCameraScroll(950, 700)
            _prevCamScroll = {950, 700}
            doTweenZoom('gameZoom', 'game', 0.8, 1, 'cubeOut')
            _prevCamZoom = 0.8
        elseif info.eventID == 7 then
            setCameraFollowPoint(1200, 800)
            _prevCamScroll = {1200, 800}
            Dark('er')
            unDark('bf')
        elseif info.eventID == 8 then
            playAnim('er', 'curious')
            unDark('er')
            Dark('bf')
            setCameraFollowPoint(600, 800)
            _prevCamScroll = {600, 800}
        elseif info.eventID == 9 then
            playAnim('er', 'angry')
            cameraShake('game', 0.015, 0.5)
            cameraShake('other', 0.015, 0.5)

            setCameraFollowPoint(630, 770)
            setCameraScroll(630, 770)
            _prevCamScroll = {630, 770}
        elseif info.eventID == 10 then
            playAnim('bf', 'curious')
            Dark('er')
            unDark('bf')

            setCameraFollowPoint(1200, 800)
            _prevCamScroll = {1200, 800}
        elseif info.eventID == 11 then
            playAnim('bf', 'happy')

            setCameraFollowPoint(1170, 770)
            _prevCamScroll = {1170, 770}
            unDark('bf')
            Dark('er')
        elseif info.eventID == 12 then
            playAnim('er', 'curious')
            Dark('bf')
            unDark('er')
            setCameraFollowPoint(600, 800)
            _prevCamScroll = {600, 800}
        elseif info.eventID == 13 then
            playAnim('er', 'blankly')
            setCameraFollowPoint(630, 770)
            _prevCamScroll = {630, 770}
            unDark('er')
            Dark('bf')
        elseif info.eventID == 14 then
            playAnim('er', 'curious')
            unDark('er')
            Dark('bf')

            setCameraFollowPoint(600, 800)
            _prevCamScroll = {600, 800}
        elseif info.eventID == 15 then
            playAnim('bf', 'happy')
            unDark('bf')
            Dark('er')

            setCameraFollowPoint(1170, 770)
            _prevCamScroll = {1170, 770}
        elseif info.eventID == 16 then
            playAnim('bf', 'excited')
            unDark('bf')
            Dark('er')

            setCameraFollowPoint(1200, 800)
            _prevCamScroll = {1200, 800}
        elseif info.eventID == 17 then
            setOnLuas('dontGoNextDia', true)
            doTweenAlpha('cutscene2 tween', 'graphic', 1, 0.5)
        end
end

function Dark(name)
    setProperty(name..'.colorTransform.redMultiplier', 0.5)
    setProperty(name..'.colorTransform.greenMultiplier', 0.5)
    setProperty(name..'.colorTransform.blueMultiplier', 0.5)

    setProperty(name..'.colorTransform.redOffset', 0)
    setProperty(name..'.colorTransform.greenOffset', 0)
    setProperty(name..'.colorTransform.blueOffset', 0)
    removeSpriteShader(name)
end

function unDark(name)
    setSpriteShader(name, 'shadow')
    setShaderFloat(name, 'ang', 90)
    setShaderFloat(name, 'str', 1)
    setShaderFloat(name, 'dist', 15)
    setShaderFloat(name, 'thr', 0.1)

    setShaderFloat(name, 'brightness', -30)
    setShaderFloat(name, 'hue', -10)
    setShaderFloat(name, 'contrast', -12.5)
    setShaderFloat(name, 'saturation', -10)
    setShaderFloat(name, 'AA_STAGES', 2)
end

function onEndDialogue()
    doTweenAlpha('dialogueEvent1', 'graphic', 1, 0.5, 'cubeIn')
    soundFadeOut(nil, 1)
    cancelTween('gameZoom')
    for i = 1, _timerNum do
        cancelTimer('dialogueTimer-'.._prevEventID..'-'..i)
    end
    runTimer('dialogueEnd', 1)
end

function onTweenCompleted(tag)
    if tag == 'cutscene2 tween' then
        addLuaSprite('cutscene2', false)
        setObjectOrder('cutscene2', getObjectOrder('graphic') - 1)
        setOnLuas('dontGoNextDia', false)
        doTweenAlpha('dialogueEvent1', 'graphic', 0, 0.5)
    end
end

function onTimerCompleted(tag)
    if tag == 'dialogueTimer-2-1' then
        playAnim('bf', 'nervous1')
        setCameraFollowPoint(1200, 800)
    elseif tag == 'dialogueTimer-2-2' then
        playAnim('bf', 'nervous2')
        setCameraFollowPoint(1500, 800)
    elseif tag == 'dialogueTimer-2-3' then
        playAnim('bf', 'nervous1')
        setCameraFollowPoint(950, 700)
        doTweenZoom('gameZoom', 'game', 0.6, 1, 'cubeOut')
        dialogue_Mid_Event = true
        callScript('scripts/DialogueHandler', 'PrintNextDialogue', {})

    elseif tag == 'dialogueTimer-5-1' then
        addLuaSprite('cutscene1', false)
        setObjectOrder('cutscene1', getObjectOrder('graphic') - 1)
        cameraShake('game', 0.015, 0.25)
        cameraShake('other', 0.015, 0.25)

    elseif tag == 'dialogueEnd' then
        startCountdown()
        removeLuaSprite('cutscene1', true)
        removeLuaSprite('cutscene2', true)
        triggerEvent('Camera Follow Pos', 950, 700)
        removeLuaSprite('bf', true)
        removeLuaSprite('er', true)
        setProperty('dad.visible', true)
        setProperty("healthBar.alpha", 1)
        setProperty("scoreTxt.alpha", 1)
        setProperty('boyfriend.visible', true)
        setProperty('camGame.zoom', 1.1)
        close()
    end
end