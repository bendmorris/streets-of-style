package streets;

@:build(staticdata.DataModel.build(["data/hairstyles.yaml"], "hairstyles"))
@:enum
abstract Hairstyle(String) from String to String
{
	public static var random(get, never):Hairstyle;
	static inline function get_random()
	{
		return ordered[Std.random(ordered.length - 1)];
	}

	@:a public var name:String;
	@:a public var style:Int;
	@:a public var cost:Int;
	@:a public var row:Int;
}
