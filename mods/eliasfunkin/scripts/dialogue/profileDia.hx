import flixel.group.FlxTypedSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.addons.text.FlxTypeText;
import backend.CoolUtil;

//user setting reference

var antialiasing = ClientPrefs.data.antialiasing;

//

var profileDiaGroup = new FlxTypedSpriteGroup(0, 0);
profileDiaGroup.cameras = [camOther];

var nameTagGroup = new FlxTypedSpriteGroup(0, 0);

var nameTagTail = new FlxSprite(0, 0, Paths.image('dialogue/bubble/namebubble-tail'));
nameTagTail.origin.x = 0;
nameTagTail.scale.set(0.1, 0.09);
nameTagGroup.add(nameTagTail);

var nameTagBody = new FlxSprite(0, 0, Paths.image('dialogue/bubble/namebubble-body'));
nameTagBody.origin.x = 0;
nameTagBody.scale.set(0.1, 0.09);
nameTagGroup.add(nameTagBody);

var nameTagText = new FlxText(20, 243, 0);
nameTagText.font = Paths.font('vcr.ttf');
nameTagText.color = 0xFFFFFFFF;
nameTagText.borderSize = 0;
nameTagText.borderColor = FlxColor.WHITE;
CoolUtil.setTextBorderFromString(nameTagText, 'none');
nameTagText.visible = false;
nameTagText.antialiasing = antialiasing;
nameTagGroup.add(nameTagText);
profileDiaGroup.add(nameTagGroup);

var diaText = new FlxTypeText(285, 610, 0, '', 30);
diaText.font = Paths.font('vcr.ttf');
diaText.color = 0xFFFFFFFF;
diaText.borderSize = 0;
diaText.borderColor = FlxColor.WHITE;
CoolUtil.setTextBorderFromString(diaText, 'none');
diaText.antialiasing = antialiasing;
diaText.visible = false;
profileDiaGroup.add(diaText);
diaText.completeCallback = 
function() { onTextDone(); };

switch(ClientPrefs.data.textSize) 
{
    case "Very Large":
    {
        diaText.size = 35;
    }
    case "Large":
    {
        diaText.size = 32;
    }
    case "Middle":
    {
        diaText.size = 30;
    }
    case "Small":
    {
        diaText.size = 27;
    }
}

var arrow = new FlxSprite(983, 667, Paths.image('dialogue/bubble/next-white'));
arrow.color = 0xFFFFFFFF;
arrow.scale.set(0.05, 0.05);
arrow.updateHitbox();
arrow.visible = false;
profileDiaGroup.add(arrow);
FlxTween.tween(arrow, {y: 677}, 0.5, {type: 4});
add(profileDiaGroup);

function onPrintDialogue(info:Array<Dynamic>, ?prev:Array<Dynamic>)
{
    arrow.visible = false;
    if (info.type.toLowerCase() == 'profiledia') // check it's my type
    {
        if (info.openAnim != null) //invaild check
        {
            if (info.openAnim >= 0 && info.openAnim <= 1)
                doOpenAnim(info.openAnim);
            else
                doOpenAnim(0);
            
            
        }
        
    }
    else return;
}

function doOpenAnim(type:Int)
{

}

function onTextDone()
{
    diaText.skip();
    arrow.visible = true;
    for (luaInstance in PlayState.instance.luaArray)
    {
        if(luaInstance.scriptName == Paths.getPath('scripts/DialogueSystem.lua'))
			luaInstance.call('onSkip', []);
    }
}