package;

import discord_rpc.DiscordRpc;

using StringTools;

class DiscordClient
{
	public static var isInitialized:Bool = false;

	public function new():Void
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "1096671725820854345",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			Sys.sleep(2);
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown():Void
	{
		DiscordRpc.shutdown();
	}

	static function onReady():Void
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Psych Engine"
		});
	}

	static function onError(_code:Int, _message:String):Void
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String):Void
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize():Void
	{
		sys.thread.Thread.create(function()
		{
			new DiscordClient();
		});

		trace("Discord Client initialized");

		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float):Void
	{
		var startTimestamp:Float = hasStartTimestamp ? Date.now().getTime() : 0;

		if (endTimestamp > 0)
			endTimestamp = startTimestamp + endTimestamp;

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Engine Version: " + MainMenuState.psychEngineVersion,
			smallImageKey: smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(endTimestamp / 1000)
		});
	}
}
