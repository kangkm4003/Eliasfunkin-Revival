local text = {}
local antialiasing = getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing')

function onPrintDialogue(info)
    if info.type == 'location' then
        createInstance('locationGroup', 'flixel.group.FlxTypedSpriteGroup', {0, 534})
        setObjectCamera('locationGroup', 'other')
        setProperty('locationGroup.scale.x', 0)
        setProperty('locationGroup.origin.x', 0)

        makeLuaSprite('locationGraphic1', '', 0, 20)
        makeGraphic('locationGraphic1', 0, 0, 'TRANSPARENT')
        callMethod('locationGroup.add', {instanceArg('locationGraphic1')})

        makeLuaSprite('locationGraphic2', '', 0, 20)
        makeGraphic('locationGraphic2', 0, 0, 'TRANSPARENT')
        callMethod('locationGroup.add', {instanceArg('locationGraphic2')})

        addInstance('locationGroup', true)

        setOnLuas('dontGoNextDia', true)
        setProperty('locationGroup.x', 0)
        text = TextCut(info.text)
        for i = 1, #text do
            makeLuaText('locationText'..i, text[i], 0, 50, 0)
            setTextFont('locationText'..i, 'vcr.ttf')
            if i == 1 then
                setTextSize('locationText'..i, 50)
                setTextColor('locationText'..i, '347238')
            elseif i > 1 then
                setTextSize('locationText'..i, 40)
                setTextColor('locationText'..i, '383931')

                local prevLetter = i - 1
                setProperty('locationText'..i..'.x', getProperty('locationText'..prevLetter..'.x') + getTextWidth('locationText'..prevLetter))
                setProperty('locationText'..i..'.y', getProperty('locationText1.height') - getProperty('locationText'..i..'.height'))
            end
            setTextBorder('locationText'..i, 3, 'E7E7D2')
            setProperty('locationText'..i..'.alpha', 0)
            setProperty('locationText'..i..'.antialiasing', antialiasing)
            callMethod('locationGroup.add', {instanceArg('locationText'..i)})
        end
        local width = getProperty('locationText'..#text..'.x') + getTextWidth('locationText'..#text)
        makeGraphic('locationGraphic1', width + 75, 55, 'TRANSPARENT')
        callMethodFromClass('flixel.util.FlxSpriteUtil', 'drawRoundRectComplex', {
            instanceArg('locationGraphic1'), 
            0, 0, 
            width + 75, 55, 
            0, 40, 
            0, 15, 
            FlxColor('#93BD67')
        })

        makeGraphic('locationGraphic2', width + 70, 45, 'TRANSPARENT')
        callMethodFromClass('flixel.util.FlxSpriteUtil', 'drawRoundRectComplex', {
            instanceArg('locationGraphic2'), 
            0, 0, 
            width + 70, 45, 
            0, 32.5, 
            0, 12.5, 
            FlxColor('#E4E9B3')
        })

        setProperty('locationGroup.scale.x', 0)
        setProperty('locationGroup.origin.x', 0)

        doTweenX('locationGroup scale tween', 'locationGroup.scale', 1.1, 0.20, 'linear')
        startTween('locationGroup x tween2', 'locationGroup.scale', { x = 1}, 1.25, {ease = 'quartOut', startDelay = 0.20})
        startTween('locationGroup x tween3', 'locationGroup', { x = -15 }, 1.25, {ease = 'sineOut', startDelay = 0.20})
        
        local time = 0.25
        for i = 1, #text do
            if i == 1 then
                setProperty('locationText1.y', getProperty('locationText1.y') + 100)
                startTween('locationText1 tween', 'locationText'..i, { alpha = 1, y = getProperty('locationText1.y') - 100}, 0.5, {ease = 'elasticOut'})
            elseif i > 1 then
                setProperty('locationText'..i..'.y', getProperty('locationText'..i..'.y') + 100)
                startTween('locationText'..i..' Y tween', 'locationText'..i, { y = getProperty('locationText'..i..'.y') - 100}, 0.25, {ease = 'backOut', startDelay = time / #text * i})
                startTween('locationText'..i..' Alpha tween', 'locationText'..i, { alpha = 1 }, 0.5, {ease = 'quartOut', startDelay = time / #text * i})
            end
        end

        for i = 1, #text do
            startTween('locationText'..i..' close x tween', 'locationText'..i, {x = getProperty('locationText'..i..'.x') - 200}, 0.4, {ease = 'backIn', startDelay = 1.65})
            startTween('locationText'..i..' close alpha tween', 'locationText'..i, {alpha = 0}, 0.4, {ease = 'quartIn', startDelay = 1.65})
        end
        startTween('locationGroup close scale tween', 'locationGroup.scale', {x = 0}, 0.4, {ease = 'backIn', startDelay = 1.65, onComplete = 'locationTweenDone'})
    end
end

function locationTweenDone()
    setOnLuas('dontGoNextDia', false)
    removeLuaSprite('locationGroup', true)
    text = {}
    callScript('scripts/DialogueHandler', 'PrintNextDialogue', {})
end

function TextCut(text)
    local index = 1
    local iter = 1
    local result = {}
    while iter <= string.len(text) do
        if string.byte(text, iter) <= 126 then --english or !, #, $ Etc.
            result[index] = string.sub(text, iter, iter)
            iter = iter + 1
        elseif string.byte(text, iter) > 126 then --korean or other language maybe
            result[index] = string.sub(text, iter, iter + 2)
            iter = iter + 3
        end
        index = index + 1
    end
    return result
end