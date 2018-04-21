package streets.graphics;

class MessageBox extends Graphiclist
{
	public var label:Label;

	public var width:Int;
	public var height:Int;

	public function new(width:Int, height:Int)
	{
		super();

		width = Std.int(Math.ceil(width / 8) * 8);
		height = Std.int(Math.ceil(height / 8) * 8);

		var nineslice = new NineSlice("assets/graphics/msgbox.png", 8, 8, 8, 8);
		nineslice.width = this.width = width;
		nineslice.height = this.height = height;
		add(nineslice);
		scrollX = scrollY = 0;

		active = true;
	}

	public function addText(text:String)
	{
		label = new Label(text, Color.White, this.width - 12);
		label.x = 6;
		label.y = (height - label.textHeight) / 2 + 1;
		add(label);
	}

	override public function update()
	{
		super.update();
		if (label != null) label.update();
	}
}
