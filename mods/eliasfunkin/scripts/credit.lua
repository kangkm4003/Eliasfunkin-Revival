--local ModulePath = io.popen("cd"):read("*l")..
--    '\\mods\\trickcal\\scripts\\module\\?.lua'
--
--package.path = ModulePath

local language = getPropertyFromClass('backend.ClientPrefs', 'data.language')
local antialiasing = getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing')
function onSongStart()
    startCredit()
end

local minimi_opp_anim = getRandomInt(1, 4)
local minimi_bf_anim = getRandomInt(1, 4)
function onCreate()
    math.randomseed(os.time())
    addHScript('scripts/import/Spawn Advansed Graphic')
    addHScript('scripts/import/Custom Sprite Group')

    local creditInfo = {}
    if checkFileExists('data/'..songPath..'/credit-'..language..'.json') then
        creditInfo = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('data/'..songPath..'/credit-'..language..'.json')})
    elseif checkFileExists('data/'..songPath..'/credit-en-US.json') then
        creditInfo = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('data/'..songPath..'/credit-en-US.json')})
    else
        creditInfo = nil
    end

    callOnHScript('makeGroup', {'creditGroup', -500, screenHeight / 2 - 100})

    --top Cloud
    makeLuaText('credit_playing', '', 0, 0, 0)
    setTextString('credit_playing', getTranslationPhrase('credit_playing', 'Now Playing...'))
    setTextColor('credit_playing', '51953B')
    setTextSize('credit_playing', 30)
    setTextBorder('credit_playing', 3, 'FBFFDC')
    setProperty('credit_playing.antialiasing', antialiasing)
    ----

    --song name Cloud
    makeLuaText('credit_songText', songName, 0, 0, 36)
    setTextColor('credit_songText', '3E7736')
    setTextSize('credit_songText', 90)
    setProperty('credit_songText.x', getTextWidth('credit_playing') / 2 - getTextWidth('credit_songText') / 2)
    setTextBorder('credit_songText', 3, 'FBFFDC')
    setProperty('credit_songText.antialiasing', antialiasing)
    -----

    if creditInfo ~= nil then
        for k, v in pairs(creditInfo.text) do
            makeLuaText('credit_dev'..k, v, 0, 0, 101 + 40 * k)
            setTextColor('credit_dev'..k, '51953B')
            setTextSize('credit_dev'..k, 30)
            setProperty('credit_dev'..k..'.x', getTextWidth('credit_playing') / 2 - getTextWidth('credit_dev'..k) / 2)
            setTextBorder('credit_dev'..k, 3, 'FBFFDC')
            setProperty('credit_dev'..k..'.antialiasing', antialiasing)
        end
    end

    addCloudOnText('credit_playing', 'topCloudGroup', {x = 0.7, y = 0.7})

    if creditInfo ~= nil then
        for k, v in pairs(creditInfo.text) do
            addCloudOnText('credit_dev'..k, 'dev'..k..'CloudGroup', {x = 0.7, y = 0.7})
            callOnHScript('addGroup', {'creditGroup', 'dev'..k..'CloudGroup', -1})
        end
    end

    addCloudOnText('credit_songText', 'songCloudGroup', {x = 1.5, y = 1.5})
    callOnHScript('addGroup', {'creditGroup', 'topCloudGroup', -1})
    callOnHScript('addGroup', {'creditGroup', 'songCloudGroup', -1})

    addLuaText('credit_playing')
    addLuaText('credit_songText')
    if creditInfo ~= nil then
        for k, v in pairs(creditInfo.text) do
            addLuaText('credit_dev'..k)
            callOnHScript('addGroup', {'creditGroup', 'credit_dev'..k, -1})
        end
    end

    callOnHScript('addGroup', {'creditGroup', 'credit_playing', -1})
    callOnHScript('addGroup', {'creditGroup', 'credit_songText', -1})

    createInstance('credit_cloudEffect_emitter', 'flixel.effects.particles.FlxTypedEmitter', {300, 300, 0})

    for i = 0, 20 do
        createInstance('credit_cloudEffect_effect'..i, 'flixel.effects.particles.FlxParticle')
        makeGraphic('credit_cloudEffect_effect'..i, 150, 100, 'TRANSPARENT')
        callMethodFromClass('flixel.util.FlxSpriteUtil', 'drawEllipse', {instanceArg('credit_cloudEffect_effect'..i), 0, 0, 150, 100, FlxColor('#FBFFDC')})
        setProperty('credit_cloudEffect_effect'..i..'.exists', false)
        setProperty('credit_cloudEffect_effect'..i..'.antialiasing', antialiasing)
        callMethod('credit_cloudEffect_emitter.add', {instanceArg('credit_cloudEffect_effect'..i)})
    end

    setObjectCamera('credit_cloudEffect_emitter', 'other')
    addInstance('credit_cloudEffect_emitter', false)
    setObjectOrder('credit_cloudEffect_emitter', getObjectOrder('creditGroup') - 1)
    callMethod('credit_cloudEffect_emitter.speed.set', {50, 100, 0, 0})
    callMethod('credit_cloudEffect_emitter.setSize', {getProperty('creditGroup.width') * 0.6, getProperty('creditGroup.height') * 0.6})
    callMethod('credit_cloudEffect_emitter.scale.set', {0.8, 0.8, 1.1, 1.1, 0, 0})
    callMethod('credit_cloudEffect_emitter.lifespan.set', {2, 1})
    
    callMethod('credit_cloudEffect_emitter.start', {false, 0.05, 0})
    setProperty('credit_cloudEffect_emitter.emitting', false)

    if creditInfo == nil then
        makeLuaSprite('minimi_opp', '', -getTextWidth('credit_songText') * 0.6 - 20, 10)
        makeLuaSprite('minimi_bf', '', getTextWidth('credit_songText') * 0.6, 10)
        setProperty('minimi_opp.alpha', 0)
        setProperty('minimi_bf.alpha', 0)
    elseif creditInfo ~= nil then
        if creditInfo.minimi.left ~= nil then
            if checkFileExists('images/minimi/'..creditInfo.minimi.left..'.png') then
                makeLuaSprite('minimi_opp', 'minimi/'..creditInfo.minimi.left, -getTextWidth('credit_songText') * 0.6 - 20, 10)
            else
                makeLuaSprite('minimi_opp', 'minimi/Erpin', -getTextWidth('credit_songText') * 0.6 - 20, 10)
            end
        else
            makeLuaSprite('minimi_opp', '', -getTextWidth('credit_songText') * 0.6 - 20, 10)
        end

        if creditInfo.minimi.right ~= nil then
            if checkFileExists('images/minimi/'..creditInfo.minimi.right..'.png') then
                makeLuaSprite('minimi_bf', 'minimi/'..creditInfo.minimi.right, getTextWidth('credit_songText') * 0.6, 10)
            else
                makeLuaSprite('minimi_bf', 'minimi/BF', getTextWidth('credit_songText') * 0.6, 10)
            end
        else
            makeLuaSprite('minimi_bf', '', getTextWidth('credit_songText') * 0.6, 10)
            setProperty('minimi_bf.alpha', 0)
        end
    end
        setObjectCamera('minimi_opp', 'other')
        scaleObject('minimi_opp', 0.9, 0.9)
        if minimi_opp_anim == 1 or minimi_opp_anim == 2 then
            setProperty('minimi_opp.origin.y', 200)
            setProperty('minimi_opp.origin.x', 100)
        end
        setProperty('minimi_opp.flipX', true)
        addLuaSprite('minimi_opp', true)
        callOnHScript('addGroup', {'creditGroup', 'minimi_opp', -1})

        setObjectCamera('minimi_bf', 'other')
        scaleObject('minimi_bf', 0.9, 0.9)
        if minimi_bf_anim == 1 or minimi_bf_anim == 2 then
            setProperty('minimi_bf.origin.y', 200)
            setProperty('minimi_bf.origin.x', 100)
        end
        addLuaSprite('minimi_bf', true)
        callOnHScript('addGroup', {'creditGroup', 'minimi_bf', -1})

    setProperty('creditGroup.visible', false)
    setObjectCamera('creditGroup', 'other')
