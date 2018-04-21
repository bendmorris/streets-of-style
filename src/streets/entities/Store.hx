package streets.entities;

import streets.scenes.StoreScene;

class Store extends Room
{
	var style:Outfit;

	public function new(style:Outfit)
	{
		super();
		this.style = style;
	}

	override function enter(e:Player)
	{
		HXP.engine.pushScene(new StoreScene(e, style, inc));
	}

	function inc()
	{
		var i = Outfit.ordered.indexOf(style);
		if (i < Outfit.ordered.length - 1)
		{
			style = Outfit.ordered[i + 1];
		}
	}
}
