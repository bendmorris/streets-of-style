package streets.graphics;

import haxe.xml.Fast;
import haxepunk.assets.AssetLoader;
import haxepunk.tmx.TmxMap;
import streets.entities.Library;
import streets.entities.Salon;
import streets.entities.Store;
import streets.entities.Theater;

class LevelTilemap extends Graphiclist
{
	public var objects:Array<Entity> = new Array();

	public function new(level:Int)
	{
		super();

		var mapData = MapData.fromString(AssetLoader.getText('assets/maps/level$level.tmx'));
		var map = new TmxMap(mapData);
		for (layer in map.layers)
		{
			var tm = new Tilemap("assets/graphics/tiles.png", layer.width * 16, layer.height * 16, 16, 16);
			for (x in 0 ... layer.width) for (y in 0 ... layer.height)
			{
				tm.setTile(x, y, layer.tileGIDs[y][x] - 1);
			}
			tm.scrollX = layer.properties.has("scrollX") ? Std.parseFloat(layer.properties.scrollX) : 1;
			add(tm);
		}
		for (group in map.objectGroups) for (object in group.objects)
		{
			var obj:Entity = switch (object.custom.type)
			{
				case "salon": new Salon(object.custom.style);
				case "store": new Store(object.custom.style);
				case "library": new Library();
				case "theater": new Theater();
				default: null;
			}
			if (obj != null)
			{
				obj.x = object.x;
				obj.y = object.y;
				objects.push(obj);
			}
		}
	}
}
