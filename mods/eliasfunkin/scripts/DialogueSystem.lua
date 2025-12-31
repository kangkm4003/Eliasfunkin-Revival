

local colorBank = {
    bf = '7BD6EB',
    gf = 'A5004D',
    erpin = 'F09D7D',
    kyarot = 'F49C62',
    butter = 'EEC375',
    komi = 'FFA8A7'
}

local _dialogueFile = 'data/'..songPath..'/dialogue-'..getPropertyFromClass('backend.ClientPrefs', 'data.language')..'.json'
function onCreate()
    if checkFileExists(_dialogueFile) then
        precacheImage('dialogue/bubble/next-white')

        makeLuaSprite('dialogue_black')
        makeGraphic('dialogue_black', 1280, 720, '000000')
        setProperty('dialogue_black.alpha', 0)
        setObjectCamera('dialogue_black', 'other')
        addLuaSprite('dialogue_black', false)
        local diaScripts = directoryFileList('mods/'..modFolder..'/scripts/dialogue')
        for i = 1, #diaScripts do
            if stringEndsWith(diaScripts[i], '.lua') then
                addLuaScript('scripts/dialogue/'..diaScripts[i])
            elseif stringEndsWith(diaScripts[i], '.hx') then
                addHScript('scripts/dialogue/'..diaScripts[i])
            end
        end
        setOnLuas('DialogueFinished', false)
        setOnScripts('dontGoNextDia', true)
        setOnScripts('textDone', true)
        setOnScripts('Line', 1)
        setOnScripts('Dialogue', callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile(_dialogueFile)}))
        defineFormats()
    else  --if dialogue file doesnt exists
        close()
    end
end

function onCreatePost()
    if checkFileExists(_dialogueFile) then
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
    onPrintDialogue(Dialogue[Line])
end

function onPrintDialogue(info, prev)
    if type(info.type) ~= 'string' or type(info.text) ~= 'string' then
        debugPrint('ERROR: info\'s type or text value is not string', 'RED')
        onEndDialogue(nil)
    end
    setOnScripts('textDone', false)
    callOnScripts('onPrintDialogue', {info, prev})

    setOnScripts('Line', Line + 1)
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
            if Dialogue[Line] ~= nil and textDone then
                onPrintDialogue(Dialogue[Line], Dialogue[Line-1])
            elseif not textDone then
                onSkip()
            else
                onEndDialogue(Dialogue[Line-1].type)
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

    elseif string.lower(name) == 'komi' then
        return 'FFA8A7'
        
    else
        return string.upper(name)
    end
end

function defineFormats()
    createInstance('Text_format', 'flixel.text.FlxTextFormat', {FlxColor('RED')})
    createInstance('Text_marker', 'flixel.text.FlxTextFormatMarkerPair', {instanceArg('Text_format'), '<r>'})
end