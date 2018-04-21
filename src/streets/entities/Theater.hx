package streets.entities;

import streets.scenes.TheaterScene;

class Theater extends Room
{
	public function new()
	{
		super();
	}

	override function enter(e:Player)
	{
		HXP.engine.pushScene(new TheaterScene(e));
	}
}
