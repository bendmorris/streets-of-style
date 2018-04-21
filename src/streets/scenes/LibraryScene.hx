package streets.scenes;

class LibraryScene extends Scene
{
	static inline var CHARS_PER_SECOND:Int = 64;

	var player:Player;
	var label:Label;
	var displayCharCount:Float = 0;

	public function new(player:Player)
	{
		super();
		this.player = player;
		bgAlpha = 0;
	}

	override public function begin()
	{
		var msgBox = new MessageBox(HXP.width - 16 * 4, HXP.height - 16 * 2);
		var txt = '<center><green>Library</green>\n\n';
		var maxEdu = Std.int(player.style / 50);
		if (player.education < maxEdu)
		{
			++player.education;
			txt += 'You read a book and feel a little wiser.\n\nAdoring fans think even more highly of you now (current education: [<green>${player.education}</green>])!';
		}
		else
		{
			txt += "You don't feel like reading now.\n\n<flash>Press ENTER</flash>";
		}
		msgBox.addText(txt);
		label = msgBox.label;
		label.displayCharCount = 0;
		msgBox.x = (HXP.width - msgBox.width) / 2;
		msgBox.y = (HXP.height - msgBox.height) / 2;
		addGraphic(msgBox);

		onInputPressed.start.bind(close);
		onInputPressed.quit.bind(close);
	}

	override public function update()
	{
		super.update();

		displayCharCount += HXP.elapsed * CHARS_PER_SECOND;
		label.displayCharCount = Std.int(displayCharCount);
	}

	function close()
	{
		HXP.engine.popScene();
	}
}
