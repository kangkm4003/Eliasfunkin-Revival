local _types = {'normal','think','loud'}
local antialiasing = getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing')

function onCreate()
    for i = 1, #_types do
        precacheImage('dialogue/bubble/scriptbox-theme-'..i)
    end

    createInstance('BigbubbleGroup', 'flixel.group.FlxTypedSpriteGroup', {0, 0})
    setObjectCamera('BigbubbleGroup', 'other')

    for i = 1, #_types do
        makeLuaSprite('Bubble_'.._types[i], 'dialogue/bubble/scriptbox-theme-'..i, 112, 300)
        scaleObject('Bubble_'.._types[i], 0.3, 0.3)
        setProperty('Bubble_'.._types[i]..'.origin.y', 670)
        setProperty('Bubble_'.._types[i]..'.visible', false)
        callMethod('BigbubbleGroup.add', {instanceArg('Bubble_'.._types[i])})
    end

    createInstance('NameTagGroup', 'flixel.group.FlxTypedSpriteGroup', {515, 525})

    makeLuaSprite('Bubble_nameTag', '', 0, 0)
    makeGraphic('Bubble_nameTag', 250, 30, 'TRANSPARENT')
    callMethodFromClass('flixel.util.FlxSpriteUtil', 'drawRoundRectComplex', {instanceArg('Bubble_nameTag'), 0, 0, 250, 30, 20, 20, 10, 10, FlxColor('#FFFFFF')})
    setProperty('Bubble_nameTag.origin.y', 670)
    setProperty('Bubble_nameTag.visible', false)
    callMethod('NameTagGroup.add', {instanceArg('Bubble_nameTag')})

    makeLuaText('Bubble_nameText', '', 0, 0, -15)
    setTextFont('Bubble_nameText', 'vcr.ttf')
    setTextAlignment('Bubble_nameText', 'center')
    setTextBorder('Bubble_nameText', 3, 'FFFFFF', 'outline')
    setTextColor('Bubble_nameText', '343334')
    setProperty('Bubble_nameText.visible', false)
    setProperty('Bubble_nameText.antialiasing', antialiasing)
    callMethod('NameTagGroup.add', {instanceArg('Bubble_nameText')})

    callMethod('BigbubbleGroup.add', {instanceArg('NameTagGroup')})

    createInstance('Bubble_diaText', 'flixel.addons.text.FlxTypeText', {285, 510, 700, '', 30})
    setTextFont('Bubble_diaText', 'vcr.ttf')
    setTextAlignment('Bubble_diaText', 'center')
    setTextBorder('Bubble_diaText', 3, 'FFFFFF', 'outline')
    setTextColor('Bubble_diaText', '343334')
    setProperty('Bubble_diaText.visible', false)
    setProperty('Bubble_diaText.antialiasing', antialiasing)
    callMethod('BigbubbleGroup.add', {instanceArg('Bubble_diaText')})
    runHaxeCode([[
        PlayState.instance.variables.get('Bubble_diaText').completeCallback = 
        function() 
        {
            game.callOnLuas('Bubble_TextDone');
        };
    ]])

    if getTextSizeSetting() == 'Very Large' then
        setTextSize('Bubble_nameText', 35)
        setTextSize('Bubble_diaText', 35)
    elseif getTextSizeSetting() == 'Large' then
        setTextSize('Bubble_nameText', 35)
        setTextSize('Bubble_diaText', 32)
    elseif getTextSizeSetting() == 'Middle' then
        setTextSize('Bubble_nameText', 33)
        setTextSize('Bubble_diaText', 30)
    elseif getTextSizeSetting() == 'Small' then
        setTextSize('Bubble_nameText', 30)
        setTextSize('Bubble_diaText', 27)
    end

    makeLuaSprite('Bubble_arrow', 'dialogue/bubble/next-white', 983, 667)
    setProperty('Bubble_arrow.color', getColorFromHex('95C033'))
    scaleObject('Bubble_arrow', 0.05, 0.05)
    setProperty('Bubble_arrow.visible', false)
    callMethod('BigbubbleGroup.add', {instanceArg('Bubble_arrow')})
    startTween('Bubble_arrow Tween', 'Bubble_arrow', {y = 677}, 0.5, {type = 'pingpong'})

    addInstance('BigbubbleGroup', true)
end

