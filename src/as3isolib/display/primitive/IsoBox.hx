//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.enums.RenderStyleType;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import as3isolib.graphics.IBitmapFill;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;
import flash.display.Graphics;
import flash.geom.Matrix;

class IsoBox extends IsoPrimitive
{
	public function new(descriptor : Dynamic = null)
	{
		super(descriptor);
	}

	override public function setStroke(value : IStroke) : IStroke
	{
		strokes = [value, value, value, value, value, value];
		return value;
	}

	override function validateGeometry() : Bool
	{
		return (width <= 0 && length <= 0 && height <= 0) ? false : true;
	}

	override function drawGeometry() : Void
	{
		var g : Graphics = mainContainer.graphics;
		g.clear();

		//all pts are named in following order "x", "y", "z" 
		//via rfb = right, front, bottom
		var lbb : Pt = IsoMath.isoToScreen(new Pt(0, 0, 0));
		var rbb : Pt = IsoMath.isoToScreen(new Pt(width, 0, 0));
		var rfb : Pt = IsoMath.isoToScreen(new Pt(width, length, 0));
		var lfb : Pt = IsoMath.isoToScreen(new Pt(0, length, 0));

		var lbt : Pt = IsoMath.isoToScreen(new Pt(0, 0, height));
		var rbt : Pt = IsoMath.isoToScreen(new Pt(width, 0, height));
		var rft : Pt = IsoMath.isoToScreen(new Pt(width, length, height));
		var lft : Pt = IsoMath.isoToScreen(new Pt(0, length, height));

		//bottom face
		g.moveTo(lbb.x, lbb.y);
		var fill : IFill = (fills.length >= 6) ? fills[5] : IsoPrimitive.DEFAULT_FILL;
		if(fill != null && styleType != RenderStyleType.WIREFRAME) 
			fill.begin(g);

		var stroke : IStroke = (strokes.length >= 6) ? strokes[5] : IsoPrimitive.DEFAULT_STROKE;
		if(stroke != null) 
			stroke.apply(g);

		g.lineTo(rbb.x, rbb.y);
		g.lineTo(rfb.x, rfb.y);
		g.lineTo(lfb.x, lfb.y);
		g.lineTo(lbb.x, lbb.y);

		if(fill != null)
			fill.end(g);

		// back-left face
		g.moveTo(lbb.x, lbb.y);
		fill = fills.length >= 5 ? fills[4] : IsoPrimitive.DEFAULT_FILL;
		if(fill != null && styleType != RenderStyleType.WIREFRAME)
			fill.begin(g);

		stroke = (strokes.length >= 5) ? strokes[4] : IsoPrimitive.DEFAULT_STROKE;
		if(stroke != null) 
			stroke.apply(g);

		g.lineTo(lfb.x, lfb.y);
		g.lineTo(lft.x, lft.y);
		g.lineTo(lbt.x, lbt.y);
		g.lineTo(lbb.x, lbb.y);

		if(fill != null)
			fill.end(g);

		//back-right face
		g.moveTo(lbb.x, lbb.y);
		fill = (fills.length >= 4) ? fills[3] : IsoPrimitive.DEFAULT_FILL;
		if(fill != null && styleType != RenderStyleType.WIREFRAME)
			fill.begin(g);

		stroke = (strokes.length >= 4) ? strokes[3] : IsoPrimitive.DEFAULT_STROKE;
		if(stroke != null) 
			stroke.apply(g);

		g.lineTo(rbb.x, rbb.y);
		g.lineTo(rbt.x, rbt.y);
		g.lineTo(lbt.x, lbt.y);
		g.lineTo(lbb.x, lbb.y);

		if(fill != null)
			fill.end(g);

		//front-left face
		g.moveTo(lfb.x, lfb.y);
		fill = (fills.length >= 3) ? fills[2] : IsoPrimitive.DEFAULT_FILL;
		if(fill != null && styleType != RenderStyleType.WIREFRAME) 
		{
			if(Std.is(fill, IBitmapFill)) 
			{
				var f : IBitmapFill = cast fill;
				var m : Matrix = (f.matrix != null) ? f.matrix : new Matrix();
				m.tx += lfb.x;
				m.ty += lfb.y;
				if(f.repeat) { 
					//calculate how to stretch fill for face
					//this is not great OOP, sorry folks!
				};
				f.matrix = m;
			}
			fill.begin(g);
		}

		stroke = (strokes.length >= 3) ? strokes[2] : IsoPrimitive.DEFAULT_STROKE;
		if(stroke != null)
			stroke.apply(g);

		g.lineTo(lft.x, lft.y);
		g.lineTo(rft.x, rft.y);
		g.lineTo(rfb.x, rfb.y);
		g.lineTo(lfb.x, lfb.y);

		if(fill != null)
			fill.end(g);

		//front-right face
		g.moveTo(rbb.x, rbb.y);
		fill = (fills.length >= 2) ? fills[1] : IsoPrimitive.DEFAULT_FILL;
		if(fill != null && styleType != RenderStyleType.WIREFRAME) 
		{
			if(Std.is(fill, IBitmapFill))
			{
				var f : IBitmapFill = cast fill;
				var m : Matrix = (f.matrix != null) ? f.matrix : new Matrix();
				m.tx += lfb.x;
				m.ty += lfb.y;

				if (f.repeat)
				{
					//calculate how to stretch fill for face
					//this is not great OOP, sorry folks!
				}
				f.matrix = m;
			}
			fill.begin(g);
		}

		stroke = (strokes.length >= 2) ? strokes[1] : IsoPrimitive.DEFAULT_STROKE;
		if(stroke != null)
			stroke.apply(g);

		g.lineTo(rfb.x, rfb.y);
		g.lineTo(rft.x, rft.y);
		g.lineTo(rbt.x, rbt.y);
		g.lineTo(rbb.x, rbb.y);

		if(fill != null) 
			fill.end(g);

		//top face
		g.moveTo(lbt.x, lbt.y);
		fill = (fills.length >= 1) ? fills[0] : IsoPrimitive.DEFAULT_FILL;
		if(fill != null && styleType != RenderStyleType.WIREFRAME) 
		{
			if(Std.is(fill, IBitmapFill)) 
			{
				var f : IBitmapFill = cast fill;
				var m : Matrix = (f.matrix != null) ? f.matrix : new Matrix();
				m.tx += lbt.x;
				m.ty += lbt.y;
				if(!f.repeat) {

				}
				f.matrix = m;
			}
			fill.begin(g);
		}

		stroke = (strokes.length >= 1) ? strokes[0] : IsoPrimitive.DEFAULT_STROKE;
		if(stroke != null) 
			stroke.apply(g);

		g.lineTo(rbt.x, rbt.y);
		g.lineTo(rft.x, rft.y);
		g.lineTo(lft.x, lft.y);
		g.lineTo(lbt.x, lbt.y);

		if(fill != null)
			fill.end(g);
	}
}
