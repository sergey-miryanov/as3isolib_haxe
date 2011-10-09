//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.geom.transformations;

import as3isolib.geom.Pt;

class IsometricTransformation implements IAxonometricTransformation
{
	public function new()
	{
		cosTheta = Math.cos(30 * Math.PI / 180);
		sinTheta = Math.sin(30 * Math.PI / 180);
	}

	var cosTheta : Float;
	var sinTheta : Float;

	public function screenToSpace(screenPt : Pt) : Pt
	{
		var z : Float = screenPt.z;
		var y : Float = screenPt.y - screenPt.x / (2 * cosTheta) + screenPt.z;
		var x : Float = screenPt.x / (2 * cosTheta) + screenPt.y + screenPt.z;
		return new Pt(x, y, z);
	}

	public function spaceToScreen(spacePt : Pt) : Pt
	{
		var z : Float = spacePt.z;
		var y : Float = (spacePt.x + spacePt.y) * sinTheta - spacePt.z;
		var x : Float = (spacePt.x - spacePt.y) * cosTheta;
		return new Pt(x, y, z);
	}
}
