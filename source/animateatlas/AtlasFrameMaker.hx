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
	private var frameCollection:FlxFramesCollection;
	private var frameArray:Array<Array<FlxFrame>> = [];

	public static function construct(key:String, ?excludeFrames:Array<String>, ?noAntialiasing:Bool = false):FlxFramesCollection
	{
		if (Paths.fileExists('images/$key/spritemap1.json', TEXT))
		{
			PlayState.instance.addTextToDebug("Only Spritemaps made with Adobe Animate 2018 are supported", FlxColor.RED);

			trace("Only Spritemaps made with Adobe Animate 2018 are supported");

			return null;
		}

		var animationData:AnimationData = Json.parse(Paths.getTextFromFile('images/$key/Animation.json'));
		var atlasData:AtlasData = Json.parse(Paths.getTextFromFile('images/$key/spritemap.json').replace("\uFEFF", ""));

		var s:SpriteAnimationLibrary = new SpriteAnimationLibrary(animationData, atlasData, Paths.image('$key/spritemap').bitmap);
		var t:SpriteMovieClip = s.createAnimation(noAntialiasing);

		frameCollection = new FlxFramesCollection(graphic, IMAGE);

		for (i in excludeFrames == null ? t.getFrameLabels() : excludeFrames)
			frameArray.push(getFramesArray(t, i));

		for (i in frameArray)
			for (j in i)
				frameCollection.pushFrame(j);

		return frameCollection;
	}

	@:noCompletion private static function getFramesArray(t:SpriteMovieClip, animation:String):Array<FlxFrame>
	{
		var daFramez:Array<FlxFrame> = [];
		var rect:Rectangle = new Rectangle(0, 0);

		t.currentLabel = animation;

		for (i in t.getFrame(animation)...t.numFrames)
		{
			t.currentFrame = i;

			if (t.currentLabel == animation)
			{
				rect = t.getBounds(t);

				var bitmapShit:BitmapData = new BitmapData(Std.int(rect.width + rect.x), Std.int(rect.height + rect.y), true, 0);
				bitmapShit.draw(t, true);

				var theFrame:FlxFrame = new FlxFrame(FlxGraphic.fromBitmapData(bitmapShit));
				theFrame.name = t.currentLabel + t.currentFrame;
				theFrame.sourceSize.set(bitmapShit.width, bitmapShit.height);
				theFrame.frame = new FlxRect(0, 0, bitmapShit.width, bitmapShit.height);
				daFramez.push(theFrame);
			}
			else
				break;
		}

		return daFramez;
	}
}
