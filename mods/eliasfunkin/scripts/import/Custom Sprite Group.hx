import psychlua.LuaUtils;
import flixel.group.FlxTypedSpriteGroup;

function makeGroup(tag:String, x:Float = 0, y:Float = 0)
{
	var group = new FlxTypedSpriteGroup(x, y);
	group.cameras = [camHUD];
	add(group);

	PlayState.instance.variables.set(tag, group); //Thank you suli
}

function addGroup(group:String, tag:String, ?index:Int = -1)
{
	var targetGroup:FlxTypedSpriteGroup = PlayState.instance.variables.get(group);

	if(index < 0)
		{
			targetGroup.add(LuaUtils.getObjectDirectly(tag));
		}
		else targetGroup.insert(index, LuaUtils.getObjectDirectly(tag));
}