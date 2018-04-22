package streets.scenes;

import haxepunk.Sfx;
import haxepunk.graphics.Image;
import haxepunk.utils.Ease;
import haxepunk.input.Input;
import haxepunk.input.Key;

class GameScene extends Scene
{
	static inline var MIN_ENEMIES:Int = 8;
	static inline var MAX_ENEMIES:Int = 12;

	var player:Player;
	var enemies:Array<Enemy> = new Array();

	var paused:Bool = false;
	var pauseLabel:Label;

	override public function begin()
	{
		var lv = new LevelTilemap(1);
		addGraphic(lv);
		for (obj in lv.objects) add(obj);

		player = new Player();
		player.play("idle");
		player.y = 16 * 9;
		player.x = 16 * 2;
		add(player);

		{
			var msgBox = new MessageBox(16 * 6, 16);
			msgBox.addText("STYLE: 0");
			var styleLabel = msgBox.label;
			styleLabel.preUpdate.bind(function() {
				var s = Std.int(player.style);
				styleLabel.text = "STYLE: " + ((s > 0) ? '<rainbow>$s</rainbow>' : Std.string(s));
			});
			styleLabel.scrollX = 0;
			styleLabel.active = true;
			addGraphic(msgBox);
		}

		{
			var msgBox = new MessageBox(16 * 6, 16);
			msgBox.addText("<right>$0");
			var moneyLabel = msgBox.label;
			moneyLabel.preUpdate.bind(function() {
				var s = Std.int(player.money);
				moneyLabel.text = "<right>$" + ((s > 0) ? '<green>$s</green>' : Std.string(s));
			});
			moneyLabel.scrollX = 0;
			moneyLabel.active = true;
			msgBox.x = HXP.width - msgBox.width;
			addGraphic(msgBox);
		}

		onInputPressed.punch.bind(player.punch);
		onInputPressed.kick.bind(player.kick);
		onInputPressed.quit.bind(quit);
		onInputPressed.start.bind(pause);

		pauseLabel = new Label("<flash>-- PAUSED --</flash>");
		pauseLabel.x = (HXP.width - pauseLabel.textWidth) / 2;
		pauseLabel.y = (HXP.height - pauseLabel.textHeight) / 2;
		pauseLabel.scrollX = pauseLabel.scrollY = 0;
		pauseLabel.visible = false;
		addGraphic(pauseLabel);

		HXP.engine.pushScene(new MessageScene("These threads are <sine>whack</sine> as hell. Need to find some <rainbow>sweet kicks</rainbow> or I won't get no respect in this town."));
	}

	override public function update()
	{
		pauseLabel.visible = paused;
		if (paused) return;

		super.update();

		if (!player.busy)
		{
			var moveX:Float = Input.check("left") ? -1 : Input.check("right") ? 1 : 0;
			var moveY:Float = Input.check("up") ? -1 : Input.check("down") ? 1 : 0;
			if (moveX != 0 || moveY != 0)
			{
				player.move(moveX, moveY);
				camera.x = MathUtil.clamp(camera.x, Math.max(player.x - HXP.width * 0.625, 0), Math.min(128 * 16 - HXP.width, player.x - HXP.width * 0.375));
			}
			else
			{
				player.play("idle");
			}
		}

		var enemyBump = player.level;
		if (enemies.length < MIN_ENEMIES + enemyBump)
		{
			while (enemies.length < MAX_ENEMIES + enemyBump) spawnEnemy();
		}
	}

	function quit()
	{
		HXP.engine.pushScene(new QuitScene());
	}

	function spawnEnemy()
	{
		var enemy = new Enemy(player);
		while (Math.abs(enemy.x - player.x) < HXP.width) enemy.randomizePosition();
		add(enemy);
		enemies.push(enemy);
		enemy.onRemove.bind(function() enemies.remove(enemy));
	}

	function pause()
	{
		Sound.play("pause");
		paused = !paused;
	}
}
