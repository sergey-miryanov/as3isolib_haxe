//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;

class IsoRectangle extends IsoPolygon
{
	override function validateGeometry() : Bool
	{
		pts = [];
		pts.push(new Pt(0, 0, 0));
		if(width > 0 && length > 0 && height <= 0) 
		{
			pts.push(new Pt(width, 0, 0));
			pts.push(new Pt(width, length, 0));
			pts.push(new Pt(0, length, 0));
		}
		else if(width > 0 && length <= 0 && height > 0) 
		{
			pts.push(new Pt(width, 0, 0));
			pts.push(new Pt(width, 0, height));
			pts.push(new Pt(0, 0, height));
		}
		else if(width <= 0 && length > 0 && height > 0) 
		{
			pts.push(new Pt(0, length, 0));
			pts.push(new Pt(0, length, height));
			pts.push(new Pt(0, 0, height));
		}
		else return false;
		var pt : Pt;
		for(pt in pts)IsoMath.isoToScreen(pt);
		return true;
	}
	override function drawGeometry() : Void
	{
		super.drawGeometry();
		geometryPts = [];
	}
	public function new(descriptor : Object)
	{
		super(descriptor);
		if(!descriptor) width = length = height = 0;
	}
}
