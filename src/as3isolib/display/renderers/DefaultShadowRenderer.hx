//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.bounds.IBounds;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.scene.IIsoScene;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import flash.display.Graphics;
import flash.events.EventDispatcher;

class DefaultShadowRenderer implements ISceneRenderer
{
	public var drawAll : Bool;
	public var shadowColor : Int;
	public var shadowAlpha : Float;
	public function renderScene(scene : IIsoScene) : Void
	{
		g = scene.container.graphics;
		var shadowChildren : Array<Dynamic> = scene.displayListChildren;

		for(child in shadowChildren)
		{
			if(drawAll) 
			{
				g.beginFill(shadowColor, shadowAlpha);
				drawChildShadow(child);
			}
			else 
			{
				if(child.z > 0) 
				{
					g.beginFill(shadowColor, shadowAlpha);
					drawChildShadow(child);
				}
			}
			g.endFill();
		}
	}

	var g : Graphics;
	function drawChildShadow(child : IIsoDisplayObject) : Void
	{
		var b : IBounds = child.isoBounds;
		var pt : Pt;
		pt = IsoMath.isoToScreen(new Pt(b.left, b.back, 0));
		g.moveTo(pt.x, pt.y);
		pt = IsoMath.isoToScreen(new Pt(b.right, b.back, 0));
		g.lineTo(pt.x, pt.y);
		pt = IsoMath.isoToScreen(new Pt(b.right, b.front, 0));
		g.lineTo(pt.x, pt.y);
		pt = IsoMath.isoToScreen(new Pt(b.left, b.front, 0));
		g.lineTo(pt.x, pt.y);
		pt = IsoMath.isoToScreen(new Pt(b.left, b.back, 0));
		g.lineTo(pt.x, pt.y);
	}
}
