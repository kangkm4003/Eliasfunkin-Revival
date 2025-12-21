import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;
import psychlua.LuaUtils;

function makeRoundRectComplex(tag:String, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float, color:Int)
{
	var graphic:FlxSprite = LuaUtils.getObjectDirectly(tag);
	graphic.makeGraphic(width, height, FlxColor.TRANSPARENT);
	FlxSpriteUtil.drawRoundRectComplex(graphic, 0, 0, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius, color);
}

function makeGradientGraphic(tag:String, width:Int, height:Int, colors:Array<Int>, chunkSize:UInt = 1, rotation:Int = 90, interpolate:Bool = true)
{
	var graphic:FlxSprite = LuaUtils.getObjectDirectly(tag);
	graphic.makeGraphic(width, height, FlxColor.TRANSPARENT);
	FlxGradient.overlayGradientOnFlxSprite(graphic, width, height, [colors[0], colors[1]], 0, 0, chunkSize, rotation, interpolate);
}

function makeCircle(tag:String, radius:Float, fillColor:Int)
{
	var graphic:FlxSprite = LuaUtils.getObjectDirectly(tag);
	graphic.makeGraphic(radius * 2, radius * 2, FlxColor.TRANSPARENT);
	FlxSpriteUtil.drawCircle(graphic, radius, radius, radius, fillColor);
}

function makeEllipse(tag:String, width:Float, height:Float, fillColor:Int)
	{
		var graphic:FlxSprite = LuaUtils.getObjectDirectly(tag);
		graphic.makeGraphic(width, height, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawEllipse(graphic, 0, 0, width, height, fillColor);
	}

function makeLine(tag:String, endX:Float, endY:Float, LineThickless:Int, lineColor:Int)
{
	var graphic:FlxSprite = LuaUtils.getObjectDirectly(tag);
	graphic.makeGraphic(endX, endY, FlxColor.TRANSPARENT);
	FlxSpriteUtil.drawLine(graphic, 0, 0, endX, endY, {thickness: LineThickless, color: lineColor});
}