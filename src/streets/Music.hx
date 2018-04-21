package streets;

import haxepunk.Sfx;

typedef MusicType = String;

class Music
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

	static var playing:Null<MusicType>;
	static var current:Sfx;

	public static function play(music:MusicType)
	{
		if (muted)
		{
			if (current != null)
			{
				current.stop();
			}
			current = null;
			playing = null;
		}
		else
		{
			if (current != null && playing == music)
				return;
			if (current != null)
			{
				current.stop();
			}
			current = new Sfx('assets/music/$music.$FORMAT');
			current.type = "music";
			current.play(1, 0, true);
			playing = music;
		}
	}

	public static function stop()
	{
		if (current != null)
		{
			current.stop();
			current = null;
			playing = null;
		}
	}

	public static function pause()
	{
		if (current != null)
		{
			current.stop();
		}
	}

	public static function resume()
	{
		if (current != null)
		{
			current.resume();
		}
	}

	public static function toggleMute()
	{
		_muted = !_muted;
		Sfx.setVolume("music", _muted ? 0 : 1);
	}
}
