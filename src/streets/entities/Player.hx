package streets.entities;

class Player extends Character
{
	public var money:Int = #if cheat 10000 #else 0 #end;
	public var education:Education = Education.None;
	public var weapon:WeaponType = #if cheat Knife #else None #end;

	var ammo:Int = #if cheat 20 #else 0 #end;
	var bar:Image;

	override public function new()
	{
		super(false);
		bar = new Image("assets/graphics/bar.png");
		bar.originY = -7;
		bar.visible = false;
		var gl:Graphiclist = cast graphic;
		gl.children[2] = bar;
	}

	override public function added()
	{
		spawnRandomWeapon(Bar);
		spawnRandomWeapon(Knife);
	}

	override public function update()
	{
		super.update();

		if (sm.frame % 8 != 3) bar.visible = false;

		var collisions = @:privateAccess Character.collisions;
		collideInto("money", x, y, collisions);
		while (collisions.length > 0)
		{
			var d:Dollar = cast collisions.pop();
			d.scene.remove(d);
			money += d.value;
			Sound.play("cash");
		}

		var w:Weapon = cast collide("weapon", x, y);
		if (w != null)
		{
			if (weapon != None)
			{
				spawnRandomWeapon(weapon);
			}
			w.scene.remove(w);
			weapon = w.weaponType;
			ammo = 10;
			Sound.play("upgrade");
		}
	}

	override function handleAction(action:ActionType)
	{
		switch (action)
		{
			case Punch:
				switch (weapon)
				{
					case Bar:
						// swing bar
						busy = true;
						attack(5);
						play("punch", true);
						bar.visible = true;
						bar.flipX = sm.flipX;
						bar.x = bar.flipX ? 2 : 25;
						if (--ammo <= 0)
						{
							weapon = None;
							Sound.play("nope");
							spawnRandomWeapon(Bar);
						}

					case Knife:
						// throw knife
						busy = true;
						attack(1);
						play("punch", true);
						var knife = new Knife(sm.flipX);
						knife.x = x + (sm.flipX ? 2 : 25);
						knife.y = y + 16;
						scene.add(knife);

						if (--ammo <= 0)
						{
							weapon = None;
							Sound.play("nope");
							spawnRandomWeapon(Knife);
						}

					default:
						super.handleAction(action);
				}
			default:
				super.handleAction(action);
		}
	}

	override function hit(dmg:Float)
	{
		super.hit(dmg);
		Sound.play("ouch");
		money -= Std.int(Math.ceil(dmg));
		if (money < 0) money = 0;
	}

	function spawnRandomWeapon(type:WeaponType)
	{
		var weapon = new Weapon(type);
		weapon.spawn(this);
	}
}
