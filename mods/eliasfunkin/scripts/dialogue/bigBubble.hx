import flixel.group.FlxTypedSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.addons.text.FlxTypeText;
import backend.CoolUtil;

var bubbleTypes = ['normal','think','loud', 'normal-purple', 'think-purple', 'loud-purple'];
var antialiasing = ClientPrefs.data.antialiasing;

var bigbubbleGroup = new FlxTypedSpriteGroup(0, 0);
bigbubbleGroup.cameras = [camOther];

var bubbleGroup = new FlxTypedSpriteGroup(0, 0);
for (i in 0...bubbleTypes.length)
{
    //112, 493
    var bubble = new FlxSprite(112, 493, Paths.image('dialogue/bubble/scriptbox-theme-' + i));
    bubble.scale.set(0.3, 0.3);
    bubble.origin.y = 670;
    bubble.updateHitbox();
    bubble.visible = false;
    bubble.antialiasing = antialiasing;
    bubbleGroup.add(bubble);
}
bubbleGroup.scale.set(0.3, 0.3);
bigbubbleGroup.add(bubbleGroup);

var nameTagGroup = new FlxTypedSpriteGroup(515, 525);

var bubble_nameTag = new FlxSprite(0, 0);
bubble_nameTag.makeGraphic(250, 30, FlxColor.TRANSPARENT);
FlxSpriteUtil.drawRoundRectComplex(bubble_nameTag, 
    0, 0, 
    250, 30, 
    20, 20, 
    10, 10, 
    0xFFFFFFFF
);
bubble_nameTag.origin.y = 670;
bubble_nameTag.visible = false;
nameTagGroup.add(bubble_nameTag);

var bubble_nameText = new FlxText(0, -15, 0);
bubble_nameText.font = Paths.font('vcr.ttf');
bubble_nameText.color = 0xFF343334;
bubble_nameText.borderSize = 3;
bubble_nameText.borderColor = FlxColor.WHITE;
CoolUtil.setTextBorderFromString(bubble_nameText, 'outline');
bubble_nameText.visible = false;
bubble_nameText.antialiasing = antialiasing;
nameTagGroup.add(bubble_nameText);

bigbubbleGroup.add(nameTagGroup);

var bubble_diaText = new FlxTypeText(285, 510, 700, '', 30);
bubble_diaText.font = Paths.font('vcr.ttf');
bubble_diaText.color = 0xFF343334;
bubble_diaText.borderSize = 3;
bubble_diaText.borderColor = FlxColor.WHITE;
CoolUtil.setTextBorderFromString(bubble_diaText, 'outline');
bubble_diaText.alignment = "center";
bubble_diaText.antialiasing = antialiasing;
bubble_diaText.visible = false;
bigbubbleGroup.add(bubble_diaText);
bubble_diaText.completeCallback = 
function() 
{
    onTextDone();
};

switch(ClientPrefs.data.textSize) 
{
    case "Very Large":
    {
        bubble_nameText.size = 35;
        bubble_diaText.size = 35;
    }
    case "Large":
    {
        bubble_nameText.size = 35;
        bubble_diaText.size = 32;
    }
    case "Middle":
    {
        bubble_nameText.size = 33;
        bubble_diaText.size = 30;
    }
    case "Small":
    {
        bubble_nameText.size = 30;
        bubble_diaText.size = 27;
    }
}

var bubble_arrow = new FlxSprite(983, 667, Paths.image('dialogue/bubble/next-white'));
bubble_arrow.color = 0xFF95C033;
bubble_arrow.scale.set(0.05, 0.05);
bubble_arrow.updateHitbox();
bubble_arrow.visible = false;
bigbubbleGroup.add(bubble_arrow);
FlxTween.tween(bubble_arrow, {y: 677}, 0.5, {type: 4}); //pingpong
add(bigbubbleGroup);


