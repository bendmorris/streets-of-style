package streets;

@:build(staticdata.DataModel.build(["data/hairstyles.yaml"], "hairstyles"))
@:enum
abstract Hairstyle(String) from String to String
{
	static var randomChoices:Array<Hairstyle>;
	public static var random(get, never):Hairstyle;
	static inline function get_random()
	{
		if (randomChoices == null)
		{
			randomChoices = new Array();
			for (s in ordered) for (i in 0 ... Std.int(s.style / 5)) randomChoices.push(s);
		}
		return randomChoices[Std.random(randomChoices.length)];
	}

	@:a public var name:String;
	@:a public var style:Int;
	@:a public var cost:Int;
	@:a public var row:Int;
}
