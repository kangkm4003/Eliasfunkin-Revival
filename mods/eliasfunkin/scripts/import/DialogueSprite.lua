--[[old dialogue script. dont use it]]

local _textSpeed = 0.05
local textTable = {}
local bigBubbleType = {'normal', 'loud', 'think'}

local effectOnScreen = {}
local effectNum = 1

function onCreate()
    precacheImage('dialogue/bubble/normal')
    precacheImage('dialogue/bubble/loud')
    precacheImage('dialogue/bubble/think')
    precacheImage('dialogue/bubble/narNameTag-body')
    precacheImage('dialogue/bubble/narNameTag-tail')
    precacheImage('dialogue/bubble/option-0')
    precacheImage('dialogue/bubble/option-1')
    precacheSound('dialogue trickal')
    precacheSound('dialogue trickal2')
    precacheSound('trickcal release')
end


function onUpdate()
    if mouseReleased('left') and luaSpriteExists('option1') then --if 'option1' object exists = option button is on screen
        onReleasedOptionButton()
        playSound('trickcal release')
    end
    --local selected_object =  'optionText1' --for debug
    --if keyboardJustPressed('UP') then
    --    setProperty(selected_object..'.y', getProperty(selected_object..'.y') - 1)
    --elseif keyboardJustPressed('DOWN') then
    --    setProperty(selected_object..'.y', getProperty(selected_object..'.y') + 1)
    --end
    --if keyboardJustPressed('LEFT') then
    --    setProperty(selected_object..'.x', getProperty(selected_object..'.x') - 1)
    --elseif keyboardJustPressed('RIGHT') then
    --    setProperty(selected_object..'.x', getProperty(selected_object..'.x') + 1)
    --end
    --if keyboardJustPressed('UP') or keyboardJustPressed('LEFT') or keyboardJustPressed('RIGHT') or keyboardJustPressed('DOWN') then
    --    debugPrint('x : '..getProperty(selected_object..'.x').. '\ny : '..getProperty(selected_object..'.y'))
    --end
    --if keyboardJustPressed('D') then
    --    triggerEvent('Camera Follow Pos', 100, 100)
    --end
end

function onDestroy()
    setPropertyFromClass("flixel.FlxG", "mouse.visible", false)
end

function LoadDialogue()

    --import
    addHScript('scripts/import/Custom Sprite Group')
    addHScript('scripts/import/Spawn Advansed Graphic')
    addLuaScript('scripts/import/Collision Check')
    ----

    LoadBubble()

    if getTextSpeedSetting() == 'Fast' then
        _textSpeed = 0.02
    elseif getTextSpeedSetting() == 'Middle' then
        _textSpeed = 0.04
    elseif getTextSpeedSetting() == 'Slow' then
        _textSpeed = 0.06
    elseif getTextSpeedSetting() == 'None' then
        _textSpeed = 0
    else
        _textSpeed = 0.06
    end


    if getTextSizeSetting() == 'Very Large' then
        setTextSize('Bubble_nameText', 35)
        setTextSize('Bubble_Diatext', 35)
    elseif getTextSizeSetting() == 'Large' then
        setTextSize('Bubble_nameText', 35)
        setTextSize('Bubble_Diatext', 32)
    elseif getTextSizeSetting() == 'Middle' then
        setTextSize('Bubble_nameText', 33)
        setTextSize('Bubble_Diatext', 30)
    elseif getTextSizeSetting() == 'Small' then
        setTextSize('Bubble_nameText', 30)
        setTextSize('Bubble_Diatext', 27)
    end

    UpdateTextPos()
end

local BubbleType = ''

