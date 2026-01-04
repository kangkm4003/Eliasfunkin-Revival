local lyrics = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('data/'..songPath..'/lyrics.json')}) or nil
local curLyricsLine = 1

function onCreate()
    setProperty('skipArrowStartTween', true)
    setProperty('skipCountdown', true)
    setProperty('camHUD.bgColor', getColorFromName('BLACK'))
    callMethodFromClass('backend.Paths', 'video', {'way back home'})

    makeLuaSprite('suro', 'minimi/Suro', 0, screenHeight - 200)
    setObjectCamera('suro', 'hud')
    setProperty('suro.origin.y', 200)
    setProperty('suro.flipX', true)
    setProperty('suro.alpha', 0)
    addLuaSprite('suro', true)

    --Same look, but Different path.
    makeLuaSprite('uros', 'minimi/Uros', 0, screenHeight - 200)
    setObjectCamera('uros', 'hud')
    setProperty('uros.origin.y', 200)
    setProperty('uros.flipX', true)
    setProperty('uros.alpha', 0)
    addLuaSprite('uros', true)

    makeLuaText('lyrics', '', 220, 0, 0)
    setTextFont('lyrics', 'vcr.ttf')
    setTextAlignment('lyrics', 'center')
    setTextBorder('lyrics', 3,  '343334', 'outline')
    setTextColor('lyrics', getColorFromHex('f5fce6'))
    setTextSize('lyrics', 25)
    setProperty('lyrics.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    runHaxeCode([[
        var lyrics = PlayState.instance.variables.get("lyrics");
        var suro = PlayState.instance.variables.get("suro");

        lyrics.x = suro.getGraphicMidpoint().x - lyrics.getGraphicMidpoint().x + 10;
        lyrics.y = suro.getGraphicMidpoint().y - lyrics.height - 120;
    ]])
    addLuaText('lyrics')

    if botPlay then
        setProperty('botplayTxt.visible', 0)
    end
end

function onCreatePost()
    for i = 0, getProperty('opponentStrums.length') do
        setPropertyFromGroup('opponentStrums', i, 'visible', false)
    end
end

function onStepHit()
    if curStep == 16 then
        --startVideo('way back home', false, true, false, true)
    end
end

function onEvent(event, value1, value2, strumTime)
    if event == 'suroSings' then
        Values = {
            tonumber(stringSplit(value1, ',')[1]), 
            stringTrim(stringSplit(value1, ',')[2]) or 'scale',
            stringTrim(stringSplit(value1, ',')[3]) or 'suro',
            tonumber(stringSplit(value2, ',')[1]) or 2,
            stringTrim(stringSplit(value2, ',')[2]) or "expoOut"
        }

        Values[4] = ((crochet / 4) / 1000) * Values[4]
        if Values[2] == "lyrics" then
            if lyrics then
                if Values[1] == 0 then
                    doTweenAlpha('lyricsAlpha', 'lyrics', 0, Values[4], Values[5])
                else
                    cancelTween('lyricsAlpha')
                    setProperty('lyrics.alpha', 1)
                    setTextString('lyrics', stringTrim(lyrics[curLyricsLine]))
                    runHaxeCode([[
                        var lyrics = PlayState.instance.variables.get("lyrics");
                        var suro = PlayState.instance.variables.get("suro");
                        lyrics.y = suro.getGraphicMidpoint().y - lyrics.height - 120;
                    ]])
                    curLyricsLine = curLyricsLine + 1
                end
            end
        elseif Values[2] == "alpha" then
            doTweenAlpha('suroAlpha', Values[3], Values[1], Values[4], Values[5])
        elseif Values[2] == 'scale' then
            if Values[4] <= 0 then
                cancelTween('suroScale')
                setProperty(Values[3]..'.scale.y', Values[1])
            else
                setProperty(Values[3]..'.scale.y', Values[1])
                doTweenY('suroScale', Values[3]..'.scale', 1, Values[4], Values[5])
            end
        end
    end
end

function onGameOver()
    return Function_Stop
end