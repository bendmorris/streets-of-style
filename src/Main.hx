import haxepunk.Engine;
import haxepunk.assets.AssetCache;
import haxepunk.graphics.Image;
import haxepunk.graphics.text.BitmapText;
import haxepunk.graphics.atlas.TextureAtlas;
import haxepunk.graphics.shader.SceneShader;
import haxepunk.input.Input;
import haxepunk.input.Gesture;
import haxepunk.input.Key;
import haxepunk.input.Mouse;

class Main extends Engine
{
	static function main() new Main();

	static var _sineTime:Float = 0;
	static function sineWave(txt:BitmapText, data:RenderData)
	{
		data.y += (Math.sin(_sineTime * Math.PI * 6 - data.x / 8) - 0.5) * 2;
	}
	static var _rainbowColors:Array<Color> = {
		var a = new Array();
		for (i in 0 ... 16)
		{
			a.push(Color.getColorRGB(
				Std.int(Math.sin(i*0.6) * 127 + 128),
				Std.int(Math.sin(i*0.6 + 2*Math.PI/3) * 127 + 128),
				Std.int(Math.sin(i*0.6 + 4*Math.PI/3) * 127 + 128)
			));
		}
		a;
	}
	static function rainbowColors(txt:BitmapText, data:RenderData)
	{
		var index = ((_sineTime + data.x / 32) * _rainbowColors.length) % _rainbowColors.length;
		var i1 = Std.int(index), i2 = Std.int((index + 1) % _rainbowColors.length);
		data.color = _rainbowColors[i1].lerp(_rainbowColors[i2], index % 1);
	}
	static function flash(txt:BitmapText, data:RenderData)
	{
		data.color = _sineTime >= 0.75 ? 0 : 0xffffff;
	}
	static function updateTime()
	{
		_sineTime += HXP.elapsed / 1.5;
		_sineTime %= 1;
	}

	public function new()
	{
		super(256, 224, 60, false);
	}

	override public function init()
	{
		var atlas = TextureAtlas.loadGdxTexturePacker('assets/graphics/pack.atlas');
		@:privateAccess for (regionName in atlas._regions.keys())
		{
			AssetCache.global.addAtlasRegion(regionName, atlas._regions[regionName]);
		}

		haxepunk.pixel.PixelArtScaler.globalActivate();

		inline function defineImage(img:String, offsetX:Float=0, offsetY:Float=0)
		{
			var imagePath = 'assets/graphics/$img.png';
			var image = new Image(imagePath);
			image.x = offsetX;
			image.y = offsetY;
			BitmapText.defineImageTag(img, image, 4);
		}

		defineImage("heart", -4);
		defineImage("halfheart", -4);
		BitmapText.defineCustomTag("sine", sineWave);
		BitmapText.defineCustomTag("rainbow", rainbowColors);
		BitmapText.defineCustomTag("flash", flash);
		BitmapText.defineFormatTag("white", {color: 0xffffff});
		BitmapText.defineFormatTag("green", {color: 0x40ff40});
		BitmapText.defineFormatTag("red", {color: 0xff4040});
		preUpdate.bind(updateTime);

		Key.define("start", [Key.ENTER]);
		Key.define("up", [Key.UP, Key.W]);
		Key.define("down", [Key.DOWN, Key.S]);
		Key.define("left", [Key.LEFT, Key.A]);
		Key.define("right", [Key.RIGHT, Key.D]);
		Key.define("punch", [Key.J]);
		Key.define("kick", [Key.K]);
		Key.define("quit", [Key.ESCAPE]);

		HXP.engine.pushScene(new streets.scenes.TitleScene());
	}
}
