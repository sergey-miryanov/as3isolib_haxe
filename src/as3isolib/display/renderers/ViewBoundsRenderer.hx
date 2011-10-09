//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.IIsoView;
import as3isolib.display.scene.IIsoScene;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;

class ViewBoundsRenderer implements IViewRenderer
{
	public var drawAll : Bool;
	public var targetGraphics : Graphics;
	public var lineThickness : Float;
	public var lineColor : UInt;
	public var lineAlpha : Float;
	public var targetScenes : Array<Dynamic>;
	public function renderView(view : IIsoView) : Void
	{
		if(!targetScenes || targetScenes.length < 1) targetScenes = view.scenes;
		var v : Sprite = Sprite(view);
		var g : Graphics = if(targetGraphics) targetGraphics		else v.graphics;
		g.clear();
		g.lineStyle(lineThickness, lineColor, lineAlpha);
		var bounds : Rectangle;
		var child : IIsoDisplayObject;
		var children : Array<Dynamic> = [];
		var scene : IIsoScene;
		for(scene in targetScenes)children = children.concat(scene.children);
		for(child in children)
		{
			if(drawAll || child.includeInLayout) 
			{
				bounds = child.getBounds(v);
				bounds.width *= view.currentZoom;
				bounds.height *= view.currentZoom;
				g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			}
;
		}
;
	}
}
