package streets.scenes;

import haxepunk.Sfx;
import haxepunk.graphics.Image;
import haxepunk.input.Input;
import haxepunk.input.Key;
import haxepunk.utils.Ease;

class TitleScene extends Scene
{
	static inline var FLASH_PERIOD:Float = 1.25;
	static inline var SCROLL_PER_SECOND:Int = 84;
	var flashTime:Float = 0;
	var l:Label;

	override public function begin()
	{
		addGraphic(new LevelTilemap(1));

		var i = new Image("assets/graphics/logo.png");
		i.scrollX = 0;
		addGraphic(i);

		l = new Label("Press ENTER");
		l.scrollX = 0;
		var e = addGraphic(l);
		e.y = HXP.height * 0.75;
		e.x = (HXP.width - l.textWidth) / 2;

		var s = new Player();
		s.scrollX = 0;
		s.play("run");
		s.y = 16 * 9;
		s.x = 16 * 2;
		add(s);

		Music.play("streets");

		onInputPressed.start.bind(startGame);
	}

	override public function update()
	{
		super.update();

		flashTime += HXP.elapsed / FLASH_PERIOD * (!l.visible ? 2 : 1);
		if (flashTime >= 1)
		{
			--flashTime;
			l.visible = !l.visible;
		}

		HXP.camera.x += SCROLL_PER_SECOND * HXP.elapsed;
		if (HXP.camera.x > 128 * 16 - HXP.width)
		{
			HXP.camera.x -= 128 * 16 - HXP.width;
		}
	}

	function startGame()
	{
		HXP.scene = new GameScene();
	}
}
