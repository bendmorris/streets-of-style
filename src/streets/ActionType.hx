package streets;

enum ActionType
{
	Punch;
	Kick;
	PressMove(dir:Direction);
	Hit(dmg:Float);
}
