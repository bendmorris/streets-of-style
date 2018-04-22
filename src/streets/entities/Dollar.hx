package streets.entities;

class Dollar extends Entity
{
	static inline var DURATION:Float = 15;
	static inline var FLASH_TIME:Float = 0.05;

	public var value:Int = 1;
	var duration:Float = 1;
	var flashTime:Float = 1;

	public function new(value:Int)
	{
		super();

		this.value = value;

		var img = new Image("assets/graphics/dollar.png");
		width = img.width;
		height = img.height;
		graphic = img;
		layer = -2;
		collidable = true;
		type = "money";
	}

	override public function update()
	{
		super.update();

		duration -= HXP.elapsed / DURATION;
		if (duration <= 0)
		{
			scene.remove(this);
		}
		else if (duration <= 0.2)
		{
			flashTime -= HXP.elapsed / FLASH_TIME;
			if (flashTime <= 0)
			{
				++flashTime;
				visible = !visible;
			}
		}
	}
}
