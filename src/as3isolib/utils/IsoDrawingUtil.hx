//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.utils;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.enums.IsoOrientation;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
* IsoDrawingUtil provides some convenience methods for drawing shapes in 3D isometric space.
*/
class IsoDrawingUtil
{
	static inline var SQRT2 : Float = 1.4142135623730951;

	/**
	* Draws a rectangle in 3D isometric space relative to a specific plane.
	* 
	* @param g The target graphics object performing the drawing tasks.
	* @param originPt The origin pt where the specific drawing task originates.
	* @param width The width of the rectangle. This is relative to the first orientation axis in the given plane.
	* @param length The length of the rectangle. This is relative to the second orientation axis in the given plane.
	* @param plane The plane of orientation to draw the rectangle on.
	*/
	static public function drawIsoRectangle(g : Graphics, originPt : Pt, width : Float, length : Float, plane : String="xy") : Void
	{
		var pt0 : Pt = IsoMath.isoToScreen(originPt, true);
		var pt1 : Pt = null;
		var pt2 : Pt = null;
		var pt3 : Pt = null;

		switch(plane)
		{
		case IsoOrientation.XZ:
				pt1 = IsoMath.isoToScreen(new Pt(originPt.x + width, originPt.y, originPt.z));
				pt2 = IsoMath.isoToScreen(new Pt(originPt.x + width, originPt.y, originPt.z + length));
				pt3 = IsoMath.isoToScreen(new Pt(originPt.x, originPt.y, originPt.z + length));
		case IsoOrientation.YZ:
				pt1 = IsoMath.isoToScreen(new Pt(originPt.x, originPt.y + width, originPt.z));
				pt2 = IsoMath.isoToScreen(new Pt(originPt.x, originPt.y + width, originPt.z + length));
				pt3 = IsoMath.isoToScreen(new Pt(originPt.x, originPt.y, originPt.z + length));
		case IsoOrientation.XY:
				pt1 = IsoMath.isoToScreen(new Pt(originPt.x + width, originPt.y, originPt.z));
				pt2 = IsoMath.isoToScreen(new Pt(originPt.x + width, originPt.y + length, originPt.z));
				pt3 = IsoMath.isoToScreen(new Pt(originPt.x, originPt.y + length, originPt.z));
		}
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		g.lineTo(pt2.x, pt2.y);
		g.lineTo(pt3.x, pt3.y);
		g.lineTo(pt0.x, pt0.y);
	}

	/**
	 * Draws an arrow in 3D isometric space relative to a specific plane.
	 * 
	 * @param g The target graphics object performing the drawing tasks.
	 * @param originPt The origin pt where the specific drawing task originates.
	 * @param degrees The angle of rotation in degrees perpendicular to the plane of orientation.
	 * @param length The length of the arrow.
	 * @param width The width of the arrow.
	 * @param plane The plane of orientation to draw the arrow on.
	 */
	static public function drawIsoArrow(g : Graphics, originPt : Pt, degrees : Float, length : Float = 27, width : Float = 6, plane : String = "xy") : Void
	{
		var pt0 : Pt = new Pt();
		var pt1 : Pt = new Pt();
		var pt2 : Pt = new Pt();
		var toRadians : Float = Math.PI / 180;
		var ptR : Pt;
		switch(plane)
		{
		case IsoOrientation.XZ:
				pt0 = Pt.polar(new Pt(0, 0, 0), length, degrees * toRadians);
				ptR = new Pt(pt0.x + originPt.x, pt0.z + originPt.y, pt0.y + originPt.z);
				pt0 = IsoMath.isoToScreen(ptR);
				pt1 = Pt.polar(new Pt(0, 0, 0), width / 2, (degrees + 90) * toRadians);
				ptR = new Pt(pt1.x + originPt.x, pt1.z + originPt.y, pt1.y + originPt.z);
				pt1 = IsoMath.isoToScreen(ptR);
				pt2 = Pt.polar(new Pt(0, 0, 0), width / 2, (degrees + 270) * toRadians);
				ptR = new Pt(pt2.x + originPt.x, pt2.z + originPt.y, pt2.y + originPt.z);
				pt2 = IsoMath.isoToScreen(ptR);
		case IsoOrientation.YZ:
				pt0 = Pt.polar(new Pt(0, 0, 0), length, degrees * toRadians);
				ptR = new Pt(pt0.z + originPt.x, pt0.x + originPt.y, pt0.y + originPt.z);
				pt0 = IsoMath.isoToScreen(ptR);
				pt1 = Pt.polar(new Pt(0, 0, 0), width / 2, (degrees + 90) * toRadians);
				ptR = new Pt(pt1.z + originPt.x, pt1.x + originPt.y, pt1.y + originPt.z);
				pt1 = IsoMath.isoToScreen(ptR);
				pt2 = Pt.polar(new Pt(0, 0, 0), width / 2, (degrees + 270) * toRadians);
				ptR = new Pt(pt2.z + originPt.x, pt2.x + originPt.y, pt2.y + originPt.z);
				pt2 = IsoMath.isoToScreen(ptR);
		//case IsoOrientation.XY:
		default:
				pt0 = Pt.polar(originPt, length, degrees * toRadians);
				pt0 = IsoMath.isoToScreen(pt0);
				pt1 = Pt.polar(originPt, width / 2, (degrees + 90) * toRadians);
				pt1 = IsoMath.isoToScreen(pt1);
				pt2 = Pt.polar(originPt, width / 2, (degrees + 270) * toRadians);
				pt2 = IsoMath.isoToScreen(pt2);
		}

		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		g.lineTo(pt2.x, pt2.y);
		g.lineTo(pt0.x, pt0.y);
	}

	/**
	 * Creates a BitmapData object of the target IIsoDisplayObject.
	 * 
	 * @param target The target to retrieve the data from.
	 * 
	 * @return BitmapData A drawn bitmap data object of the target object.
	 * @TODO serious hack for NME
	 */
	static public function getIsoBitmapData(target : IIsoDisplayObject) : BitmapData
	{
		var oldOrphanValue : Bool = target.renderAsOrphan;
		target.renderAsOrphan = true;
		target.render();
		target.renderAsOrphan = oldOrphanValue;
		var rect : Rectangle = #if flash target.container.getBounds(target.container) #else target.container.nmeGetPixelBounds() #end; // todo nme needs a real getBounds()
		var bitmapdata : BitmapData = new BitmapData(Std.int(rect.width), Std.int(rect.height), true, 0);
		bitmapdata.draw(target.container, new Matrix(1, 0, 0, 1, rect.x * -1, rect.y * -1));
		return bitmapdata;
	}

	/**
	 * Given a particular isometric orientation this method returns a matrix needed to project(skew) and image onto that plane.
	 * 
	 * @param orientation The isometric planar orientation.
	 * @return Matrix The matrix associated with the provided isometric orientation.
	 * 
	 * @see as3isolib.enum.IsoOrientation
	 */
	static public function getIsoMatrix(orientation : String) : Matrix
	{
		var m : Matrix = new Matrix();
		switch(orientation)
		{
		case IsoOrientation.XY:
			var m2 : Matrix = new Matrix();
			m2.scale(1, 0.5);
			m.rotate(Math.PI / 4);
			m.scale(SQRT2, SQRT2);
			m.concat(m2);
		case IsoOrientation.XZ:
			m.b = Math.PI / 180 * 30;
		case IsoOrientation.YZ:
			m.b = Math.PI / 180 * -30;
		default:
		}
		return m;
	}
}
