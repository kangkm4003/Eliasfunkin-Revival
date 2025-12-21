local Num = 1
local effectBoxes = {}
local antialiasing = getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing')

function makeEffectBox(x, y, width, height, angle, text, lifeSpan)
    createInstance('effectBoxGroup'..Num, 'flixel.group.FlxTypedSpriteGroup', {x, y})
    setObjectCamera('effectBoxGroup'..Num, 'other')

    makeLuaSprite('effectBox'..Num, '', 0, 0)
    makeGraphic('effectBox'..Num, width, height, 'TRANSPARENT')
    runHaxeCode([[
        import flixel.util.FlxSpriteUtil;
        var lineStyle:LineStyle = {
    		color: FlxColor.BLACK,
    		thickness: 10,
			capsStyle: 3
		};

        FlxSpriteUtil.drawRect(
            PlayState.instance.variables.get('effectBox]]..Num..[['),
            0, 0,
            ]]..width..[[, ]]..height..[[,
            FlxColor.WHITE,
            lineStyle
        );
    ]])
    callMethod('effectBoxGroup'..Num..'.add', {instanceArg('effectBox'..Num)})
    
    createInstance('effectBox'..Num..'_diaText', 'flixel.addons.text.FlxTypeText', {0, 60, width, text, 25})
    setObjectCamera('effectBox'..Num..'_diaText', 'other')
    setTextFont('effectBox'..Num..'_diaText', 'vcr.ttf')
    setTextAlignment('effectBox'..Num..'_diaText', 'center')
    setTextColor('effectBox'..Num..'_diaText', '90A95F')
    setTextBorder('effectBox'..Num..'_diaText', 0, '000000', 'none')
    setProperty('effectBox'..Num..'_diaText.antialiasing', antialiasing)
    runHaxeCode([[
        PlayState.instance.variables.get('effectBox]]..Num..[[_diaText').completeCallback = 
        function() 
        {
            game.callOnLuas('effectBox_TextDone', [number]);
        };
    ]], {number = Num})
    callMethod('effectBoxGroup'..Num..'.add', {instanceArg('effectBox'..Num..'_diaText')})

    setProperty('effectBoxGroup'..Num..'.angle', angle)
    setProperty('effectBoxGroup'..Num..'.alpha', 0)
    addInstance('effectBoxGroup'..Num, true)

    effectBoxes[#effectBoxes + 1] = {id = Num, life = lifeSpan}

    
end

function effectBox_TextDone(num)
    callScript('scripts/DialogueSystem', 'onSkip')
    callMethod('effectBox'..num..'_diaText.skip')
end

function onTimerCompleted(tag, loops, loopsLeft)
    if string.find(tag, 'effectBox') ~= nil then
        setOnLuas('dontGoNextDia', false)
        callMethod(tag..'.start', {0.02, true})
    end
end

function onPrintDialogue(info)
    for i = 1, #effectBoxes do
        if effectBoxes[i].life <= 0 then
            startTween('effectBoxGroup'..effectBoxes[i].id..' Tween', 'effectBoxGroup'..effectBoxes[i].id..'.scale', {
                x = 0,
                y = 0
            }, 0.2, {ease = 'backIn'})
        else
            effectBoxes[i].life = effectBoxes[i].life - 1
        end
    end
    if info.type == 'effectBox' then
        setOnLuas('dontGoNextDia', true)
        info.lifeSpan = info.lifeSpan or 0
        makeEffectBox(info.x, info.y, info.width, info.height, info.angle, info.text, info.lifeSpan)
        startTween('effectBoxGroup'..Num..' Tween', 'effectBoxGroup'..Num, {
            x = info.x + 50,
            y = info.y - 50,
            alpha = 1,
        }, 0.5)
        runTimer('effectBox'..Num..'_diaText', 0.5)

        Num = Num + 1
    end
end

function onEndDialogue(type)
    for i = 1, #effectBoxes do
         startTween('effectBoxGroup'..effectBoxes[i].id..' Tween', 'effectBoxGroup'..effectBoxes[i].id..'.scale', {
            x = 0,
            y = 0
        }, 0.2, {ease = 'backIn'})
    end
end