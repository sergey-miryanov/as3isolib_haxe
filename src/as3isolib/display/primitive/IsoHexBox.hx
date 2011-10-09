//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.core.as3isolib_internal;
import as3isolib.enum.IsoOrientation;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import as3isolib.graphics.BitmapFill;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;
import flash.display.Graphics;
import flash.geom.Matrix;

class IsoHexBox extends IsoPrimitive
{
	static var sin60 : Float = Math.sin(Math.PI / 3);
	static var cos60 : Float = Math.cos(Math.PI / 3);
	var diameter : Float;
	override public function setWidth(value : Float) : Float
	{
		diameter = value;
		var sideLength : Float = value / 2;
		isoLength = 2 * sin60 * sideLength;
		super.width = value;
	}
	override public function setLength(value : Float) : Float
	{
		var sideLength : Float = value / 2 * sin60;
		isoWidth = diameter = 2 * sideLength;
		super.length = value;
	}
	override function drawGeometry() : Void
	{
		var sideLength : Float = diameter / 2;
		var ptb0 : Pt = new Pt(sideLength / 2, 0, 0);
		var ptb1 : Pt = Pt.polar(ptb0, sideLength, 0);
		var ptb2 : Pt = Pt.polar(ptb1, sideLength, Math.PI / 3);
		var ptb3 : Pt = Pt.polar(ptb2, sideLength, 2 * Math.PI / 3);
		var ptb4 : Pt = Pt.polar(ptb3, sideLength, Math.PI);
		var ptb5 : Pt = Pt.polar(ptb4, sideLength, 4 * Math.PI / 3);
		var ptt0 : Pt = new Pt(sideLength / 2, 0, height);
		var ptt1 : Pt = Pt.polar(ptt0, sideLength, 0);
		var ptt2 : Pt = Pt.polar(ptt1, sideLength, Math.PI / 3);
		var ptt3 : Pt = Pt.polar(ptt2, sideLength, 2 * Math.PI / 3);
		var ptt4 : Pt = Pt.polar(ptt3, sideLength, Math.PI);
		var ptt5 : Pt = Pt.polar(ptt4, sideLength, 4 * Math.PI / 3);
		var pt : Pt;
		var pts : Array<Dynamic> = new Array<Dynamic>(ptb0, ptb1, ptb2, ptb3, ptb4, ptb5, ptt0, ptt1, ptt2, ptt3, ptt4, ptt5);
		for(pt in pts)IsoMath.isoToScreen(pt);
		var g : Graphics = mainContainer.graphics;
		g.clear();
		var s : IStroke = strokes.length >= if(8) IStroke(strokes[7])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		var f : IFill = fills.length >= if(8) IFill(fills[7])		else DEFAULT_FILL;
		if(f) 
		{
			if(f is BitmapFill) BitmapFill(f).orientation = IsoOrientation.XY;
			f.begin(g);
		}
;
		g.moveTo(ptb0.x, ptb0.y);
		g.lineTo(ptb1.x, ptb1.y);
		g.lineTo(ptb2.x, ptb2.y);
		g.lineTo(ptb3.x, ptb3.y);
		g.lineTo(ptb4.x, ptb4.y);
		g.lineTo(ptb5.x, ptb5.y);
		g.lineTo(ptb0.x, ptb0.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(5) IStroke(strokes[4])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(5) IFill(fills[4])		else DEFAULT_FILL;
		if(f) 
		{
			if(f is BitmapFill) 
			{
				var m : Matrix = new Matrix();
				m.b = Math.tan(Pt.theta(ptb4, ptb5));
				BitmapFill(f).orientation = m;
			}
;
			f.begin(g);
		}
;
		g.moveTo(ptb4.x, ptb4.y);
		g.lineTo(ptb5.x, ptb5.y);
		g.lineTo(ptt5.x, ptt5.y);
		g.lineTo(ptt4.x, ptt4.y);
		g.lineTo(ptb4.x, ptb4.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(6) IStroke(strokes[5])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(6) IFill(fills[5])		else DEFAULT_FILL;
		if(f) 
		{
			if(f is BitmapFill) 
			{
				m = new Matrix();
				m.b = Math.tan(Pt.theta(ptb5, ptb0));
				BitmapFill(f).orientation = m;
			}
;
			f.begin(g);
		}
;
		g.moveTo(ptb0.x, ptb0.y);
		g.lineTo(ptb5.x, ptb5.y);
		g.lineTo(ptt5.x, ptt5.y);
		g.lineTo(ptt0.x, ptt0.y);
		g.lineTo(ptb0.x, ptb0.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(7) IStroke(strokes[6])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(7) IFill(fills[6])		else DEFAULT_FILL;
		if(f) 
		{
			f.end(g);
			if(f is BitmapFill) BitmapFill(f).orientation = IsoOrientation.XZ;
			f.begin(g);
		}
;
		g.moveTo(ptb0.x, ptb0.y);
		g.lineTo(ptb1.x, ptb1.y);
		g.lineTo(ptt1.x, ptt1.y);
		g.lineTo(ptt0.x, ptt0.y);
		g.lineTo(ptb0.x, ptb0.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(2) IStroke(strokes[1])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(2) IFill(fills[1])		else DEFAULT_FILL;
		if(f) 
		{
			if(f is BitmapFill) 
			{
				m = new Matrix();
				m.b = Math.tan(Pt.theta(ptb2, ptb1));
				BitmapFill(f).orientation = m;
			}
;
			f.begin(g);
		}
;
		g.moveTo(ptb1.x, ptb1.y);
		g.lineTo(ptb2.x, ptb2.y);
		g.lineTo(ptt2.x, ptt2.y);
		g.lineTo(ptt1.x, ptt1.y);
		g.lineTo(ptb1.x, ptb1.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(3) IStroke(strokes[2])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(3) IFill(fills[2])		else DEFAULT_FILL;
		f = IFill(fills[2]);
		if(f) 
		{
			if(f is BitmapFill) 
			{
				m = new Matrix();
				m.b = Math.tan(Pt.theta(ptb3, ptb2));
				BitmapFill(f).orientation = m;
			}
;
			f.begin(g);
		}
;
		g.moveTo(ptb2.x, ptb2.y);
		g.lineTo(ptb3.x, ptb3.y);
		g.lineTo(ptt3.x, ptt3.y);
		g.lineTo(ptt2.x, ptt2.y);
		g.lineTo(ptb2.x, ptb2.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(4) IStroke(strokes[3])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(4) IFill(fills[3])		else DEFAULT_FILL;
		if(f) 
		{
			if(f is BitmapFill) BitmapFill(f).orientation = IsoOrientation.XZ;
			f.begin(g);
		}
;
		g.moveTo(ptb3.x, ptb3.y);
		g.lineTo(ptb4.x, ptb4.y);
		g.lineTo(ptt4.x, ptt4.y);
		g.lineTo(ptt3.x, ptt3.y);
		g.lineTo(ptb3.x, ptb3.y);
		s = null;
		if(f) f.end(g);
		s = strokes.length >= if(1) IStroke(strokes[0])		else DEFAULT_STROKE;
		if(s) s.apply(g);
		f = fills.length >= if(1) IFill(fills[0])		else DEFAULT_FILL;
		if(f) 
		{
			if(f is BitmapFill) BitmapFill(f).orientation = IsoOrientation.XY;
			f.begin(g);
		}
;
		g.moveTo(ptt0.x, ptt0.y);
		g.lineTo(ptt1.x, ptt1.y);
		g.lineTo(ptt2.x, ptt2.y);
		g.lineTo(ptt3.x, ptt3.y);
		g.lineTo(ptt4.x, ptt4.y);
		g.lineTo(ptt5.x, ptt5.y);
		g.lineTo(ptt0.x, ptt0.y);
		s = null;
		if(f) f.end(g);
	}
	override public function setStroke(value : IStroke) : IStroke
	{
		strokes = [value, value, value, value, value, value, value, value];
	}
	public function new(descriptor : Object)
	{
		super(descriptor);
	}
}
