package streets.entities;

class Weapon extends Entity
{
	public var weaponType:WeaponType;

	public function new(type:WeaponType)
	{
		super();

		this.weaponType = type;

		switch (type)
		{
			case Bar:
				var img = new Image("assets/graphics/bar.png");
				img.flipX = Math.random() > 0.5;
				width = img.width;
				height = img.height;
				graphic = img;
			case Knife:
				var img = new Image("assets/graphics/knife.png");
				img.flipX = Math.random() > 0.5;
				width = img.width;
				height = img.height;
				graphic = img;
			default: {}
		}

		collidable = true;
		this.type = "weapon";
	}

	public function spawn(player:Player)
	{
		do
		{
			randomizePosition();
		}
		while (Math.abs(x - player.x) < HXP.width);
		player.scene.add(this);
	}

	function randomizePosition()
	{
		x = Math.random() * 126 * 16;
		y = 7 * 16 + Math.random() * (HXP.height - 8 * 16);
	}
}
