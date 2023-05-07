package animateatlas;

import animateatlas.JSONData;
import animateatlas.displayobject.SpriteAnimationLibrary;
import animateatlas.displayobject.SpriteMovieClip;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

using StringTools;

class AtlasFrameMaker extends FlxFramesCollection
{
	public static function construct(key:String, ?excludeFrames:Array<String>, ?noAntialiasing:Bool = false):FlxFramesCollection
	{
		if (Paths.fileExists('images/$key/spritemap1.json', TEXT))
		{
			PlayState.instance.addTextToDebug("Only Spritemaps made with Adobe Animate 2018 are supported", FlxColor.RED);

			trace("Only Spritemaps made with Adobe Animate 2018 are supported");

			return null;
		}

		var animData:AnimationData = Json.parse(Paths.getTextFromFile('images/$key/Animation.json'));
		var atlasData:AtlasData = Json.parse(Paths.getTextFromFile('images/$key/spritemap.json').replace("\uFEFF", ""));

		var sprAnimLib:SpriteAnimationLibrary = new SpriteAnimationLibrary(animData, atlasData, Paths.image('$key/spritemap').bitmap);
		var sprMovieClip:SpriteMovieClip = sprAnimLib.createAnimation(noAntialiasing);

		var frameCollection:FlxFramesCollection = new FlxFramesCollection(graphic, IMAGE);
		for (i in excludeFrames == null ? sprMovieClip.getFrameLabels() : excludeFrames)
			for (j in getFramesArray(sprMovieClip, i))
				for (k in j)
					frameCollection.pushFrame(k);

		return frameCollection;
	}

	@:noCompletion private static function getFramesArray(t:SpriteMovieClip, animation:String):Array<FlxFrame>
	{
		var daFramez:Array<FlxFrame> = [];

		var rect:Rectangle = t.getBounds(t);

		for (i in t.getFrame(animation)...t.numFrames)
		{
			var data:BitmapData = new BitmapData(Std.int(rect.width + rect.x), Std.int(rect.height + rect.y), true, 0);
			data.draw(t, true);

			var theFrame:FlxFrame = new FlxFrame(FlxGraphic.fromBitmapData(data));
			theFrame.frame = new FlxRect(0, 0, data.width, data.height);
			theFrame.name = animation + i;
			theFrame.sourceSize.set(data.width, data.height);
			daFramez.push(theFrame);

			data.dispose();
			data = null;
		}

		return daFramez;
	}
}
