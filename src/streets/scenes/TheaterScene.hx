package streets.scenes;

class TheaterScene extends Scene
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
		var txt = '<center><green>Theater</green>\n\n';
		var maxEdu = player.style / 50;
		if (player.hair == Hairstyle.ordered[Hairstyle.ordered.length - 1] && player.outfit == Outfit.ordered[Outfit.ordered.length - 1])
		{
			Sound.play("upgrade");
			txt += "Who needs the movies? <rainbow>You're the real star!</rainbow>";
		}
		else
		{
			txt += "You don't feel like watching a movie now.";
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
