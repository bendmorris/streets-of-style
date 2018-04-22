package streets;

@:build(staticdata.DataModel.build(["data/outfits.yaml"], "outfits"))
@:enum
abstract Outfit(String) from String to String
{
	static var randomChoices:Array<Outfit>;
	public static var random(get, never):Outfit;
	static inline function get_random()
	{
		if (randomChoices == null)
		{
			randomChoices = new Array();
			for (i in 0 ... ordered.length - 1)
			{
				var s = ordered[i];
				for (j in 0 ... Std.int(s.style / 5)) randomChoices.push(s);
			}
		}
		return randomChoices[Std.random(randomChoices.length)];
	}

	@:a public var name:String;
	@:a public var style:Int;
	@:a public var cost:Int;
	@:a public var row:Int;
}
