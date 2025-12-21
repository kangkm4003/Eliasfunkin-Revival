function onCreatePost()
    initLuaShader('shadow')
    initLuaShader('lensFlare')

    makeLuaSprite('lensFlare')
    makeGraphic('lensFlare', screenWidth, screenHeight)
    setSpriteShader('lensFlare', 'lensFlare')
    setShaderFloatArray('lensFlare', 'benchmark', {0.5, 0.5})
    setShaderFloatArray('lensFlare', 'flareColor', {0.5, 0.5})

    setSpriteShader('boyfriend', 'shadow')

    setShaderFloat('boyfriend', 'ang', 90)
    setShaderFloat('boyfriend', 'str', 1)
    setShaderFloat('boyfriend', 'dist', 15)
    setShaderFloat('boyfriend', 'thr', 0.1)

    setShaderFloat('boyfriend', 'brightness', -30)
    setShaderFloat('boyfriend', 'hue', -10)
    setShaderFloat('boyfriend', 'contrast', -12.5)
    setShaderFloat('boyfriend', 'saturation', -10)
    setShaderFloat('boyfriend', 'AA_STAGES', 2)

    setShaderFloatArray('boyfriend', 'dropColor', {87 / 255, 191 / 255, 244 / 255})
    setShaderFloatArray('boyfriend', 'uFrameBounds', {0, 0, getProperty('boyfriend.width'), getProperty('boyfriend.height')})

    setSpriteShader('dad', 'shadow')

    setShaderFloat('dad', 'ang', 90)
    setShaderFloat('dad', 'str', 1)
    setShaderFloat('dad', 'dist', 15)
    setShaderFloat('dad', 'thr', 0.4)

    setShaderFloat('dad', 'brightness', -40)
    setShaderFloat('dad', 'hue', -10)
    setShaderFloat('dad', 'contrast', -12.5)
    setShaderFloat('dad', 'saturation', -10)
    setShaderFloat('dad', 'AA_STAGES', 2)

    setShaderFloatArray('dad', 'dropColor', {91 / 255, 119 / 255, 255 / 255})
    setShaderFloatArray('dad', 'uFrameBounds', {0, 0, getProperty('dad.width'), getProperty('dad.height')})

    if shadersEnabled then
        initLuaShader('bloom')
        makeLuaSprite('bloom')
        makeGraphic('bloom', screenWidth, screenHeight)
        setSpriteShader('bloom', 'bloom')
        setShaderFloat('bloom', 'dim', 2)
        setShaderFloat('bloom', 'Directions', 10.0)
        setShaderFloat('bloom', 'Quality', 1.5)
        setShaderFloat('bloom', 'Size', 3)
        runHaxeCode([[
            FlxG.camera.setFilters([new ShaderFilter(PlayState.instance.variables.get("bloom").shader)]);
        ]])
    end
end