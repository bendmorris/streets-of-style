package streets;

@:build(staticdata.DataModel.build(["data/education.yaml"], "education"))
@:enum
abstract Education(Int) from Int to Int
{
	@:a public var name:String;
	@:a public var description:String;
	@:a public var cost:Int;
	@:a public var bonus:Int;
}
