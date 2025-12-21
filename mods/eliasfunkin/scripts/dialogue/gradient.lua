function onCreate()
    precacheImage('dialogue/bubble/namebubble-body')
    precacheImage('dialogue/bubble/namebubble-tail')

    addHaxeLibrary('FlxGradient', 'flixel.util')
    makeLuaSprite('gradient', '', 0, screenHeight - screenHeight / 3)
    makeGraphic('gradient', screenWidth, (screenHeight / 3) * 1.3, 'TRANSPARENT')
    setObjectCamera('gradient', 'other')
    setProperty('gradient.origin.y', (screenHeight / 3) * 1.3)
    setProperty('gradient.visible', false)
    addLuaSprite('gradient', true)
    runHaxeCode([[
        FlxGradient.overlayGradientOnFlxSprite(
            PlayState.instance.variables.get('gradient'),
            FlxG.width, (FlxG.height / 3) * 1.3,
            [FlxColor.TRANSPARENT, FlxColor.BLACK],
            1,
            90,
            true
        );
    ]])

    createInstance('grad_diaText', 'flixel.addons.text.FlxTypeText', {285, 610, 700, '', 30})
    setObjectCamera('grad_diaText', 'other')
    setTextFont('grad_diaText', 'vcr.ttf')
    setTextAlignment('grad_diaText', 'center')
    setTextColor('grad_diaText', 'FFFFFF')
    setTextBorder('grad_diaText', 3, '000000', 'outline')
    setProperty('grad_diaText.visible', false)
    runHaxeCode([[
        PlayState.instance.variables.get('grad_diaText').completeCallback = 
        function() 
        {
            game.callOnLuas('grad_TextDone');
        };
    ]])
    addInstance('grad_diaText', true)


    if getTextSizeSetting() == 'Very Large' then
        setTextSize('grad_diaText', 35)
    elseif getTextSizeSetting() == 'Large' then
        setTextSize('grad_diaText', 32)
    elseif getTextSizeSetting() == 'Middle' then
        setTextSize('grad_diaText', 30)
    elseif getTextSizeSetting() == 'Small' then
        setTextSize('grad_diaText', 27)
    end

    createInstance('gradNameTagGroup', 'flixel.group.FlxTypedSpriteGroup', {285, 308})
    setObjectCamera('gradNameTagGroup', 'other')

    makeLuaSprite('grad_NameTagTail', 'dialogue/bubble/namebubble-tail', 22, 142)
    setProperty('grad_NameTagTail.origin.x', 0)
    setProperty('grad_NameTagTail.scale.x', 0.1)
    setProperty('grad_NameTagTail.scale.y', 0.09)
    callMethod('gradNameTagGroup.add', {instanceArg('grad_NameTagTail')})

    makeLuaSprite('grad_NameTagBody', 'dialogue/bubble/namebubble-body', 0, 0)
    setProperty('grad_NameTagBody.origin.x', 0)
    setProperty('grad_NameTagBody.scale.x', 0.1)
    setProperty('grad_NameTagBody.scale.y', 0.09)
    callMethod('gradNameTagGroup.add', {instanceArg('grad_NameTagBody')})

    makeLuaText('grad_NameTagText', '', 0, 20, 243)
    setTextSize('grad_NameTagText', 20)
    setTextColor('grad_NameTagText', 'FFFFFF')
    setTextBorder('grad_NameTagText', 3, '000000', 'outline')
    callMethod('gradNameTagGroup.add', {instanceArg('grad_NameTagText')})

    makeLuaSprite('grad_arrow', 'dialogue/bubble/next-white', 983, 667)
    setObjectCamera('grad_arrow', 'other')
    scaleObject('grad_arrow', 0.05, 0.05)
    setProperty('grad_arrow.visible', false)
    startTween('grad_arrow Tween', 'grad_arrow', {y = 677}, 0.5, {type = 'pingpong'})
    addLuaSprite('grad_arrow', true)

    setProperty('gradNameTagGroup.visible', false)
    addInstance('gradNameTagGroup', true)
end

function onPrintDialogue(info, prev)
    setProperty('grad_arrow.visible', false)
    if info.type == 'gradient' then
        setProperty('grad_diaText.visible', true)
        setProperty('gradient.visible', true)
        if info.name ~= nil or info.name ~= '' then
            setProperty('gradNameTagGroup.visible', true)
            setTextString('grad_NameTagText', info.name)
            setProperty('grad_NameTagText.scale.x', 1)
            setProperty('grad_NameTagText.scale.y', 1)
            local _bodyWidth = getProperty('grad_NameTagBody.width') * 0.1
            local _textWidth = getTextWidth('grad_NameTagText') + 40
            setProperty('grad_NameTagBody.scale.x', (_textWidth / _bodyWidth) * 0.1)
        end

        callMethod('grad_diaText.resetText', {info.text})
        callMethod('grad_diaText.applyMarkup', {info.text, {instanceArg('Text_marker')}})
        callMethod('grad_diaText.start', {0.02, true})

        if info.openAnim then
            doOpenAnim()
        end
    elseif prev.type == 'gradient' then
        doCloseAnim(false)
    end
end

function doOpenAnim()
    if getProperty('gradNameTagGroup.visible') then
        setProperty('gradient.scale.x', 1)
        setProperty('gradient.scale.y', 1)
        setProperty('grad_diaText.scale.x', 1)
        setProperty('grad_diaText.scale.y', 1)
        local body_original_scale = getProperty('grad_NameTagBody.scale.x')
        setProperty('grad_NameTagBody.scale.x', 0)
        setProperty('grad_NameTagText.scale.x', 0)
        setProperty('grad_NameTagTail.scale.y', 0)
        doTweenY('grad_NameTagTail Y scale tween', 'grad_NameTagTail.scale', 0.09, 0.2, 'backOut')
        doTweenX('grad_NameTagBody X scale tween', 'grad_NameTagBody.scale', body_original_scale, 0.2, 'backOut')
        doTweenX('grad_NameTagText X scale tween', 'grad_NameTagText.scale', 1, 0.2, 'backOut')
    end
end

function doCloseAnim(destroy)
    setProperty('gradNameTagGroup.visible', false)
    doTweenY('gradient close scaleY', 'gradient.scale', 0, 0.2, 'sineIn')

    startTween('grad_NameTagText close scale', 'grad_NameTagText.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn'})

    if destroy then
        startTween('grad_diaText close scale', 'grad_diaText.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn', onComplete = 'onDestroy'})
    else
        startTween('grad_diaText close scale', 'grad_diaText.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })
    end
end

function grad_TextDone()
    callScript('scripts/DialogueSystem', 'onSkip')
    callMethod('grad_diaText.skip')
    setProperty('grad_arrow.visible', true)
end

function onEndDialogue(type)
    if type == 'gradient' then
        doCloseAnim(true)
    else
        onDestroy()
    end
end

function onDestroy()
    removeLuaSprite('gradient', true)
    removeLuaText('grad_diaText', true)
    removeLuaSprite('gradNameTagGroup', true)
    removeLuaSprite('grad_arrow', true)
    close()
end