function onPrintDialogue(info, prev)
    setProperty('Bubble_arrow.visible', false)
    if info.type == 'normal' or info.type == 'think' or info.type == 'loud' then
        for i = 1, #_types do
            setProperty('Bubble_'.._types[i]..'.scale.x', 0.3)
            setProperty('Bubble_'.._types[i]..'.scale.y', 0.3)
            if _types[i] ~= info.type then
                setProperty('Bubble_'.._types[i]..'.visible', false)
            elseif _types[i] == info.type then
                setProperty('Bubble_'.._types[i]..'.visible', true)
            end
        end

        setProperty('Bubble_nameText.visible', true)
        setProperty('Bubble_nameTag.visible', true)
        setProperty('Bubble_diaText.visible', true)
        setTextString('Bubble_nameText', info.name)
        setProperty('NameTagGroup.scale.y', 1)
        setProperty('NameTagGroup.y', 525)
        setProperty('Bubble_diaText.scale.x', 1)
        setProperty('Bubble_diaText.scale.y', 1)
        setProperty('Bubble_diaText.y', 510)

        if getTextWidth('Bubble_nameText') + 70 > 250 then
            makeGraphic('Bubble_nameTag', getTextWidth('Bubble_nameText') + 70, 30, 'TRANSPARENT')
            callMethodFromClass('flixel.util.FlxSpriteUtil', 'drawRoundRectComplex', {instanceArg('Bubble_nameTag'), 0, 0, getTextWidth('Bubble_nameText') + 70, 30, 20, 20, 10, 10, FlxColor('#FFFFFF')})
        else
            makeGraphic('Bubble_nameTag', 250, 30, 'TRANSPARENT')
            callMethodFromClass('flixel.util.FlxSpriteUtil', 'drawRoundRectComplex', {instanceArg('Bubble_nameTag'), 0, 0, 250, 30, 20, 20, 10, 10, FlxColor('#FFFFFF')})
        end
        if info.namePos == 'left' then
            setProperty('Bubble_nameTag.x', 250)
            if getTextWidth('Bubble_nameText') + 70 > 250 then
                setProperty('Bubble_nameText.x', getProperty('Bubble_nameTag.x') + 35)
            else
                local textWidth = getTextWidth('Bubble_nameText')
                local tagWidth = getProperty('Bubble_nameTag.width')
                setProperty('Bubble_nameText.x', (tagWidth - textWidth) / 2 + getProperty('Bubble_nameTag.x'))
            end
        elseif info.namePos == 'right' then
            if getTextWidth('Bubble_nameText') + 70 > 250 then
                setProperty('Bubble_nameTag.x', 1025 - getProperty('Bubble_nameTag.width'))
                setProperty('Bubble_nameText.x', getProperty('Bubble_nameTag.x') + 35)
            else
                setProperty('Bubble_nameTag.x', 775)
                local textWidth = getTextWidth('Bubble_nameText')
                local tagWidth = getProperty('Bubble_nameTag.width')
                setProperty('Bubble_nameText.x', (tagWidth - textWidth) / 2 + getProperty('Bubble_nameTag.x'))
            end
        else
            screenCenter('Bubble_nameText', 'x')
            screenCenter('Bubble_nameTag', 'x')
        end
        
        if info.nameTagColor == '' or info.nameTagColor == nil then
            setProperty('Bubble_nameTag.color', getColorFromHex(callScript('scripts/DialogueSystem', 'getColorBank', {info.name})))
        else
            setProperty('Bubble_nameTag.color', getColorFromHex(callScript('scripts/DialogueSystem', 'getColorBank', {info.nameTagColor})))
        end
        callMethod('Bubble_diaText.resetText', {info.text})
        callMethod('Bubble_diaText.applyMarkup', {info.text, {instanceArg('Text_marker')}})
        callMethod('Bubble_diaText.start', {0.02, true})

        if info.openAnim then
            doOpenAnim(info.type)
        elseif not prev.type == 'normal' or not prev.type == 'think' or not prev.type == 'loud' then
            doOpenAnim(info.type)
        end
    elseif prev.type == 'normal' or prev.type == 'think' or prev.type == 'loud' then
        doCloseAnim(prev.type, false)
    end
end

function doOpenAnim(type)
    setProperty('NameTagGroup.scale.x', 0.65)
    doTweenX('NameTagGroup scaleX', 'NameTagGroup.scale', 1, 0.2, 'backOut')
    setProperty('Bubble_'..type..'.scale.x', 0.2)
    doTweenX('Bubble_'..type..' scaleX', 'Bubble_'..type..'.scale', 0.3, 0.2, 'backOut')
end

function doCloseAnim(type, destroy)
    setProperty('Bubble_arrow.visible', false)
    startTween('Bubble_'..type..' close', 'Bubble_'..type..'.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })

    startTween('Bubble_diaText close scale', 'Bubble_diaText.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })
    doTweenY('Bubble_diaText close Y', 'Bubble_diaText', 670, 0.2, 'backIn')

    if destroy then
        startTween('NameTagGroup close scale', 'NameTagGroup.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn',  onComplete = 'onDestroy'})
    else
        startTween('NameTagGroup close scale', 'NameTagGroup.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn'})
    end
    doTweenY('NameTagGroup close Y', 'NameTagGroup', 670, 0.2, 'backIn')
end

function Bubble_TextDone()
    callScript('scripts/DialogueSystem', 'onSkip')
    callMethod('Bubble_diaText.skip')
    setProperty('Bubble_arrow.visible', true)
end

function onEndDialogue(type)
    if type == 'normal' or type == 'think' or type == 'loud' then
        doCloseAnim(type, true)
    else
        onDestroy()
    end
end

function onUpdate(elapsed)
    if luaTextExists('Bubble_diaText') and not textDone then
        local a = getProperty('Bubble_normal.height') / 2
        local b = getProperty('Bubble_diaText.height') / 2 * -1
        setProperty('Bubble_diaText.y', (a + b) + 510)
    end
end

function onDestroy()
    removeLuaSprite('BigbubbleGroup', true)
    close()
end