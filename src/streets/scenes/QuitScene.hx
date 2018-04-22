package streets.scenes;

class QuitScene extends Scene
{
	static inline var CHARS_PER_SECOND:Int = 64;

	var label:Label;
	var txt:String;
	var displayCharCount:Float = 0;

	public function new()
	{
		super();
		bgAlpha = 0;
	}

	override public function begin()
	{
		var msgBox = new MessageBox(HXP.width - 16 * 5, HXP.height - 16 * 8);
		msgBox.addText('<center><red>QUIT</red>\n\nAre you <sine>sure</sine> you want to <rainbow>quit</rainbow>?\n\nENTER to <red>quit</red>\nESCAPE to <green>cancel</green></center>');
		label = msgBox.label;
		label.displayCharCount = 0;
		msgBox.x = (HXP.width - msgBox.width) / 2;
		msgBox.y = (HXP.height - msgBox.height) / 2;
		addGraphic(msgBox);

		onInputPressed.start.bind(quit);
		onInputPressed.quit.bind(close);
	}

	override public function update()
	{
		super.update();

		displayCharCount += HXP.elapsed * CHARS_PER_SECOND;
		label.displayCharCount = Std.int(displayCharCount);
	}

	function quit()
	{
		HXP.engine.popScene();
		HXP.scene = new TitleScene();
	}

	function close()
	{
		HXP.engine.popScene();
	}
}
