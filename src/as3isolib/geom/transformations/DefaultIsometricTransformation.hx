//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.geom.transformations;

import as3isolib.geom.Pt;

class DefaultIsometricTransformation implements IAxonometricTransformation
{
	var radians : Float;
	var ratio : Float;
	var bAxonometricAxesProjection : Bool;
	var bMaintainZAxisRatio : Bool;
	var axialProjection : Float;

	/**
	 * Constructor
	 * 
	 * @param projectValuesToAxonometricAxes A flag indicating whether to compute x, y, z, width, lenght, and height values to the axonometric axes or screen axes.
	 * @param maintainZaxisRatio A flag indicating if the z axis values are to be adjusted to maintain proportions based on the x &amp; axis values. 
	 */
	public function new(projectValuesToAxonometricAxes : Bool = false, maintainZAxisRatio : Bool = false)
	{
		ratio = 2;
		axialProjection = Math.cos(Math.atan(0.5));
		bAxonometricAxesProjection = projectValuesToAxonometricAxes;
		bMaintainZAxisRatio = maintainZAxisRatio;
	}

	public function screenToSpace(screenPt : Pt) : Pt
	{
		var z : Float = screenPt.z;
		var y : Float = screenPt.y - (screenPt.x / ratio) + screenPt.z;
		var x : Float = (screenPt.x / ratio) + screenPt.y + screenPt.z;

		if(!bAxonometricAxesProjection && bMaintainZAxisRatio)
			z = z * axialProjection;

		if(bAxonometricAxesProjection)
		{
			x = x / axialProjection;
			y = y / axialProjection;
		}

		return new Pt(x, y, z);
	}

	public function spaceToScreen(spacePt : Pt) : Pt
	{
		if(!bAxonometricAxesProjection && bMaintainZAxisRatio)
			spacePt.z = spacePt.z / axialProjection;

		if(bAxonometricAxesProjection) 
		{
			spacePt.x = spacePt.x * axialProjection;
			spacePt.y = spacePt.y * axialProjection;
		}

		var z : Float = spacePt.z;
		var y : Float = (spacePt.x + spacePt.y) / ratio - spacePt.z;
		var x : Float = spacePt.x - spacePt.y;

		return new Pt(x, y, z);
	}
}
