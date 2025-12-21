function onCreate()
    initLuaShader('lensFlare')
    makeLuaSprite('lensFlare')
    makeGraphic('lensFlare', screenWidth, screenHeight)
    setSpriteShader('lensFlare', 'lensFlare')
    setShaderFloatArray('lensFlare', 'benchmark', {0.5, 0.5})
    setShaderFloatArray('lensFlare', 'flareColor', {0.5, 0.5})
    runHaxeCode([[
        FlxG.camera.setFilters([new ShaderFilter(PlayState.instance.variables.get("lensFlare").shader)]);
    ]])
end