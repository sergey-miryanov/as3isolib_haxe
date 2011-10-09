//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.core.as3isolib_internal;
import as3isolib.enum.RenderStyleType;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;
import flash.display.Graphics;

class IsoPolygon extends IsoPrimitive
{
	public var pts(getPts, setPts) : Array<Dynamic>;
	override function validateGeometry() : Bool
	{
		return pts.length > 2;
	}
	override function drawGeometry() : Void
	{
		var g : Graphics = mainContainer.graphics;
		g.clear();
		g.moveTo(pts[0].x, pts[0].y);
		var fill : IFill = IFill(fills[0]);
		if(fill && styleType != RenderStyleType.WIREFRAME) fill.begin(g);
		var stroke : IStroke = strokes.length >= if(1) IStroke(strokes[0])		else DEFAULT_STROKE;
		if(stroke) stroke.apply(g);
		var i : UInt = 1;
		var l : UInt = pts.length;
		while(i < l)
		{
			g.lineTo(pts[i].x, pts[i].y);
			i++;
		}
;
		g.lineTo(pts[0].x, pts[0].y);
		if(fill) fill.end(g);
	}
	var geometryPts : Array<Dynamic>;
	public function getPts() : Array<Dynamic>
	{
		return geometryPts;
	}
	public function setPts(value : Array<Dynamic>) : Array<Dynamic>
	{
		if(geometryPts != value) 
		{
			geometryPts = value;
			invalidateSize();
			if(autoUpdate) render();
		}
;
	}
	public function new(descriptor : Object)
	{
		geometryPts = [];
		super(descriptor);
	}
}
