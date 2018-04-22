package streets.scenes;

class LibraryScene extends Scene
{
	static inline var CHARS_PER_SECOND:Int = 64;

	var player:Player;
	var next:Null<Education>;
	var label:Label;
	var displayCharCount:Float = 0;

	public function new(player:Player)
	{
		super();
		this.player = player;
		bgAlpha = 0;
		var i = Education.ordered.indexOf(player.education);
		next = (i == Education.ordered.length - 1) ? null : Education.ordered[i + 1];
	}

	override public function begin()
	{
		var msgBox = new MessageBox(HXP.width - 16 * 4, HXP.height - 16 * 2);
		var txt = '<center><green>Library</green>\n\n';
		if (next != null)
		{
			txt += 'For just $<green>${next.cost}</green>, I can teach you:\n\n${next.name}\n[<green>Fan income +${"$"}${next.bonus}</green>]\n\nCurrent: +${"$"}${player.education.bonus}\n\n';
			if (player.money >= next.cost)
			{
				txt += "<green>Press ENTER to accept</green>\n<red>Press ESCAPE to leave</red>";
				onInputPressed.start.bind(buy);
			}
			else
			{
				txt += '<red>You don\'t have enough money <white>($<green>${player.money}</green>)\n\n<flash>Press ENTER</flash>';
				onInputPressed.start.bind(close);
				Sound.play("nope");
			}
		}
		else
		{
			txt += "You're one <sine>smart dude</sine>! Nothin more I can <rainbow>teach ya</rainbow>!\n\n<flash>Press ENTER</flash>";
			onInputPressed.start.bind(close);
		}
		msgBox.addText(txt);
		label = msgBox.label;
		label.displayCharCount = 0;
		msgBox.x = (HXP.width - msgBox.width) / 2;
		msgBox.y = (HXP.height - msgBox.height) / 2;
		addGraphic(msgBox);

		onInputPressed.quit.bind(close);
	}

	override public function update()
	{
		super.update();
		displayCharCount += HXP.elapsed * CHARS_PER_SECOND;
		label.displayCharCount = Std.int(displayCharCount);
	}

	function buy()
	{
		player.money -= next.cost;
		player.education = next;
		Sound.play("upgrade");
		HXP.engine.popScene();
		HXP.engine.pushScene(new MessageScene(next.description));
	}

	function close()
	{
		HXP.engine.popScene();
	}
}
