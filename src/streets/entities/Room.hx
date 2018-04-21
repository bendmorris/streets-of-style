package streets.entities;

import streets.scenes.StoreScene;

class Room extends Entity
{
	var lastContact:Bool = false;

	public function new()
	{
		super();
		width = height = 16;
		collidable = true;
		type = "store";
	}

	override public function update()
	{
		var currentContact:Player = null;
		var collisions = @:privateAccess Character.collisions;
		collideInto("character", x, y, collisions);
		while (collisions.length > 0)
		{
			var c = collisions.pop();
			if (Std.is(c, Player))
			{
				currentContact = cast c;
			}
		}

		if (currentContact != null && !lastContact)
		{
			enter(currentContact);
		}

		lastContact = currentContact != null;
	}

	function enter(e:Player) {}
}
