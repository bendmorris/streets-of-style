package streets;

import haxepunk.HXP;
import haxepunk.Sfx;

typedef SoundType = String;

class Sound
{
	static var FORMAT:String = "ogg";

	public static var muted(get, set):Bool;
	static inline function get_muted():Bool return _muted;
	static inline function set_muted(v:Bool):Bool
	{
		if (_muted != v)
		{
			toggleMute();
		}
		return _muted;
	}

	static var _muted:Bool = false;
	static var loaded:Map<String, Sfx> = new Map();
	static var sfxQueue:Array<SoundType> = new Array();
	static var volumeQueue:Array<Float> = new Array();

	public static function update()
	{
		if (sfxQueue.length > 0)
		{
			_play(sfxQueue.shift(), volumeQueue.shift());
		}
	}

	public static inline function play(sound:SoundType, ?volume:Float=1)
	{
		sfxQueue.push(sound);
		volumeQueue.push(volume);
	}

	public static function _play(sound:SoundType, ?volume:Float=1)
	{
		if (!muted)
		{
			if (!loaded.exists(sound))
			{
				loaded[sound] = new Sfx('assets/sounds/$sound.$FORMAT');
				loaded[sound].type = "sfx";
			}
			loaded[sound].play(volume);
		}
	}

	public static function toggleMute()
	{
		_muted = !_muted;
		Sfx.setVolume("sfx", _muted ? 0 : 1);
	}
}
