package streets;

@:enum
abstract Direction(Int) from Int to Int
{
	var Up = 0;
	var Down = 1;
	var Left = 2;
	var Right = 3;

	public var x(get, never):Int;
	inline function get_x() return switch (this) { case Left: -1; case Right: 1; default: 0; }

	public var y(get, never):Int;
	inline function get_y() return switch (this) { case Up: -1; case Down: 1; default: 0; }
}
