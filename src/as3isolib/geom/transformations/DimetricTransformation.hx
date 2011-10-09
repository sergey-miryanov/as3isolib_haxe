//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.geom.transformations;

import as3isolib.geom.Pt;

class DimetricTransformation implements IAxonometricTransformation
{
	public function new()
	{
		{ };
	}
	public function screenToSpace(screenPt : Pt) : Pt
	{
		return null;
	}
	public function spaceToScreen(spacePt : Pt) : Pt
	{
		var z : Float = spacePt.z;
		var y : Float = spacePt.y / 4 - spacePt.z;
		var x : Float = spacePt.x - spacePt.y / 2;
		return new Pt(x, y, z);
	}
}
