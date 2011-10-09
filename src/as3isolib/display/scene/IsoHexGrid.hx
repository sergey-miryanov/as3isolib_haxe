//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import as3isolib.graphics.IStroke;
import flash.display.Graphics;

class IsoHexGrid extends IsoGrid
{
	public function new(descriptor : Object)
	{
		super(descriptor);
	}
	override function drawGeometry() : Void
	{
		var g : Graphics = mainContainer.graphics;
		g.clear();
		var stroke : IStroke = IStroke(strokes[0]);
		if(stroke) stroke.apply(g);
		var pt : Pt;
		var pts : Array<Dynamic> = generatePts();
		for(pt in pts)drawHexagon(pt, g);
	}
	function generatePts() : Array<Dynamic>
	{
		var pt : Pt;
		var pts : Array<Dynamic> = [];
		var xOffset : Float = cellSize * Math.cos(Math.PI / 3);
		var yOffset : Float = cellSize * Math.sin(Math.PI / 3);
		var i : UInt;
		var m : UInt = uint(gridSize[0]);
		var j : UInt;
		var n : UInt = uint(gridSize[1]);
		while(j < n)
		{
			i = 0;
			while(i < m)
			{
				pt = new Pt();
				pt.x = i * (cellSize + xOffset);
				pt.y = j * yOffset * 2;
				if(i % 2 > 0) pt.y += yOffset;
				pts.push(pt);
				i++;
			}
;
			j++;
		}
;
		return pts;
	}
	function drawHexagon(startPt : Pt, g : Graphics) : Void
	{
		var pt0 : Pt = Pt(startPt.clone());
		var pt1 : Pt = Pt.polar(pt0, cellSize, 0);
		var pt2 : Pt = Pt.polar(pt1, cellSize, Math.PI / 3);
		var pt3 : Pt = Pt.polar(pt2, cellSize, 2 * Math.PI / 3);
		var pt4 : Pt = Pt.polar(pt3, cellSize, Math.PI);
		var pt5 : Pt = Pt.polar(pt4, cellSize, 4 * Math.PI / 3);
		var pt : Pt;
		var pts : Array<Dynamic> = new Array<Dynamic>(pt0, pt1, pt2, pt3, pt4, pt5);
		for(pt in pts)IsoMath.isoToScreen(pt);
		g.beginFill(0, 0);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		g.lineTo(pt2.x, pt2.y);
		g.lineTo(pt3.x, pt3.y);
		g.lineTo(pt4.x, pt4.y);
		g.lineTo(pt5.x, pt5.y);
		g.lineTo(pt0.x, pt0.y);
		g.endFill();
	}
}
