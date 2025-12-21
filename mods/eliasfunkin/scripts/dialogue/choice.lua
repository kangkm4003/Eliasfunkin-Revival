function onCreate()
    precacheImage('dialogue/bubble/option-0')
    precacheImage('dialogue/bubble/option-1')
end

local optionNum = 0
local optionDiaData = {}
function makeChoice(choiceData)
    for i = 1, #choiceData do
        makeLuaSprite('option'..i, 'dialogue/bubble/option-'..choiceData[i].type, 0, lerp(50, 450, 1 / (#choiceData + 1) * i))
        setObjectCamera('option'..i, 'other')
        scaleObject('option'..i, 0.2, 0.3)
        screenCenter('option'..i, 'x')
        setProperty('option'..i..'.alpha', 0)
        addLuaSprite('option'..i, true)

        makeLuaText('optionText'..i, choiceData[i].text, 0, 0, getProperty('option'..i..'.y') + 25)
        setObjectCamera('optionText'..i, 'other')
        setTextFont('optionText'..i, 'vcr.ttf')
        setTextBorder('optionText'..i, 3, 'FFFFFF', 'outline')
        setTextColor('optionText'..i, '343334')
        setTextSize('optionText'..i, 25)
        setProperty('optionText'..i..'.scale.x', 0.9)
        screenCenter('optionText'..i, 'x')
        setProperty('optionText'..i..'.alpha', 0)
        addLuaText('optionText'..i)

        startTween('option'..i..' scale tween', 'option'..i..'.scale', {x = 0.3}, 0.35, {ease = 'backOut', startDelay = 0.5 / #choiceData * i})
        startTween('option'..i..' alpha tween', 'option'..i, {alpha = 1}, 0.25, {ease = 'backOut', startDelay = 0.5 / #choiceData * i})

        startTween('optionText'..i..' scale tween', 'optionText'..i..'.scale', {x = 1}, 0.35, {ease = 'backOut', startDelay = 0.5 / #choiceData * i})
        startTween('optionText'..i..' alpha tween', 'optionText'..i, {alpha = 1}, 0.25, {ease = 'backOut', startDelay = 0.5 / #choiceData * i})
    end
    optionNum = #choiceData
end

function onPrintDialogue(info)
    if info.choice ~= nil then
        setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
        setOnLuas('dontGoNextDia', true)
        optionDiaData = info.choice
        makeChoice(info.choice)
    end
end

local Selected = 0

function onOptionSelected()
    for i = 1, optionNum do
        removeLuaSprite('option'..i, true)
        removeLuaText('optionText'..i, true)
    end
    local temp = Dialogue
    for i = 1, #Dialogue[Line-1].choice[Selected].diaData do
        table.insert(temp, Line + i - 1, Dialogue[Line-1].choice[Selected].diaData[i])
    end
    setPropertyFromClass("flixel.FlxG", "mouse.visible", false)
    setOnScripts('Dialogue', temp)
    setOnLuas('dontGoNextDia', false)
    callOnLuas('onPrintDialogue', {Dialogue[Line], Dialogue[Line-1]})
end

function onUpdate(elapsed)
    if luaSpriteExists('option1') and mouseReleased('left') then
        for i = 1, optionNum do
            if CheckCollision('option'..i) then
                startTween('option'..i..' scale tween', 'option'..i..'.scale', {x = 0, y = 0}, 0.35, {ease = 'backIn', startDelay = 0.25, onComplete = 'onOptionSelected'})
                startTween('optionText'..i..' scale tween', 'optionText'..i..'.scale', {x = 0, y = 0}, 0.35, {ease = 'backIn', startDelay = 0.25})
                setTextColor('optionText'..i, '6EA009')
                Selected = i
                break
            end
        end
        if Selected ~= 0 then --if mouse clicked something
            for i = 1, optionNum do
                if i ~= Selected then
                    startTween('option'..i..' scale tween', 'option'..i..'.scale', {y = 0}, 0.25, {ease = 'quartOut'})
                    startTween('optionText'..i..' scale tween', 'optionText'..i..'.scale', {y = 0}, 0.25, {ease = 'quartOut'})
                end
            end
        end
    end
end

function CheckCollision(object1)-- objectsOverlap() screw this it's too buggy
    --code from https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    if getProperty(object1..'.x') < getMouseX('other') and 
    getProperty(object1..'.x') + getProperty(object1..'.width') > getMouseX('other') and 
    getProperty(object1..'.y') < getMouseY('other') and 
    getProperty(object1..'.y') + getProperty(object1..'.height') > getMouseY('other') then
        return true
    else
        return false
    end
end

function lerp(a, b, t)
	return a + (b - a) * t
end