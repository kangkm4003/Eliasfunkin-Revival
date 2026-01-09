function onCreate()
    createInstance('boxGroup', 'flixel.group.FlxTypedSpriteGroup', {0, 500})
    setObjectCamera('boxGroup', 'other')

    makeLuaSprite('box', '', 0, 0)
    makeGraphic('box', 1170, 320, 'TRANSPARENT')
    screenCenter('box', 'x')
    setProperty('box.visible', false)
    callMethod('boxGroup.add', {instanceArg('box')})

    createInstance('box_diaText', 'flixel.addons.text.FlxTypeText', {285, 100, 700, '', 30})
    setTextFont('box_diaText', 'vcr.ttf')
    setTextAlignment('box_diaText', 'center')
    setTextBorder('box_diaText', 0, 'FFFFFF', 'none')
    setTextColor('box_diaText', 'FFFFFF')
    runHaxeCode([[
        import flixel.util.FlxSpriteUtil;
        var lineStyle:LineStyle = {
    		color: FlxColor.GRAY,
    		thickness: 10,
			capsStyle: 2
		};

        FlxSpriteUtil.drawRoundRectComplex(
            PlayState.instance.variables.get('box'),
            10, 10,
            1150, 300,
            100, 100,
            0, 0,
            0xC8000000,
            lineStyle
        );

        PlayState.instance.variables.get('box_diaText').completeCallback = 
        function() 
        {
            game.callOnLuas('box_TextDone');
        };
    ]])

    if getTextSizeSetting() == 'Very Large' then
        setTextSize('box_diaText', 35)
    elseif getTextSizeSetting() == 'Large' then
        setTextSize('box_diaText', 32)
    elseif getTextSizeSetting() == 'Middle' then
        setTextSize('box_diaText', 30)
    elseif getTextSizeSetting() == 'Small' then
        setTextSize('box_diaText', 27)
    end

    setProperty('box_diaText.visible', false)
    callMethod('boxGroup.add', {instanceArg('box_diaText')})

    makeLuaSprite('box_arrow', 'dialogue/bubble/next-white', 983, 167)
    setObjectCamera('box_arrow', 'other')
    scaleObject('box_arrow', 0.05, 0.05)
    setProperty('box_arrow.visible', false)
    startTween('box_arrow Tween', 'box_arrow', {y = 677}, 0.5, {type = 'pingpong'})
    callMethod('boxGroup.add', {instanceArg('box_arrow')})


    addInstance('boxGroup', true)
end

function onPrintDialogue(info)
    setProperty('box_arrow.visible', false)
    if info.type == 'box' then
        setProperty('boxGroup.visible', true)

        callMethod('box_diaText.resetText', {info.text})
        callMethod('box_diaText.applyMarkup', {info.text, {instanceArg('Text_marker')}})
        callMethod('box_diaText.start', {0.02, true})
    else
        setProperty('boxGroup.visible', false)
    end
end

function box_TextDone()
    callScript('scripts/DialogueHandler', 'onSkip')
    callMethod('box_diaText.skip')
    setProperty('box_arrow.visible', true)
end

function onEndDialogue(type)
    onDestroy()
end

function onDestroy()
    removeLuaSprite('boxGroup', true)
    removeLuaSprite('box_arrow', true)
    close()
end