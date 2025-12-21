local ModulePath = io.popen("cd"):read("*l")..
    '\\mods\\trickcal\\scripts\\module\\?.lua'

package.path = ModulePath


function onCreate()
    addHaxeLibrary('FlxTypeText', 'flixel.addons.text')
    addHaxeLibrary('FlxTextBorderStyle', 'flixel.text.FlxText')
    addHaxeLibrary('LuaUtils', 'backend')
    addHaxeLibrary('FlxTextFormat', 'flixel.text')
    addHaxeLibrary('FlxTextFormatMarkerPair', 'flixel.text')

    runHaxeCode([[
        createCallback('startTypeText', function(tag:String)
            {
                var target = PlayState.instance.variables.get(tag);

                target.start();
            });
    ]])

    createInstance('test2', 'flixel.addons.text.FlxTypeText', {300, 300, 0, '<r>red<r> test', 36})
    addInstance('test2', true)
    require('textMaker').applyMarkup('test2', '<r>', '<r>red<r> test', {fontColor = FlxColor('#FF0000')})
    startTypeText('test2')
end

