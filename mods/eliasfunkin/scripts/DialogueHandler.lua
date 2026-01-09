
local _path = 'data/'..songPath..'/dialogue-'..getPropertyFromClass('backend.ClientPrefs', 'data.language')..'.json'
local _data = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile(_path)})
local _line = 1
local _eventScript = 'scripts/dialogue/events/'..songPath..'.lua'
function onCreate()
    if checkFileExists(_path) then
        precacheImage('dialogue/bubble/next-white')

        makeLuaSprite('dialogue_black')
        makeGraphic('dialogue_black', 1280, 720, '000000')
        setProperty('dialogue_black.alpha', 0)
        setObjectCamera('dialogue_black', 'other')
        addLuaSprite('dialogue_black', false)
        local diaScripts = directoryFileList('mods/'..modFolder..'/scripts/dialogue/types')
        for i = 1, #diaScripts do
            if stringEndsWith(diaScripts[i], '.lua') then
                addLuaScript('scripts/dialogue/types/'..diaScripts[i])
            elseif stringEndsWith(diaScripts[i], '.hx') then
                addHScript('scripts/dialogue/types/'..diaScripts[i])
            end
        end
        if checkFileExists(_eventScript) then
            addLuaScript(_eventScript)
        end
        setOnLuas('DialogueFinished', false)
        setOnScripts('dontGoNextDia', true)
        setOnScripts('textDone', true)
        defineFormats()
    else  --if dialogue file doesnt exists
        close()
    end
end

function onCreatePost()
    if checkFileExists(_path) then
        setProperty('uiGroup.alpha', 0)
        runTimer('wait', 1)
    end
end

function onStartCountdown()
    if not DialogueFinished then
        return Function_Stop
    elseif DialogueFinished then
        return Function_Continue
    end
end

function LoadDialogue()
    callOnScripts('LoadDialogue')

    setOnScripts('dontGoNextDia', false)
    PrintNextDialogue()
end

function onPrintDialogue(info)
    if info.type == 'nothing' then
        setOnScripts('textDone', true)
    else
        setOnScripts('textDone', false)
    end

    callOnScripts('onPrintDialogue', {info})
end

function PrintNextDialogue()
    onPrintDialogue(_data[_line])
    _line = _line + 1
end

function onSkip()
    setOnScripts('textDone', true)
    callOnScripts('onSkip')
end

function onEndDialogue(type)
    callOnScripts('onEndDialogue', {type})

    setOnLuas('DialogueFinished', true)
    close()
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'wait' then
        LoadDialogue()
    end
end

local pressed = false
function onUpdate(elapsed)
    if not DialogueFinished and not dontGoNextDia then
        if keyJustPressed('accept') and textDone then
            playSound('dialogue press')
            pressed = true
        end
        if keyReleased('accept') and textDone and pressed then
            playSound('dialogue release')
            pressed = false
            if _data[_line] ~= nil and textDone then
                PrintNextDialogue()
            elseif not textDone then
                onSkip()
            else
                onEndDialogue(_data[_line-1].type)
            end
        end
        if keyboardJustPressed('ESC') or keyJustPressed('back') then
            onEndDialogue()
        end
    end
end

function getColorBank(name)
    if string.lower(name) == 'bf' then
        return '7BD6EB'

    elseif string.lower(name) == 'gf' then
        return 'A5004D'

    elseif string.lower(name) == 'gyoju' then
        return 'FBAC26'

    elseif string.lower(name) == 'erpin' then
        return 'F09D7D'

    elseif string.lower(name) == 'kyarot' then
        return 'F49C62'

    elseif string.lower(name) == 'butter' then
        return 'EEC375'

    elseif string.lower(name) == 'kommy' then
        return 'FFA8A7'
        
    else
        return string.upper(name)
    end
end

function defineFormats()
    createInstance('Text_format', 'flixel.text.FlxTextFormat', {FlxColor('RED')})
    createInstance('Text_marker', 'flixel.text.FlxTextFormatMarkerPair', {instanceArg('Text_format'), '<r>'})
end