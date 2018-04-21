package streets.graphics;

class Label extends BitmapText
{
	public function new(txt:String, color:Color=Color.White, width:Int = 0)
	{
		super(txt, 0, 0, width, 0, {font: "assets/fonts/8bit.6.fnt", size: 6, wordWrap: width > 0});
		this.color = color;
	}
}
