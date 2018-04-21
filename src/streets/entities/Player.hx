package streets.entities;

class Player extends Character
{
	public var money:Int = 0;
	public var education:Int = 0;

	override public function update()
	{
		super.update();

		var collisions = @:privateAccess Character.collisions;
		collideInto("money", x, y, collisions);
		while (collisions.length > 0)
		{
			var d = collisions.pop();
			d.scene.remove(d);
			++money;
		}
	}

	override function hit(dmg:Float)
	{
		super.hit(dmg);
		money -= Std.int(Math.ceil(dmg));
		if (money < 0) money = 0;
	}
}
