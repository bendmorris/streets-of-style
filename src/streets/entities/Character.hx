package streets.entities;

class Character extends Entity
{
	static var collisions:Array<Character> = new Array();

	static inline var MOVE_PER_SECOND:Int = 84;
	static inline var PUSH_PER_SECOND:Int = 4;
	static inline var FLASH_DURATION:Float = 0.05;

	public var busy:Bool = false;

	var sm:Spritemap;
	var hairSm:Spritemap;

	var speed:Float = 1;
	var flashTime:Float = 0;

	public var level:Int = 0;

	public var style(get, never):Int;
	inline function get_style() return outfit.style + hair.style;

	public var flipX(default, set):Bool = false;
	inline function set_flipX(v:Bool)
	{
		sm.flipX = v;
		if (hairSm != null) hairSm.flipX = v;
		return flipX = v;
	}

	public var scrollX(default, set):Float = 1;
	inline function set_scrollX(v:Float)
	{
		sm.scrollX = v;
		if (hairSm != null) hairSm.scrollX = v;
		return scrollX = v;
	}

	public var outfit(default, set):Outfit = null;
	function set_outfit(v:Outfit)
	{
		var gl:Graphiclist = cast graphic;
		if (v != outfit)
		{
			sm = new Spritemap("assets/graphics/player.png", 32, 32);
			sm.flipX = this.flipX;
			sm.scrollX = this.scrollX;
			addAnimations(sm, v.row * 8, true);
			gl.children[0] = sm;
			play("idle", true);
		}
		outfit = v;
		calculateLevel();
		return v;
	}

	public var hair(default, set):Hairstyle = Hairstyle.Bald;
	function set_hair(v:Hairstyle)
	{
		var gl:Graphiclist = cast graphic;
		if (v != hair)
		{
			if (hairSm != null)
			{
				gl.children[1] = null;
				hairSm = null;
			}
			if (v.row > 0)
			{
				hairSm = new Spritemap("assets/graphics/player.png", 32, 32);
				hairSm.flipX = this.flipX;
				hairSm.scrollX = this.scrollX;
				addAnimations(hairSm, (v.row + 9) * 8, false);
				gl.children[1] = hairSm;
			}
			play("idle", true);
		}
		hair = v;
		calculateLevel();
		return v;
	}

	var actionQueue:Array<ActionType> = new Array();

	public function new(randomize:Bool)
	{
		super();

		var gl = new Graphiclist();
		gl.add(null);
		gl.add(null);
		gl.active = true;
		graphic = gl;

		outfit = randomize ? Outfit.random : Outfit.Nude;
		hair = randomize ? Hairstyle.random : Hairstyle.Bald;

		originX = -10;
		originY = -15;

		width = 12;
		height = 12;

		collidable = true;
		type = "character";
	}

	public function move(moveX:Float, moveY:Float)
	{
		play("run");
		var vlen = (moveX == 0 || moveY == 0) ? 1 : Math.sqrt(2);
		var moveSpeed = HXP.elapsed * MOVE_PER_SECOND / vlen * speed;
		moveX *= moveSpeed;
		moveY *= moveSpeed;

		x += moveX;
		y += moveY;

		if (moveX != 0) flipX = moveX < 0;
	}

	public function randomizePosition()
	{
		x = Math.random() * 126 * 16;
		y = 5.5 * 16 + Math.random() * (HXP.height - 7.5 * 16);
	}

	public function boundPosition()
	{
		x = MathUtil.clamp(x, 0, 126 * 16);
		y = MathUtil.clamp(y, 5.5 * 16, HXP.height - 32);
	}

	override public function update()
	{
		if (!busy && actionQueue.length > 0)
		{
			var action = actionQueue.shift();
			switch (action)
			{
				case Hit(dmg):
					hit(dmg);

				case Punch:
					// TODO
					busy = true;
					attack(1);
					play("punch", true);

				case Kick:
					// TODO
					busy = true;
					attack(2.5);
					play("kick", true);

				default:
					// TODO
			}
		}

		super.update();

		collideInto("character", x, y, collisions);
		for (collision in collisions) handleCollision(collision);
		HXP.clear(collisions);

		boundPosition();
		layer = Std.int((collidable ? y : 1) / -2);

		sm.color = flashTime > 0 ? 0xff8080 : 0xffffff;
		if (flashTime > 0)
		{
			flashTime -= HXP.elapsed / FLASH_DURATION;
			if (flashTime < 0) flashTime = 0;
		}
	}

	public function punch() queueAction(Punch);
	public function kick() queueAction(Kick);

	inline function queueAction(action:ActionType)
	{
		if (actionQueue.length < 2) actionQueue.push(action);
	}

	public function play(name:String, reset:Bool = false)
	{
		var a = sm.play(name, reset);
		if (hairSm != null) hairSm.play(name, reset);
		return a;
	}

	function finishAction()
	{
		play("idle", true);
		busy = false;
	}

	function addAnimations(sm:Spritemap, offset:Int, bind:Bool)
	{
		sm.add("idle", [offset]);
		sm.add("run",  [for (i in [1, 1, 0, 2, 2, 0]) offset + i], 15);
		sm.add("cheer", [for (i in [6, 6, 0]) offset + i], 3);
		sm.add("die", [for (i in [5, 7, 7, 7, 7]) offset + i], 3);
		var a = sm.add("hit", [for (i in [5, 5, 5, 0]) offset + i], 12);
		if (bind) a.onComplete.bind(finishAction);
		var a = sm.add("punch", [for (i in [3, 3, 0]) offset + i], 12, false);
		if (bind) a.onComplete.bind(finishAction);
		var a = sm.add("kick", [for (i in [4, 4, 0]) offset + i], 6, false);
		if (bind) a.onComplete.bind(finishAction);
	}

	function handleCollision(other:Character)
	{
		var dx = other.x - this.x, dy = (other.y - this.y) / 4;
		if (dx == 0 && dy == 0) dx = 1;
		var push = HXP.elapsed * PUSH_PER_SECOND;
		var dlen = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
		dx *= push / dlen;
		dy *= push / dlen;
		x -= dx;
		y -= dy;
		other.x += dx;
		other.y += dy;
		boundPosition();
		other.boundPosition();
	}

	function queueHit(dmg:Float)
	{
		while (actionQueue.length > 0) actionQueue.pop();
		busy = false;
		actionQueue.push(Hit(dmg));
	}

	function hit(dmg:Float)
	{
		play("hit", true);
		Sound.play("thud");
		flashTime = 1;
		busy = true;
	}

	function attack(dmg:Float)
	{
		Sound.play("attack");
		var d = flipX ? -1 : 1;
		collideInto("character", x + d * width * 0.75, y, collisions);
		if (collisions.length > 0)
		{
			var closest = collisions[0];
			var closestDistance = distance(closest);
			for (i in 1 ... collisions.length)
			{
				var c = collisions[i];
				var nextDistance = distance(c);
				if (nextDistance < closestDistance)
				{
					closest = c;
					closestDistance = nextDistance;
				}
			}
			closest.queueHit(dmg);
		}
		HXP.clear(collisions);
	}

	inline function distance(from:Character):Float
	{
		return distancePoint(from.x, from.y);
	}

	inline function distancePoint(px:Float, py:Float):Float
	{
		return Math.abs(px - x) + Math.abs(py - y) * 2;
	}

	function calculateLevel()
	{
		var outfitLevel = Outfit.ordered.indexOf(outfit);
		var hairLevel = Hairstyle.ordered.indexOf(hair);
		level = outfitLevel + hairLevel;
	}
}
