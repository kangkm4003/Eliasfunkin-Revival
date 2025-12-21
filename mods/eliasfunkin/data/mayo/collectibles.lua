function onCreate()
    makeLuaSprite('collectible1', 'stage/mayoHouse/collectible1', 1277, 676)
    addLuaSprite('collectible1', false)
    setObjectOrder('collectible1', 2)

    makeLuaSprite('hitbox_collectible1', '', 1330, 700)
    makeGraphic('hitbox_collectible1', 100, 230, 'FFFFFF')
    setProperty('hitbox_collectible1.alpha', 0)
    addLuaSprite('hitbox_collectible1', false)

    makeLuaSprite('collectible2', 'stage/mayoHouse/collectible2A', 452, 458)
    addLuaSprite('collectible2', false)

    makeLuaSprite('hitbox_collectible2', '', 455, 530)
    makeGraphic('hitbox_collectible2', 170, 200, 'FFFFFF')
    setProperty('hitbox_collectible2.alpha', 0)
    addLuaSprite('hitbox_collectible2', false)

    makeLuaSprite('collectible3', 'stage/mayoHouse/collectible3', 744, 607)
    addLuaSprite('collectible3', false)

    makeLuaSprite('hitbox_collectible3', '', 756, 620)
    makeGraphic('hitbox_collectible3', 100, 100, 'FFFFFF')
    setProperty('hitbox_collectible3.alpha', 0)
    addLuaSprite('hitbox_collectible3', false)

    makeLuaSprite('mouseCollision', '')
    makeGraphic('mouseCollision', 1, 1, 'FFFFFF')
    setProperty('mouseCollision.alpha', 0)
    addLuaSprite('mouseCollision', false)
end

function onUpdate()
    setProperty('mouseCollision.x', getMouseX('game') + getCameraScrollX() - 640)
    setProperty('mouseCollision.y', getMouseY('game') + getCameraScrollY() - 360)

    --if objectsOverlap('mouseCollision', 'hitbox_collectible1') or 
    --objectsOverlap('mouseCollision', 'hitbox_collectible2') or 
    --objectsOverlap('mouseCollision', 'hitbox_collectible3') then
    --    debugPrint('true')
    --else
    --    debugPrint('false')
    --end

    if mouseClicked('left') then
        onMouseClicked()
    elseif mouseReleased('left') then
        onMouseReleased()
    end
end

function onMouseClicked()
    if CheckCollision('mouseCollision', 'hitbox_collectible1') then
        setProperty('collectible1.colorTransform.redMultiplier', 0.5)
        setProperty('collectible1.colorTransform.greenMultiplier', 0.5)
        setProperty('collectible1.colorTransform.blueMultiplier', 0.5)
    end
    if CheckCollision('mouseCollision', 'hitbox_collectible2') then
        setProperty('collectible2.colorTransform.redMultiplier', 0.5)
        setProperty('collectible2.colorTransform.greenMultiplier', 0.5)
        setProperty('collectible2.colorTransform.blueMultiplier', 0.5)
    end
    if CheckCollision('mouseCollision', 'hitbox_collectible3') then
        setProperty('collectible3.colorTransform.redMultiplier', 0.5)
        setProperty('collectible3.colorTransform.greenMultiplier', 0.5)
        setProperty('collectible3.colorTransform.blueMultiplier', 0.5)
    end
end

function onMouseReleased()
    if CheckCollision('mouseCollision', 'hitbox_collectible1') then
        ClickEffect('collectible1')
        removeLuaSprite('hitbox_collectible1', false)
    else
        setProperty('collectible1.colorTransform.redMultiplier', 1)
        setProperty('collectible1.colorTransform.greenMultiplier', 1)
        setProperty('collectible1.colorTransform.blueMultiplier', 1)
    end
    if CheckCollision('mouseCollision', 'hitbox_collectible2') then
        ClickEffect('collectible2')
        removeLuaSprite('hitbox_collectible2', false)
    else
        setProperty('collectible2.colorTransform.redMultiplier', 1)
        setProperty('collectible2.colorTransform.greenMultiplier', 1)
        setProperty('collectible2.colorTransform.blueMultiplier', 1)
    end
    if CheckCollision('mouseCollision', 'hitbox_collectible3') then
        ClickEffect('collectible3')
        removeLuaSprite('hitbox_collectible3', false)
    else
        setProperty('collectible3.colorTransform.redMultiplier', 1)
        setProperty('collectible3.colorTransform.greenMultiplier', 1)
        setProperty('collectible3.colorTransform.blueMultiplier', 1)
    end
end

function onTweenCompleted(tag, vars)
    if tag == 'collectible1_disappear_scale' then
        removeLuaSprite('collectible1', true)
    elseif tag == 'collectible2_disappear_scale' then
        removeLuaSprite('collectible2', true)
    elseif tag == 'collectible3_disappear_scale' then
        removeLuaSprite('collectible3', true)
    end
end

pitch = 0

function ClickEffect(name)
    playSound('Get', 1, 'Get')
    setSoundPitch('Get', getSoundPitch('Get') + pitch)
    pitch = pitch + 0.06
    setProperty(name..'.colorTransform.redOffset', 255)
    setProperty(name..'.colorTransform.greenOffset', 255)
    setProperty(name..'.colorTransform.blueOffset', 255)
    setProperty(name..'.colorTransform.redMultiplier', 0)
    setProperty(name..'.colorTransform.greenMultiplier', 0)
    setProperty(name..'.colorTransform.blueMultiplier', 0)

    startTween(name..'_disappear_color', name..'.colorTransform', {redMultiplier = 1, greenMultiplier = 1, blueMultiplier = 1, redOffset = 0, greenOffset = 0, blueOffset = 0}, 0.25, {ease = 'linear'})
    startTween(name..'_disappear_scale', name..'.scale', {x = 0, y = 0}, 0.5, {ease = 'backIn'})
end

function CheckCollision(object1, object2)-- objectsOverlap() screw this it's too buggy
    --code from https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    if getProperty(object1..'.x') < getProperty(object2..'.x') + getProperty(object2..'.width') and 
    getProperty(object1..'.x') + getProperty(object1..'.width') > getProperty(object2..'.x') and 
    getProperty(object1..'.y') < getProperty(object2..'.y') + getProperty(object2..'.height') and 
    getProperty(object1..'.y') + getProperty(object1..'.height') > getProperty(object2..'.y') then
        return true
    else
        return false
    end
end