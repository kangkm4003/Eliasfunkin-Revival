function onCreate()
    makeLuaSprite('mouseCollision', '')
    makeGraphic('mouseCollision', 1, 1, 'FFFFFF')
    callMethod('mouseCollision.set_camera', {instanceArg('camHUD')})
    setProperty('mouseCollision.alpha', 0)
    addLuaSprite('mouseCollision', false)
end

function onUpdate(elapsed)
    setProperty('mouseCollision.x', getMouseX('hud'))
    setProperty('mouseCollision.y', getMouseY('hud'))
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