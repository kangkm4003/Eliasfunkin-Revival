import flixel.group.FlxTypedSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxArrayUtil;

var antialiasing = ClientPrefs.data.antialiasing;
var effectBoxes:Array<FlxTypedSpriteGroup> = [];

function makeEffectBox(x:Float, y:Float, width:Float, height:Float, angle:Float, text:String, lifeSpan:Int)
{
    var effectBoxGroup = new FlxTypedSpriteGroup(x, y);
    effectBoxGroup.cameras = [camOther];
    
    var effectBox = new FlxSprite(0, 0);
    effectBox.makeGraphic(width, height, FlxColor.TRANSPARENT);

    var lineStyle:LineStyle = {
    	color: FlxColor.BLACK,
    	thickness: 10,
		capsStyle: 3
	};

    FlxSpriteUtil.drawRect(
        effectBox,
        0, 0,
        width, height,
        FlxColor.WHITE,
        lineStyle
    );
    effectBoxGroup.add(effectBox);

    var effectBox_diaText = new FlxTypeText(0, 60, width, text, 25);
    effectBox_diaText.cameras = [camOther];
    effectBox_diaText.font = Paths.font('vcr.ttf');
    effectBox_diaText.alignment = "center";
    effectBox_diaText.color = 0xFF90A95F;
    effectBox_diaText.antialiasing = antialiasing;  
    effectBox_diaText.completeCallback =
    function() 
    {
        effectBox_diaText.skip();
        for (luaInstance in PlayState.instance.luaArray)
        {
            if(luaInstance.scriptName == Paths.getPath('scripts/DialogueHandler.lua'))
	    		luaInstance.call('onSkip', []);
        }
        PlayState.instance.setOnScripts('dontGoNextDia', false);
    };
    effectBoxGroup.add(effectBox_diaText);
    
    effectBoxGroup.angle = angle;
    effectBoxGroup.alpha = 0;
    add(effectBoxGroup);
    FlxTween.tween(effectBoxGroup, {x: x + 50, y: y - 50, alpha: 1}, 0.5, {ease: FlxEase.linear,
    onComplete: function()
    {
        effectBox_diaText.start(0.02, true);
    }});


    var table:Map<String, Dynamic> = [
        "box" => effectBoxGroup,
        "life" => lifeSpan
    ];

    effectBoxes.push(table);
    effectBoxes.sort(function(a, b) return b - a);
}


function onPrintDialogue(info:Array<Dynamic>, ?prev:Array<Dynamic>)
{
    if (effectBoxes.length != 0)
    {
        var i = effectBoxes.length - 1;
        while (i >= 0) 
        {
            if (effectBoxes[i].get("life") <= 0)
            {
                FlxTween.tween(effectBoxes[i].get("box").scale, {x: 0, y: 0}, 0.2, {ease: FlxEase.backIn,
                onComplete: function()
                {
                    effectBoxes[effectBoxes.length-1].get("box").destroy();
                    effectBoxes.pop();
                }});
            }
            else 
            {
                effectBoxes[i].set("life", effectBoxes[i].get("life") - 1);
            }
            i -= 1;
        }
    }
    if (info.type == 'effectBox')
    {
        PlayState.instance.setOnScripts('dontGoNextDia', true);
        makeEffectBox(info.x, info.y, info.width, info.height, info.angle, info.text, info.lifeSpan);
    }
}
