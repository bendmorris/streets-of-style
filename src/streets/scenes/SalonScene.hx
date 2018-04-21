package streets.scenes;

class SalonScene extends Scene
{
	static inline var CHARS_PER_SECOND:Int = 64;

	var player:Player;
	var style:Hairstyle;
	var onPurchase:Void->Void;
	var label:Label;
	var displayCharCount:Float = 0;

	public function new(player:Player, style:Hairstyle, onPurchase:Void->Void)
	{
		super();
		this.player = player;
		this.style = style;
		this.onPurchase = onPurchase;
		bgAlpha = 0;
	}

	override public function begin()
	{
		var msgBox = new MessageBox(HXP.width - 16 * 4, HXP.height - 16 * 2);
		var txt = '<center><green>Salon</green>\n\n';
		if (player.hair.style < style.style)
		{
			txt += 'For just $<green>${style.cost}</green>, I can give you a sick:\n\n${style.name} [<green>${style.style}</green>]\n\nCurrent:\n${player.hair.name} [<red>${player.hair.style}</red>]\n\n';
			if (player.money >= style.cost)
			{
				txt += "<green>Press ENTER to accept</green>\n<red>Press ESCAPE to leave</red>";
				onInputPressed.start.bind(buy);
			}
			else
			{
				txt += '<red>You don\'t have enough money <white>($<green>${player.money}</green>)\n\n<flash>Press ENTER</flash>';
				onInputPressed.start.bind(close);
			}
		}
		else
		{
			txt += "Lookin' <sine>great</sine>! I can't improve on that <rainbow>hella fine do</rainbow>.\n\n<flash>Press ENTER</flash>";
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
		player.money -= style.cost;
		player.hair = style;
		onPurchase();
		HXP.engine.popScene();
		HXP.engine.pushScene(new MessageScene("Thanks for your purchase! You won't regret it!"));
	}

	function close()
	{
		HXP.engine.popScene();
	}
}
