package streets.entities;

import haxepunk.math.Vector2;

@:enum
abstract EnemyState(Int) from Int to Int
{
	var Idle = 0;
	var Approach = 1;
	var WaitToAttack = 2;
	var Cheer = 3;
	var Taunt = 4;
}

class Enemy extends Character
{
	var state = Idle;
	var timer:Float = 1;
	var target:Player;
	var health:Float;
	var unfriendly:Bool = false;
	var targetPoint:Vector2 = new Vector2();

	public function new(target:Player)
	{
		super(true);
		this.target = target;
		speed = 0.25 + Math.random() * 0.5;
		health = 1 + Math.random() * level;
	}

	override public function update()
	{
		super.update();

		if (!busy)
		{
			switch (state)
			{
				case Approach:
					var moveX = (Math.abs(x - targetPoint.x) < width) ? 0 : x > targetPoint.x ? -1 : 1,
						moveY = (Math.abs(y - targetPoint.y) < 4) ? 0 : y > targetPoint.y ? -1 : 1;
					move(moveX, moveY);
					if (distance(target) < width * 2) timer = 0;
					else targetPoint.setTo(
						MathUtil.lerp(targetPoint.x, target.x, HXP.elapsed),
						MathUtil.lerp(targetPoint.y, target.y, HXP.elapsed)
					);
				case Cheer:
					flipX = target.x < x;
					play("cheer");
				default:
					play("idle");
			}

			if (timer <= 0)
			{
				state = switch (state)
				{
					case Idle, Taunt: Approach;
					case WaitToAttack:
						Math.random() < 0.65 ? punch() : kick();
						Idle;
					default: Idle;
				}
				if (!unfriendly && distance(target) < HXP.width && #if always_cheer true #else (state == Idle || state == Approach) && style < target.style #end)
				{
					state = Cheer;
				}
				switch (state)
				{
					case Idle, Approach:
						if (distance(target) < width * 2)
						{
							state = WaitToAttack;
							timer = 0.25 + Math.random() * 0.25;
						}
						else
						{
							targetPoint.setTo(target.x, target.y);
							timer = 2.5 + Math.random() * 0.5;
						}
					case Cheer:
						Sound.play("cash");
						spawnMoney(target.education.bonus + level);
						// TODO: cheer statement
						timer = 5;
					case Taunt:
						// TODO
						timer = 5;
					default:
						timer = 0.5 + Math.random() * 3;
				}
			}
		}

		if (timer > 0) timer -= HXP.elapsed;
	}

	override function hit(dmg:Float)
	{
		super.hit(dmg);
		unfriendly = true;
		if (state == Cheer) state = Approach;
		if ((health -= dmg) <= 0)
		{
			collidable = false;
			busy = true;
			Sound.play("ouch");
			play("die").onComplete.bind(die);
		}
	}

	static var DENOMINATIONS:Array<Int> = [100, 50, 20, 10, 5, 2, 1];
	function spawnMoney(n:Int)
	{
		for (val in DENOMINATIONS)
		{
			while (n >= val)
			{
				n -= val;
				var d = new Dollar(val);
				d.x = (x + width / 2 - originX) + (Math.random() - 0.5) * width * 2;
				d.y = (y + height / 2 - originY) + (Math.random() - 0.5) * width / 2;
				scene.add(d);
			}
		}
	}

	function die()
	{
		var money = 2 + Std.random(level + 1);
		spawnMoney(money);
		scene.remove(this);
	}
}
