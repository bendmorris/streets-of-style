package streets.entities;

class Player extends Character
{
	public var money:Int = #if cheat 10000 #else 0 #end;
	public var education:Education = Education.None;

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
			Sound.play("cash");
		}
	}

	override function hit(dmg:Float)
	{
		super.hit(dmg);
		Sound.play("ouch");
		money -= Std.int(Math.ceil(dmg));
		if (money < 0) money = 0;
	}
}