function PrintDialogue(info)
    BubbleType = info[1]
    cancelTween('Bubble_arrow tween1')
    cancelTween('Bubble_arrow tween2')
    setProperty('Bubble_arrow.alpha', 0)
    scaleObject('Bubble_arrow', 0.135, 0.15)
    setProperty('Bubble_arrow.y', 667)
    if Line > 1 then
        setOnLuas('prevBubbleType', Dialogue[Line - 1][1])
    end
    
    --normal bubble type
    if BubbleType == 'normal' or BubbleType == 'loud' or BubbleType == 'think' then
        setTextString('Bubble_nameText', info[3])
        setProperty('Bubble_nameTag.color', getColorBank(info[2]))
        if Line == 1 then
            BigBubbleOpen(BubbleType, true)
        else
            if prevBubbleType ~= BubbleType or --if prev dialogue's name or shape is diffrent from current, plays open tween
            Dialogue[Line - 1][3] ~= info[3] then
                BigBubbleOpen(BubbleType, true)
            elseif savedLine ~= 0 then
                BigBubbleOpen(BubbleType, true)
            else
                BigBubbleOpen(BubbleType, false)
            end
        end
    else
        setProperty('BigbubbleGroup.alpha', 0)
    end
    ----

    --nar bubble type
    if BubbleType == 'nar' then
        if info[2] == true then
            if Line == 1 then
                NarOpen(info[2], info[3], true)
            elseif prevBubbleType ~= BubbleType or --if prev dialogue is diffrent, or doesnt has nametag, or nametag text is diffrent form current, plays open tween
                   Dialogue[Line - 1][2] == false or 
                   Dialogue[Line - 1][2] == true and Dialogue[Line - 1][3] ~= info[3] then
                NarOpen(info[2], info[3], true)
            elseif savedLine ~= 0 then
                NarOpen(info[2], info[3], true)
            else
                NarOpen(info[2], info[3], false)
            end
        elseif info[2] == false then
            NarOpen(info[2])
        end
    else
        setProperty('nar.alpha', 0)
        setProperty('narNameTagGroup.alpha', 0)
    end
    ----

    --location bubble(?) type
    if BubbleType == 'location' then
        locationOpen(TextCut(info[2]))
    end
    ----

    --Effect type
    CloseEffect()
    if BubbleType == 'effect' then
        EffectOpen(info)
    end
    ----

    --dont show Diatext in this state
    if BubbleType == 'effect' or 
        BubbleType == 'location' then
            setProperty('Bubble_Diatext.alpha', 0)
    else
        setProperty('Bubble_Diatext.alpha', 1)
    end
    ----

    --print text
    if BubbleType == 'normal' or BubbleType == 'loud' or BubbleType == 'think' then
        textTable = TextCut(info[4])
    elseif BubbleType == 'nar' then
        if info[2] == true then
            textTable = TextCut(info[4])
        elseif info[2] == false then
            textTable = TextCut(info[3])
        end
    end

    if BubbleType == 'normal' or BubbleType == 'loud' or BubbleType == 'think' or BubbleType == 'nar' then
        setTextString('Bubble_Diatext', '')
        if textSpeed ~= nil then
            runTimer('bigBubbleTextTimer', textSpeed, #textTable)
            setOnLuas('textDone', false)
        elseif textSpeed == nil then
            for i = 1, #textTable do
                setTextString('Bubble_Diatext', getTextString('Bubble_Diatext')..textTable[i]) 
            end
            setOnLuas('textDone', true)
        end
    end
    ----
end

function LoadBubble()

    --big bubble
    callOnHScript('makeGroup', {'BigbubbleGroup', 0, 0}) --dont change scale variable of this!

    for i = 1, #bigBubbleType do
        makeLuaSprite('Bubble_'..bigBubbleType[i], 'dialogue/bubble/'..bigBubbleType[i], 112, 316)
        callMethod('Bubble_'..bigBubbleType[i]..'.set_camera', {instanceArg('camHUD')})
        scaleObject('Bubble_'..bigBubbleType[i], 0.3, 0.3)
        setProperty('Bubble_'..bigBubbleType[i]..'.origin.y', 670)
        setProperty('Bubble_'..bigBubbleType[i]..'.alpha', 1)
        addLuaSprite('Bubble_'..bigBubbleType[i], true)
        callOnHScript('addGroup', {'BigbubbleGroup', 'Bubble_'..bigBubbleType[i], -1})
    end

    makeLuaSprite('Bubble_nameTag', '', 515, 525)
    callOnHScript('makeRoundRectComplex', {'Bubble_nameTag', 250, 30, 20, 20, 10, 10, getColorBank('FFFFFF')})
    callMethod('Bubble_nameTag.set_camera', {instanceArg('camHUD')})
    setProperty('Bubble_nameTag.alpha', 1)
    addLuaSprite('Bubble_nameTag', true)
    setProperty('Bubble_nameTag.origin.y', 670 / 3)

    makeLuaSprite('Bubble_arrow', 'dialogue/bubble/arrow-white', 983, 667)
    callMethod('Bubble_arrow.set_camera', {instanceArg('camHUD')})
    setProperty('Bubble_arrow.color', getColorFromHex('95C033'))
    scaleObject('Bubble_arrow', 0.15, 0.15)
    setProperty('Bubble_arrow.alpha', 1)
    addLuaSprite('Bubble_arrow', true)
    ----


    --nar
    makeLuaSprite('nar', '', 0, screenHeight - screenHeight / 3)
    callOnHScript('makeGradientGraphic', {'nar', screenWidth, (screenHeight / 3) * 1.3, {getColorFromHex('TRANSPARENT'), getColorFromHex('000000')}, 1, 90, true})
    callMethod('nar.set_camera', {instanceArg('camHUD')})
    setProperty('nar.alpha', 0)
    setProperty('nar.origin.y', (screenHeight / 3) * 1.3)
    addLuaSprite('nar', true)

    callOnHScript('makeGroup', {'narNameTagGroup', 600, 308}) --dont change scale variable of this!

    makeLuaSprite('nar_NameTagTail', 'dialogue/bubble/narNameTag-tail', 22, 142)
    callMethod('nar_NameTagTail.set_camera', {instanceArg('camHUD')})
    setProperty('nar_NameTagTail.origin.x', 0)
    addLuaSprite('nar_NameTagTail', true)

    makeLuaSprite('nar_NameTagBody', 'dialogue/bubble/narNameTag-body', 0, 0)
    callMethod('nar_NameTagBody.set_camera', {instanceArg('camHUD')})
    setProperty('nar_NameTagBody.origin.x', 0)
    addLuaSprite('nar_NameTagBody', true)

    makeLuaText('nar_NameTagText', '', 0, 20, 243)
    callMethod('nar_NameTagText.set_camera', {instanceArg('camHUD')})
    callMethod('nar_NameTagText.set_camera', {instanceArg('camHUD')})
    setTextSize('nar_NameTagText', 20)
    setTextColor('nar_NameTagText', 'FFFFFF')
    setTextBorder('nar_NameTagText', 3, '000000', 'outline')
    addLuaText('nar_NameTagText')


    callOnHScript('addGroup', {'narNameTagGroup', 'nar_NameTagTail', -1})
    callOnHScript('addGroup', {'narNameTagGroup', 'nar_NameTagBody', -1})
    callOnHScript('addGroup', {'narNameTagGroup', 'nar_NameTagText', -1})
    setProperty('narNameTagGroup.scale.x', 0.1)
    setProperty('narNameTagGroup.scale.y', 0.09)
    setProperty('nar_NameTagBody.scale.x', 0.05)
    setProperty('nar_NameTagText.scale.x', 1)
    setProperty('nar_NameTagText.scale.y', 1)
    setProperty('narNameTagGroup.alpha', 0)
    ----


    --Dialogue Text
    makeLuaText('Bubble_nameText', '', 0, 0, 0)
    callMethod('Bubble_nameText.set_camera', {instanceArg('camHUD')})
    setTextAlignment('Bubble_nameText', 'center')
    setTextBorder('Bubble_nameText', 3, 'FFFFFF', 'outline')
    setTextColor('Bubble_nameText', '343334')
    addLuaText('Bubble_nameText')

    screenCenter('Bubble_nameText', 'x')
    setProperty('Bubble_nameText.y', getProperty('Bubble_nameTag.y') - getProperty('Bubble_nameText.height') / 2)

    makeLuaText('Bubble_Diatext', '', 900, 0, 626)
    createInstance('Bubble_Diatext', 'flixel.addons.text.FlxTypeText', {0, 626, 700, '', 30})
    callMethod('Bubble_Diatext.set_camera', {instanceArg('camHUD')})
    setTextAlignment('Bubble_Diatext', 'center')
    setTextColor('Bubble_Diatext', '343334')
    setTextBorder('Bubble_Diatext', 0, 'FFFFFF', 'none')
    addLuaText('Bubble_Diatext')

    callOnHScript('addGroup', {'BigbubbleGroup', 'Bubble_nameTag', -1})
    callOnHScript('addGroup', {'BigbubbleGroup', 'Bubble_nameText', -1})

    makeLuaSprite('Bubble_arrow', 'dialogue/bubble/arrow-white', 983, 667)
    callMethod('Bubble_arrow.set_camera', {instanceArg('camHUD')})
    setProperty('Bubble_arrow.color', getColorFromHex('95C033'))
    scaleObject('Bubble_arrow', 0.15, 0.15)
    setProperty('Bubble_arrow.alpha', 1)
    addLuaSprite('Bubble_arrow', true)
    ----
end

function BigBubbleOpen(Type, doTween)
    setProperty('BigbubbleGroup.alpha', 1)
    setTextBorder('Bubble_nameText', 3, 'FFFFFF', 'outline')
    setTextColor('Bubble_nameText', '343334')
    screenCenter('Bubble_nameText', 'x')

    setTextColor('Bubble_Diatext', '343334')
    setTextBorder('Bubble_Diatext', 0, 'FFFFFF', 'none')
    
    if getTextWidth('Bubble_nameText') > 250 - 80 then
        callOnHScript('makeRoundRectComplex', {'Bubble_nameTag', getTextWidth('Bubble_nameText') + 80, 30, 20, 20, 10, 10, getColorBank('FFFFFF')})
    else
        callOnHScript('makeRoundRectComplex', {'Bubble_nameTag', 250, 30, 20, 20, 10, 10, getColorBank('FFFFFF')})
    end
    screenCenter('Bubble_nameTag', 'x')
    setProperty('Bubble_nameTag.origin.y', 670 / 3)
    if doTween then
        for i = 1, #bigBubbleType do
            if Type == bigBubbleType[i] then --only show correct bubble shape
                setProperty('Bubble_nameText.scale.x', 0.65)
                doTweenX('Bubble_nameText scaleX', 'Bubble_nameText.scale', 1, 0.2, 'backOut')
                setProperty('Bubble_'..Type..'.alpha', 1)
                setProperty('Bubble_'..Type..'.scale.x', 0.2)
                doTweenX('Bubble_'..Type..' scaleX', 'Bubble_'..Type..'.scale', 0.3, 0.2, 'backOut')
                setProperty('Bubble_nameTag.scale.x', 0.65)
                doTweenX('Bubble_nameTag scaleX', 'Bubble_nameTag.scale', 1, 0.2, 'backOut')
            else
                setProperty('Bubble_'..bigBubbleType[i]..'.alpha', 0)
            end
        end
    else
        for i = 1, #bigBubbleType do
            if Type == bigBubbleType[i] then --only show correct bubble shape
                setProperty('Bubble_'..Type..'.alpha', 1)
            else
                setProperty('Bubble_'..bigBubbleType[i]..'.alpha', 0)
            end
        end
    end
end

function NarOpen(hasNameTag, name, doTween)
    if hasNameTag then
        setTextString('nar_NameTagText', name)
        setProperty('nar_NameTagBody.scale.x', (getTextWidth('nar_NameTagText') + 40) / getProperty('nar_NameTagBody.width'))

        setTextString('Bubble_Diatext', Dialogue[Line][4])
        UpdateTextPos()
        setProperty('narNameTagGroup.x', getProperty('Bubble_Diatext.x') - 80)
        setTextString('Bubble_Diatext', '')

        if doTween then
            local body_original_scale = getProperty('nar_NameTagBody.scale.x')
            local tail_original_scale = {getProperty('nar_NameTagTail.scale.x'),getProperty('nar_NameTagTail.scale.y')}
            local text_original_scale = getProperty('nar_NameTagText.scale.x')

            setProperty('nar_NameTagBody.scale.x', body_original_scale - body_original_scale / 2)
            setProperty('nar_NameTagTail.scale.y', tail_original_scale[1] - tail_original_scale[1] / 2)
            setProperty('nar_NameTagTail.scale.y', tail_original_scale[2] - tail_original_scale[2] / 2)
            setProperty('nar_NameTagText.scale.x', text_original_scale - text_original_scale / 2)
            setProperty('nar_NameTagText.x', getProperty('nar_NameTagText.x') - getTextWidth('nar_NameTagText') / 2)

            doTweenX('nar_NameTagTail X scale tween', 'nar_NameTagTail.scale', tail_original_scale[1], 0.2, 'backOut')
            doTweenY('nar_NameTagTail Y scale tween', 'nar_NameTagTail.scale', tail_original_scale[2], 0.2, 'backOut')

            doTweenX('nar_NameTagBody X scale tween', 'nar_NameTagBody.scale', body_original_scale, 0.2, 'backOut')

            doTweenX('nar_NameTagText X scale tween', 'nar_NameTagText.scale', text_original_scale, 0.2, 'backOut')
            doTweenX('nar_NameTagText X tween', 'nar_NameTagText', getProperty('nar_NameTagText.x') + getTextWidth('nar_NameTagText') / 2, 0.2, 'backOut')

            doTweenAlpha('narNameTagGroup Alpha tween', 'narNameTagGroup', 1, 0.2, 'backOut')
        else
            setProperty('narNameTagGroup.alpha', 1)
        end
    else
        setProperty('narNameTagGroup.alpha', 0)
    end

    setProperty('nar.alpha', 1)
    setTextColor('Bubble_Diatext', 'FFFFFF')
    setTextBorder('Bubble_Diatext', 3, '000000', 'outline')
end

function locationOpen(text)
    callOnHScript('makeGroup', {'locationGroup', 0, 534})
    setOnLuas('dontGoNextDia', true)

    for i = 1, #text do
        makeLuaText('locationText'..i, text[i], 0, 50, 0)
        callMethod('locationText'..i..'.set_camera', {instanceArg('camHUD')})
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
        addLuaText('locationText'..i)
        callOnHScript('addGroup', {'locationGroup', 'locationText'..i, -1})
    end

    makeLuaSprite('locationGraphic1', '', 0, 20)
    callOnHScript('makeRoundRectComplex', {'locationGraphic1', getProperty('locationText'..#text..'.x') + getTextWidth('locationText'..#text) + 75, 55, 0, 40, 0, 15, getColorFromHex('93BD67')})
    addLuaSprite('locationGraphic1', false)

    makeLuaSprite('locationGraphic2', '', 0, 20)
    callOnHScript('makeRoundRectComplex', {'locationGraphic2', getProperty('locationText'..#text..'.x') + getTextWidth('locationText'..#text) + 70, 45, 0, 32.5, 0, 12.5, getColorFromHex('E4E9B3')})
    callMethod('locationGraphic2.set_camera', {instanceArg('camHUD')})
    addLuaSprite('locationGraphic2', false)
    
    callOnHScript('addGroup', {'locationGroup', 'locationGraphic1', -1})
    callOnHScript('addGroup', {'locationGroup', 'locationGraphic2', -1})
    
    setProperty('locationGroup.scale.x', 0)
    setProperty('locationGroup.origin.x', 0)

    --open tweens
    local time = 0.25
    for i = 1, #text do
        addLuaText('locationText'..i)
        if i == 1 then
            setProperty('locationText1.y', getProperty('locationText1.y') + 100)
            startTween('locationText1 tween', 'locationText'..i, { alpha = 1, y = getProperty('locationText1.y') - 100}, 0.5, {ease = 'elasticOut'})
        elseif i > 1 then
            setProperty('locationText'..i..'.y', getProperty('locationText'..i..'.y') + 100)
            startTween('locationText'..i..' Y tween', 'locationText'..i, { y = getProperty('locationText'..i..'.y') - 100}, 0.25, {ease = 'backOut', startDelay = time / #text * i})
            startTween('locationText'..i..' Alpha tween', 'locationText'..i, { alpha = 1 }, 0.5, {ease = 'quartOut', startDelay = time / #text * i})
        end
    end
    setProperty('locationGroup.x', 0)
    doTweenX('locationGroup scale tween', 'locationGroup.scale', 1.1, 0.20, 'linear')
    startTween('locationGroup x tween2', 'locationGroup.scale', { x = 1}, 1.25, {ease = 'quartOut', startDelay = 0.20})
    startTween('locationGroup x tween3', 'locationGroup', { x = -15 }, 1.25, {ease = 'sineOut', startDelay = 0.20})
    ----

    --close tweens
    for i = 1, #text do
        startTween('locationText'..i..' close x tween', 'locationText'..i, {x = getProperty('locationText'..i..'.x') - 200}, 0.4, {ease = 'backIn', startDelay = 1.65})
        startTween('locationText'..i..' close alpha tween', 'locationText'..i, {alpha = 0}, 0.4, {ease = 'quartIn', startDelay = 1.65})
    end
    startTween('locationGroup close scale tween', 'locationGroup.scale', {x = 0}, 0.4, {ease = 'backIn', startDelay = 1.65, onComplete = 'locationTweenDone'})
    ----
end

function locationTweenDone()
    removeLuaSprite('locationGroup', true)

    setOnLuas('dontGoNextDia', false)
    callOnLuas('PrintDialogue', {Dialogue[Line]}, true)
end

function EffectOpen(info)
    setOnLuas('dontGoNextDia', true)
    local parameters = {
        x = info[2],
        y = info[3],
        width = info[4],
        height = info[5],
        direction = info[6],
        angle = info[7],
        color = info[8],
        text = info[9],
        remove = info[10]
    }
    callOnHScript('makeGroup', {'EffectGroup'..effectNum, parameters.x, parameters.y})

    if parameters.direction =='left' then
        makeLuaSprite('effect graphic'..effectNum, '', -15, 15)
    elseif parameters.direction == 'right' then
        makeLuaSprite('effect graphic'..effectNum, '', 15, 15)
    end
    makeGraphic('effect graphic'..effectNum, parameters.width, parameters.height, '000000')
    addLuaSprite('effect graphic', true)
    
    makeLuaSprite('effect graphic2'..effectNum, '', -5, -5)
    makeGraphic('effect graphic2'..effectNum, parameters.width + 10, parameters.height + 10, '000000')
    addLuaSprite('effect graphic2'..effectNum, true)
    
    makeLuaSprite('effect graphic3'..effectNum, '', 0, 0)
    makeGraphic('effect graphic3'..effectNum, parameters.width, parameters.height, 'FFFFFF')
    addLuaSprite('effect graphic3'..effectNum, true)

    makeLuaText('effect graphic Text'..effectNum, parameters.text)
    if parameters.color == '' then
        setTextColor('effect graphic Text'..effectNum, '6EA009')
    else
        setTextColor('effect graphic Text'..effectNum, parameters.color)
    end
    setTextSize('effect graphic Text'..effectNum, 30)
    setTextBorder('effect graphic Text'..effectNum, 0, '000000', 'none')
    setProperty('effect graphic Text'..effectNum..'.x', getProperty('effect graphic3'..effectNum..'.x') + getProperty('effect graphic3'..effectNum..'.width') / 2 - getTextWidth('effect graphic Text'..effectNum) / 2)
    setProperty('effect graphic Text'..effectNum..'.y', getProperty('effect graphic3'..effectNum..'.y') + getProperty('effect graphic3'..effectNum..'.height') / 2 - getProperty('effect graphic Text'..effectNum..'.height') / 2)
    setTextString('effect graphic Text'..effectNum, '')
    addLuaText('effect graphic Text'..effectNum)

    callOnHScript('addGroup', {'EffectGroup'..effectNum, 'effect graphic'..effectNum, -1})
    callOnHScript('addGroup', {'EffectGroup'..effectNum, 'effect graphic2'..effectNum, -1})
    callOnHScript('addGroup', {'EffectGroup'..effectNum, 'effect graphic3'..effectNum, -1})
    callOnHScript('addGroup', {'EffectGroup'..effectNum, 'effect graphic Text'..effectNum, -1})

    callMethod('EffectGroup'..effectNum..'.set_camera', {instanceArg('camGame')})
    setProperty('EffectGroup'..effectNum..'.angle', parameters.angle)

    --appear tweens
    setProperty('EffectGroup'..effectNum..'.alpha', 0)
    if parameters.direction == 'left' then
        setProperty('EffectGroup'..effectNum..'.x', getProperty('EffectGroup'..effectNum..'.x') - 50)
    elseif parameters.direction == 'right' then
        setProperty('EffectGroup'..effectNum..'.x', getProperty('EffectGroup'..effectNum..'.x') + 50)
    end
    setProperty('EffectGroup'..effectNum..'.y', getProperty('EffectGroup'..effectNum..'.y') - 50)
    startTween('EffectGroup'..effectNum..' tween', 'EffectGroup'..effectNum, {x = parameters.x, y = parameters.y, alpha = 1}, 0.25, {ease = 'linear', onComplete = 'EffectTweenDone'})
    ----

    if parameters.remove == '' or parameters.remove == 'next' then
        if effectOnScreen[Line + 1] == nil then
            effectOnScreen[Line + 1] = {effectNum}
        else
            effectOnScreen[Line + 1][#effectOnScreen[Line + 1] + 1] = effectNum
        end
    else
        if effectOnScreen[Line + parameters.remove] == nil then
            effectOnScreen[Line + parameters.remove] = {effectNum}
        else
            effectOnScreen[Line + parameters.remove][#effectOnScreen[Line + parameters.remove] + 1] = effectNum
        end
    end
    ----
end

function EffectTweenDone()
    textTable = TextCut(Dialogue[Line - 1][9])

    setOnLuas('dontGoNextDia', false)
    if textSpeed ~= nil then
        runTimer('effectTextTimer', textSpeed, #textTable)
        setOnLuas('textDone', false)
    elseif textSpeed == nil then
        for i = 1, #textTable do
            setTextString('effect graphic Text'..effectNum, getTextString('effect graphic Text'..effectNum)..textTable[i]) 
        end
        setOnLuas('textDone', true)
    end
end

function CloseEffect()
    if effectOnScreen[Line] ~= nil then
        for i = 1, #effectOnScreen[Line] do
            local targetNum = effectOnScreen[Line][i]
            startTween('EffectGroup'..targetNum..' close tween', 'EffectGroup'..targetNum..'.scale', {x = 0, y = 0}, 0.25, {ease = 'backIn'})
        end
    end
end

local optionNum = 0 --how many option buttons?
function OpenChoice(type, option)
    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
    setOnLuas('dontGoNextDia', true)
    for i = 1, #option do
        makeLuaSprite('option'..i, 'dialogue/bubble/option-'..type, 0, lerp(50, 450, 1 / (#option + 1) * i))
        callMethod('option'..i..'.set_camera', {instanceArg('camHUD')})
        scaleObject('option'..i, 0.2, 0.3)
        screenCenter('option'..i, 'x')
        setProperty('option'..i..'.alpha', 0)
        addLuaSprite('option'..i, true)

        makeLuaText('optionText'..i, option[i], 0, 0, getProperty('option'..i..'.y') + 25)
        setTextBorder('optionText'..i, 3, 'FFFFFF', 'outline')
        setTextColor('optionText'..i, '343334')
        setTextSize('optionText'..i, 25)
        setProperty('optionText'..i..'.scale.x', 0.9)
        setProperty('optionText'..i..'.alpha', 0)
        screenCenter('optionText'..i, 'x')
        addLuaText('optionText'..i)

        --appear tweens
        startTween('option'..i..' scale tween', 'option'..i..'.scale', {x = 0.3}, 0.35, {ease = 'backOut', startDelay = 0.5 / #option * i})
        startTween('option'..i..' alpha tween', 'option'..i, {alpha = 1}, 0.25, {ease = 'backOut', startDelay = 0.5 / #option * i})

        startTween('optionText'..i..' scale tween', 'optionText'..i..'.scale', {x = 1}, 0.35, {ease = 'backOut', startDelay = 0.5 / #option * i})
        startTween('optionText'..i..' alpha tween', 'optionText'..i, {alpha = 1}, 0.25, {ease = 'backOut', startDelay = 0.5 / #option * i})
        ----
    end
    optionNum = #option
end

local Selected = 0
function onReleasedOptionButton()
    for i = 1, optionNum do --check clicked button
        if callOnLuas('CheckCollision', {'option'..i, 'mouseCollision'}) and Selected == 0 then
            startTween('option'..i..' scale tween', 'option'..i..'.scale', {x = 0, y = 0}, 0.35, {ease = 'backIn', startDelay = 0.25, onComplete = 'onOptionSelected'})
            startTween('optionText'..i..' scale tween', 'optionText'..i..'.scale', {x = 0, y = 0}, 0.35, {ease = 'backIn', startDelay = 0.25})
            setTextColor('optionText'..i, '6EA009')
            Selected = i
            break
        end
    end
    if Selected ~= 0 then --if mouse clicked something
        for i = 1, optionNum do --check non-clicked button
            if i ~= Selected then
                startTween('option'..i..' scale tween', 'option'..i..'.scale', {y = 0}, 0.25, {ease = 'quartOut'})
                startTween('optionText'..i..' scale tween', 'optionText'..i..'.scale', {y = 0}, 0.25, {ease = 'quartOut'})
            end
        end
    end
end

function onOptionSelected()
    for i = 1, optionNum do
        removeLuaSprite('option'..i, true)
        removeLuaSprite('optionText'..i, true)
    end

    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
    callOnLuas('LoadChoiceDia', {Selected})
    Selected = 0
end

function UpdateTextPos()
    if BubbleType == 'normal' or BubbleType == 'loud' or BubbleType == 'think' or BubbleType == 'nar' then
        screenCenter('Bubble_Diatext', 'x')
        setProperty('Bubble_Diatext.y', 626 - getProperty('Bubble_Diatext.height') / 2)
    elseif BubbleType == 'effect' then
        setProperty('effect graphic Text'..effectNum..'.x', getProperty('effect graphic3'..effectNum..'.x') + getProperty('effect graphic3'..effectNum..'.width') / 2 - getTextWidth('effect graphic Text'..effectNum) / 2)
        setProperty('effect graphic Text'..effectNum..'.y', getProperty('effect graphic3'..effectNum..'.y') + getProperty('effect graphic3'..effectNum..'.height') / 2 - getProperty('effect graphic Text'..effectNum..'.height') / 2)
    end
end

function EndDialogue()
    if BubbleType == 'normal' or BubbleType == 'loud' or BubbleType == 'think' then
        startTween('Bubble_'..BubbleType..' close', 'Bubble_'..BubbleType..'.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })

        startTween('Bubble_Diatext close scale', 'Bubble_Diatext.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })
        doTweenY('Bubble_Diatext close Y', 'Bubble_Diatext', 670, 0.2, 'backIn')

        startTween('Bubble_nameTag close scale', 'Bubble_nameTag.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })

        startTween('Bubble_nameText close scale', 'Bubble_nameText.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })
        doTweenY('Bubble_nameText close Y', 'Bubble_nameText', 670, 0.2, 'backIn')
    elseif BubbleType == 'nar' then
        doTweenY('nar close scaleY', 'nar.scale', 0, 0.2, 'sineIn')

        doTweenX('text close scaleX', 'text.scale', 0, 0.2, 'backIn')
        doTweenY('text close scaleY', 'text.scale', 0, 0.2, 'backIn')

        startTween('Bubble_Diatext close scale', 'Bubble_Diatext.scale', { x = 0, y = 0}, 0.2, { ease = 'backIn' })
        if Dialogue[Line - 1][2] == true then
            setProperty('narNameTagGroup.alpha', 0)
        end
    end
    setProperty('Bubble_arrow.alpha', 0)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'bigBubbleTextTimer' then
        setTextString('Bubble_Diatext', getTextString('Bubble_Diatext')..textTable[loops - loopsLeft])
        UpdateTextPos()
        if loopsLeft == 0 then
            setOnLuas('textDone', true)
            if not dontGoNextDia then
                setProperty('Bubble_arrow.alpha', 1)
                doTweenX('Bubble_arrow pingpong x tween1', 'Bubble_arrow.scale', 0.165, 0.75, 'linear')
                doTweenY('Bubble_arrow pingpong y tween1', 'Bubble_arrow.scale', 0.14, 0.75, 'linear')
                doTweenY('Bubble_arrow tween1', 'Bubble_arrow', getProperty('Bubble_arrow.y') + 10, 0.6, 'linear')
            end
        end
    elseif tag == 'effectTextTimer' then
        setTextString('effect graphic Text'..effectNum, getTextString('effect graphic Text'..effectNum)..textTable[loops - loopsLeft])
        UpdateTextPos()
        if loopsLeft == 0 then
            effectNum = effectNum + 1
            setOnLuas('textDone', true)
        end
    end
end

function SkipText()
    cancelTimer('bigBubbleTextTimer')
    if BubbleType == 'normal' or BubbleType == 'loud' or BubbleType == 'think' or BubbleType == 'nar' then
        cancelTimer('bigBubbleTextTimer')
        setTextString('Bubble_Diatext', '')
        for i = 1, #textTable do
           setTextString('Bubble_Diatext', getTextString('Bubble_Diatext')..textTable[i]) 
        end

        UpdateTextPos()
        setOnLuas('textDone', true)
        setProperty('Bubble_arrow.alpha', 1)
        doTweenX('Bubble_arrow pingpong x tween1', 'Bubble_arrow.scale', 0.165, 0.75, 'linear')
        doTweenY('Bubble_arrow pingpong y tween1', 'Bubble_arrow.scale', 0.14, 0.75, 'linear')
        doTweenY('Bubble_arrow tween1', 'Bubble_arrow', getProperty('Bubble_arrow.y') + 10, 0.6, 'linear')
    elseif BubbleType == 'effect' then
        cancelTimer('effectTextTimer')
        setTextString('effect graphic Text'..effectNum, '')
        for i = 1, #textTable do
           setTextString('effect graphic Text'..effectNum, getTextString('effect graphic Text'..effectNum)..textTable[i]) 
        end
        effectNum = effectNum + 1
        setOnLuas('textDone', true)
    end
end

function onTweenCompleted(tag, vars)
    if tag == 'effect alpha tween' then
        setOnLuas('dontGoNextDia', false)
    elseif tag == 'Bubble_arrow pingpong x tween1' then
        doTweenX('Bubble_arrow pingpong x tween2', 'Bubble_arrow.scale', 0.135, 0.5, 'linear')
        doTweenY('Bubble_arrow pingpong y tween2', 'Bubble_arrow.scale', 0.16, 0.5, 'linear')
        doTweenY('Bubble_arrow tween1', 'Bubble_arrow', getProperty('Bubble_arrow.y') - 10, 0.5, 'linear')
    elseif tag == 'Bubble_arrow pingpong x tween2' then
        doTweenX('Bubble_arrow pingpong x tween1', 'Bubble_arrow.scale', 0.165, 0.75, 'linear')
        doTweenY('Bubble_arrow pingpong y tween1', 'Bubble_arrow.scale', 0.14, 0.75, 'linear')
        doTweenY('Bubble_arrow tween1', 'Bubble_arrow', getProperty('Bubble_arrow.y') + 10, 0.6, 'linear')
    end
end

function onTweenDone(tag, vars)
    if tag == 'tween_locationText1_x_tween' then
        makeLocateText('disappear')
    end
end

--Convenience functions

function removeSprite(tag, var)
    if stringStartsWith(var, 'name') or stringStartsWith(var, 'text') then
        removeLuaText(var, true)
    else
        removeLuaSprite(var, true)
    end
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
        if result[index] == '|' then
            result[index] = '\n'
        end
        index = index + 1
    end
    return result
end

function getColorBank(name)
    if string.lower(name) == 'bf' then
        return getColorFromHex('7BD6EB')

    elseif string.lower(name) == 'gf' then
        return getColorFromHex('A5004D')

    elseif string.lower(name) == 'gyoju' then
        return getColorFromHex('FBAC26')

    elseif string.lower(name) == 'erpin' then
        return getColorFromHex('F09D7D')

    elseif string.lower(name) == 'kyarot' then
        return getColorFromHex('F49C62')

    elseif string.lower(name) == 'butter' then
        return getColorFromHex('EEC375')

    elseif string.lower(name) == 'komi' then
        return getColorFromHex('FFA8A7')
        
    else
        return getColorFromHex(string.upper(name))
    end
end

function lerp(a, b, t)
	return a + (b - a) * t
end