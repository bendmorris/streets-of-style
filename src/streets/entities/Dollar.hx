package streets.entities;

class Dollar extends Entity
{
	public function new()
	{
		super();

		var img = new Image("assets/graphics/dollar.png");
		width = img.width;
		height = img.height;
		graphic = img;
		layer = -2;
		collidable = true;
		type = "money";
	}
}
