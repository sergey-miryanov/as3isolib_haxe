//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.IIsoView;
import as3isolib.display.scene.IIsoScene;
import flash.display.Sprite;
import flash.geom.Rectangle;

class DefaultViewRenderer implements IViewRenderer
{
	public var scenes(getScenes, setScenes) : Array<Dynamic>;
	var scenesArray : Array<Dynamic>;
	public function getScenes() : Array<Dynamic>
	{
		return scenesArray;
	}
	public function setScenes(value : Array<Dynamic>) : Array<Dynamic>
	{
		scenesArray = value;
	}
	public function renderView(view : IIsoView) : Void
	{
		var targetScenes : Array<Dynamic> = if((scenesArray && scenesArray.length >= 1)) scenesArray		else view.scenes;
		if(targetScenes.length < 1) return;
		var v : Sprite = Sprite(view);
		var rect : Rectangle = new Rectangle(0, 0, v.width, v.height);
		var bounds : Rectangle;
		var child : IIsoDisplayObject;
		var children : Array<Dynamic> = [];
		var scene : IIsoScene;
		for(scene in targetScenes)children = children.concat(scene.children);
		for(child in children)
		{
			bounds = child.getBounds(v);
			bounds.width *= view.currentZoom;
			bounds.height *= view.currentZoom;
			child.includeInLayout = rect.intersects(bounds);
		}
;
	}
}
