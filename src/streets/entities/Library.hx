package streets.entities;

import streets.scenes.LibraryScene;

class Library extends Room
{
	public function new()
	{
		super();
	}

	override function enter(e:Player)
	{
		HXP.engine.pushScene(new LibraryScene(e));
	}
}
