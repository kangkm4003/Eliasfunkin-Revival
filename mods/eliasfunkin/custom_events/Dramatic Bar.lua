function onCreatePost()
    makeLuaSprite('DramaBar1', '', 0, screenHeight / 2 * -1)
    makeGraphic('DramaBar1', screenWidth, screenHeight / 2, '000000')
    setObjectCamera('DramaBar1', 'hud')
    addLuaSprite('DramaBar1', false)

    makeLuaSprite('DramaBar2', '', 0, screenHeight)
    makeGraphic('DramaBar2', screenWidth, screenHeight / 2, '000000')
    setObjectCamera('DramaBar2', 'hud')
    addLuaSprite('DramaBar2', false)
end

function onEvent(event, value1, value2)
    if event == 'Dramatic Bar' then
        doTweenY('DramaBar1', 'DramaBar1', lerp(screenHeight / 2 * -1, 0, value1), value2, 'quartOut')
        doTweenY('DramaBar2', 'DramaBar2', lerp(screenHeight, screenHeight / 2, value1), value2, 'quartOut')
    end
end

function lerp(a, b, t)
	return a + (b - a) * t
end