end

function onUpdatePost(elapsed)
    callMethod('credit_cloudEffect_emitter.setPosition', {getProperty('creditGroup.x'), getProperty('creditGroup.y')})
end

function startCredit()
    setProperty('creditGroup.visible', true)
    cloudEffectOn()
    startTween('creditGroup X appear Tween', 'creditGroup', {x = screenWidth / 2 - 85}, 1, {ease = 'circOut', onComplete = 'cloudEffectOff'})
    startTween('creditGroup X Disappear Tween', 'creditGroup', {x = 3000}, 1, {ease = 'circIn', startDelay = 2, onStart = 'cloudEffectOn', onComplete = 'creditEnd'})
end

function cloudEffectOn()
    setProperty('credit_cloudEffect_emitter.emitting', true)
end

function cloudEffectOff()
    setProperty('credit_cloudEffect_emitter.emitting', false)
end

function creditEnd()
    removeLuaSprite('creditGroup', true)
    close()
end

local CloudGroupList = {}
function addCloudOnText(targetText, cloudGroupName, scale)
    local ellipse = {
        width = 150 * scale.x,
        height = 100 * scale.y,
    }
    ellipse.length = math.floor(getTextWidth(targetText) / (100 * scale.x)) --Number of pre-calculated ellipses(Of course, the decimal point is dropped)

    callOnHScript('makeGroup', {cloudGroupName, getProperty(targetText..'.x'), getProperty(targetText..'.y')})
    for i = 0, ellipse.length do
        local ellipsePos = {
            x = lerp(50 * scale.x, getTextWidth(targetText) - (50 * scale.x), i / ellipse.length) - ellipse.width / 2,
            y = getProperty(targetText..'.height') / 2 - ellipse.height / 2
        }
        makeLuaSprite(cloudGroupName..'_ellipse'..i, '', ellipsePos.x + 10 * scale.x, getRandomInt(ellipsePos.y - 10 * scale.y, ellipsePos.y + 10 * scale.y))
        callOnHScript('makeEllipse', {cloudGroupName..'_ellipse'..i, ellipse.width, ellipse.height,  getColorFromHex('FBFFDC')})
        setProperty(cloudGroupName..'_ellipse'..i..'.origin.x', ellipse.width / 2)
        setProperty(cloudGroupName..'_ellipse'..i..'.origin.y', ellipse.height / 2)
        setProperty(cloudGroupName..'_ellipse'..i..'.antialiasing', antialiasing)
        addLuaSprite(cloudGroupName..'_ellipse'..i, true)
        callOnHScript('addGroup', {cloudGroupName, cloudGroupName..'_ellipse'..i, 0})

        cloudTween(cloudGroupName..'_ellipse'..i..' animation', cloudGroupName..'_ellipse'..i..'.scale')
    end
    CloudGroupList[#CloudGroupList + 1] = {cloudGroupName, ellipse.length + 1}
end

function cloudTween(tag, vars)
    startTween(tag, vars, {x = getRandomFloat(0.9, 1.1), y = getRandomFloat(0.9, 1.1)}, getRandomFloat(0.1, 0.25), {ease = 'linear', onComplete = 'cloudTween'})
end

local time = 0
function onUpdate(elapsed)
    if luaSpriteExists('minimi_opp') and luaSpriteExists('minimi_bf') then
        time = time + elapsed
        if minimi_opp_anim == 1 then
            setProperty('minimi_opp.angle', math.sin(time * 20) * 5)
            setProperty('minimi_opp.scale.y', math.cos(time * 20) * 0.025 + 0.9)
        elseif minimi_opp_anim == 2 then
            setProperty('minimi_opp.angle', math.sin(time * 10) * 5)
            setProperty('minimi_opp.scale.y', -math.cos(time * 20) * 0.025 + 0.9)
        elseif minimi_opp_anim == 3 then
            setProperty('minimi_opp.angle', time * 200 % 360)
        elseif minimi_opp_anim == 4 then
            setProperty('minimi_opp.y', -math.abs(math.sin(time * 10) * 25) + 270)
            setProperty('minimi_opp.scale.x', -math.abs(math.sin(time * 10) * -0.15) + 1)
        end
        if minimi_bf_anim == 1 then
            setProperty('minimi_bf.angle', math.sin(time * 20) * 5)
            setProperty('minimi_bf.scale.y', math.cos(time * 20) * 0.025 + 0.9)
        elseif minimi_bf_anim == 2 then
            setProperty('minimi_bf.angle', math.sin(time * 10) * 5)
            setProperty('minimi_bf.scale.y', -math.cos(time * 20) * 0.025 + 0.9)
        elseif minimi_bf_anim == 3 then
            setProperty('minimi_bf.angle', time * 200 % 360)
        elseif minimi_bf_anim == 4 then
            setProperty('minimi_bf.y', -math.abs(math.sin(time * 10) * 25) + 270)
            setProperty('minimi_bf.scale.x', -math.abs(math.sin(time * 10) * -0.15) + 1)
        end
    end
end

function lerp(a, b, t)
	return a + (b - a) * t
end