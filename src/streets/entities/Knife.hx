package streets.entities;

class Knife extends Entity
{
	static inline var DISTANCE_PER_SECOND:Int = 512;
	static inline var MAX_SCREENS:Float = 2.5;

	var flipX:Bool = false;
	var moved:Float = 0;

	public function new(flipX:Bool)
	{
		super();

		this.flipX = flipX;

		var img = new Image("assets/graphics/knife.png");
		img.flipX = flipX;
		graphic = img;
		width = img.width;
		height = img.height;
		graphic = img;
	}

	override public function update()
	{
		var move = Math.min(DISTANCE_PER_SECOND * HXP.elapsed, MAX_SCREENS * HXP.width - moved);
		while (move > 0)
		{
			var d = move > 4 ? 4 : move % 4;
			moved += d;
			move -= 4;
			moveBy(d * (flipX ? -1 : 1), 0);
			var c:Character = cast collide("character", x, y);
			if (c != null && !Std.is(c, Player))
			{
				@:privateAccess c.queueHit(20);
				scene.remove(this);
				return;
			}
		}
		if (moved >= MAX_SCREENS * HXP.width) scene.remove(this);
	}
}