function onPrintDialogue(info:Array<Dynamic>, ?prev:Array<Dynamic>)
{
    bubble_arrow.visible = false;
    for (i in 0...bubbleTypes.length)
    {
        if (bubbleTypes[i] == info.type)
        {
            FlxTween.cancelTweensOf(bubbleGroup.scale);
            for (i in 0...bubbleTypes.length)
            {
                bubbleGroup.scale.set(0.3, 0.3);
                if (bubbleTypes[i] != info.type)
                    bubbleGroup.members[i].visible = false;
                else if (bubbleTypes[i] == info.type)
                    bubbleGroup.members[i].visible = true;
            }

            bubble_nameText.visible = true;
            bubble_nameTag.visible = true;
            bubble_diaText.visible = true;

            bubble_nameText.text = info.name;

            FlxTween.cancelTweensOf(nameTagGroup);
            FlxTween.cancelTweensOf(bubble_diaText.scale);
            nameTagGroup.scale.y = 1;
            nameTagGroup.y = 525;
            bubble_diaText.scale.set(1, 1);
            bubble_diaText.y = 610;

            if (StringTools.endsWith(info.type, 'purple'))
            {
                bubble_arrow.color = 0xFFA763B2;
                bubble_diaText.color = 0xFFA762B2;
                bubble_diaText.borderColor = FlxColor.BLACK;
            }
            else
            {
                bubble_arrow.color = 0xFF95C033;
                bubble_diaText.color = 0xFF343334;
                bubble_diaText.borderColor = FlxColor.WHITE;
            }
            
            //nameTag scale
            if (bubble_nameText.fieldWidth + 70 > 250)
            {
                bubble_nameTag.makeGraphic(bubble_nameText.fieldWidth + 70, 30, FlxColor.TRANSPARENT);
                FlxSpriteUtil.drawRoundRectComplex(bubble_nameTag, 
                    0, 0, 
                    bubble_nameText.fieldWidth + 70, 30, 
                    20, 20, 
                    10, 10, 
                    0xFFFFFFFF
                );
            }
            else
            {
                bubble_nameTag.makeGraphic(250, 30, FlxColor.TRANSPARENT);
                FlxSpriteUtil.drawRoundRectComplex(bubble_nameTag, 
                    0, 0, 
                    250, 30, 
                    20, 20, 
                    10, 10, 
                    0xFFFFFFFF
                );
            }

            //nameTag position
            if (info.namePos == 'left')
            {
                bubble_nameTag.x = 250;
                if (bubble_nameText.fieldWidth + 70 > 250)
                    bubble_nameText.x = bubble_nameTag.x + 35;
                else
                {
                    bubble_nameText.x = (bubble_nameTag.width - bubble_nameText.fieldWidth) / 2 + bubble_nameTag.x;
                }
            }
            else if (info.namePos == 'right')
            {
                if (bubble_nameText.fieldWidth + 70 > 250)
                {
                    bubble_nameTag.x = 1025 - bubble_nameTag.width;
                    bubble_nameText.x = bubble_nameTag.x + 35;
                }
                else
                {
                    bubble_nameTag.x = 775;
                    bubble_nameText.x = (bubble_nameTag.width - bubble_nameText.fieldWidth) / 2 + bubble_nameTag.x;
                }
            }
            else
            {
                bubble_nameTag.screenCenter(0x01);
                bubble_nameText.screenCenter(0x01);
            }

            bubble_nameTag.color = CoolUtil.colorFromString('0xFF' + info.nameTagColor);
            bubble_diaText.resetText(info.text);
            bubble_diaText.start(0.02, true);

            if (info.openAnim == true)
            {
                doOpenAnim();
            }
            return 0;
        }
    }
    if (prev != null)
    {
        for (i in 0...bubbleTypes.length)
        {
            if (bubbleTypes[i] == prev.type)
            {
                doCloseAnim(false);
                return 0;
            }
        }
    }
}

function doOpenAnim()
{
    nameTagGroup.scale.x = 0.65;
    FlxTween.tween(nameTagGroup.scale, {x: 1}, 0.2, {ease: FlxEase.backOut});
    bubbleGroup.scale.x = 0.2;
    FlxTween.tween(bubbleGroup.scale, {x: 0.3}, 0.2, {ease: FlxEase.backOut});
}

function doCloseAnim(destroy:Bool)
{
    bubble_arrow.visible = false;
    FlxTween.tween(bubbleGroup.scale, {x: 0, y: 0}, 0.2, {ease: FlxEase.backIn});
    FlxTween.tween(bubble_diaText.scale, {x: 0, y: 0}, 0.2, {ease: FlxEase.backIn});
    FlxTween.tween(bubble_diaText, {y: 670}, 0.2, {ease: FlxEase.backIn});

    FlxTween.tween(nameTagGroup, {y: 670}, 0.2, {ease: FlxEase.backIn});
    if (destroy)
        FlxTween.tween(nameTagGroup.scale, {x: 0, y: 0}, 0.2, { ease: FlxEase.backIn, onComplete: onDestroy});
    else
        FlxTween.tween(nameTagGroup.scale, {x: 0, y: 0}, 0.2, { ease: FlxEase.backIn});
}

function onUpdate(elapsed:Float)
{
    if (bubble_diaText.exists && !textDone)
    {
        bubble_diaText.y = ((bubbleGroup.height / 2) + (bubble_diaText.height / 2 * -1) + 510);
    }
}

function onTextDone()
{
    bubble_diaText.skip();
    bubble_arrow.visible = true;
    for (luaInstance in PlayState.instance.luaArray)
    {
        if(luaInstance.scriptName == Paths.getPath('scripts/DialogueSystem.lua'))
			luaInstance.call('onSkip', []);
    }
}

function onEndDialogue(?type:String)
{
    doCloseAnim(true);
}

function onDestroy()
{
    bigbubbleGroup.destroy();
    return Function_Stop;
}