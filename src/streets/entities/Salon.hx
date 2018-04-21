package streets.entities;

import streets.scenes.SalonScene;

class Salon extends Room
{
	var style:Hairstyle;

	public function new(style:Hairstyle)
	{
		super();
		this.style = style;
	}

	override function enter(e:Player)
	{
		HXP.engine.pushScene(new SalonScene(e, style, inc));
	}

	function inc()
	{
		var i = Hairstyle.ordered.indexOf(style);
		if (i < Hairstyle.ordered.length - 1)
		{
			style = Hairstyle.ordered[i + 1];
		}
	}
}
