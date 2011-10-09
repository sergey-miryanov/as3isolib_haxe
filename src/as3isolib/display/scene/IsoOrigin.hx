//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.display.primitive.IsoPrimitive;
import as3isolib.enums.IsoOrientation;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;
import as3isolib.graphics.SolidColorFill;
import as3isolib.graphics.Stroke;
import as3isolib.utils.IsoDrawingUtil;
import flash.display.Graphics;

/**
 * IsoOrigin is a visual class that depicts the origin pt (typically at 0, 0, 0) with multicolored axis lines.
 */
class IsoOrigin extends IsoPrimitive
{
	/**
	 * The length of each axis (not including the arrows).
	 */
	public var axisLength : Float;
	/**
	 * The arrow length for each arrow found on each axis.
	 */
	public var arrowLength : Float;
	/**
	 * The arrow width for each arrow found on each axis. 
	 * This is the total width of the arrow at the base.
	 */
	public var arrowWidth : Float;

	public function new(descriptor : Dynamic = null)
	{
		axisLength = 100;
		arrowLength = 20;
		arrowWidth = 3;
		super(descriptor);
		if(descriptor == null || !Reflect.hasField(descriptor,"strokes")) 
		{
			strokes = cast [new Stroke(0, 0xFF0000, 0.75), new Stroke(0, 0x00FF00, 0.75), new Stroke(0, 0x0000FF, 0.75)];
		}
		if(descriptor == null || !Reflect.hasField(descriptor,"fills")) 
		{
			fills = cast [new SolidColorFill(0xFF0000, 0.75), new SolidColorFill(0x00FF00, 0.75), new SolidColorFill(0x0000FF, 0.75)];
		}
	}

	override function drawGeometry() : Void
	{
		var pt0 : Pt = IsoMath.isoToScreen(new Pt(-1 * axisLength, 0, 0));
		var ptM : Pt;
		var pt1 : Pt = IsoMath.isoToScreen(new Pt(axisLength, 0, 0));
		var g : Graphics = mainContainer.graphics;
		g.clear();
		var stroke : IStroke = strokes[0];
		var fill : IFill = fills[0];
		stroke.apply(g);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		g.lineStyle(0, 0, 0);
		g.moveTo(pt0.x, pt0.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(-1 * axisLength, 0), 180, arrowLength, arrowWidth);
		fill.end(g);
		g.moveTo(pt1.x, pt1.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(axisLength, 0), 0, arrowLength, arrowWidth);
		fill.end(g);
		stroke = strokes[1];
		fill = fills[1];
		pt0 = IsoMath.isoToScreen(new Pt(0, -1 * axisLength, 0));
		pt1 = IsoMath.isoToScreen(new Pt(0, axisLength, 0));
		stroke.apply(g);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		g.lineStyle(0, 0, 0);
		g.moveTo(pt0.x, pt0.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, -1 * axisLength), 270, arrowLength, arrowWidth);
		fill.end(g);
		g.moveTo(pt1.x, pt1.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, axisLength), 90, arrowLength, arrowWidth);
		fill.end(g);
		stroke = strokes[2];
		fill = fills[2];
		pt0 = IsoMath.isoToScreen(new Pt(0, 0, -1 * axisLength));
		pt1 = IsoMath.isoToScreen(new Pt(0, 0, axisLength));
		stroke.apply(g);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		g.lineStyle(0, 0, 0);
		g.moveTo(pt0.x, pt0.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, 0, axisLength), 90, arrowLength, arrowWidth, IsoOrientation.XZ);
		fill.end(g);
		g.moveTo(pt1.x, pt1.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, 0, -1 * axisLength), 270, arrowLength, arrowWidth, IsoOrientation.YZ);
		fill.end(g);
	}

	override public function setWidth(value : Float) : Float
	{
		super.setWidth(0);
		return 0;
	}

	override public function setLength(value : Float) : Float
	{
		super.setLength(0);
		return 0;
	}

	override public function setHeight(value : Float) : Float
	{
		super.setHeight(0);
		return 0;
	}
}
