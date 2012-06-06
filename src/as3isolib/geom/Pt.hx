//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.geom;

import flash.geom.Point;

class Pt extends Point
{
	public var z : Float;

	static public function distance(ptA : Pt, ptB : Pt) : Float
	{
		var tx : Float = ptB.x - ptA.x;
		var ty : Float = ptB.y - ptA.y;
		var tz : Float = ptB.z - ptA.z;
		return Math.sqrt(tx * tx + ty * ty + tz * tz);
	}

	static public function theta(ptA : Pt, ptB : Pt) : Float
	{
		var tx : Float = ptB.x - ptA.x;
		var ty : Float = ptB.y - ptA.y;
		var radians : Float = Math.atan(ty / tx);
		if(tx < 0) radians += Math.PI;
		if(tx >= 0 && ty < 0) radians += Math.PI * 2;
		return radians;
	}

	static public function angle(ptA : Pt, ptB : Pt) : Float
	{
		return theta(ptA, ptB) * 180 / Math.PI;
	}

	static public function polar(originPt : Pt, radius : Float, theta : Float) : Pt
	{
		var tx : Float = originPt.x + Math.cos(theta) * radius;
		var ty : Float = originPt.y + Math.sin(theta) * radius;
		var tz : Float = originPt.z;
		return new Pt(tx, ty, tz);
	}

	static public function interpolate(ptA : Pt, ptB : Pt, f : Float) : Pt
	{
		if(f <= 0) return ptA;
		if(f >= 1) return ptB;
		var nx : Float = (ptB.x - ptA.x) * f + ptA.x;
		var ny : Float = (ptB.y - ptA.y) * f + ptA.y;
		var nz : Float = (ptB.z - ptA.z) * f + ptA.z;
		return new Pt(nx, ny, nz);
	}

	@:getter(length) function getLength() : Float
	{
		return Math.sqrt(x * x + y * y + z * z);
	}

	override public function clone() : Point
	{
		return new Pt(x, y, z);
	}

	public function new(x : Float=0., y : Float=0., z : Float=0.)
	{
		super();
		this.x = x;
		this.y = y;
		this.z = z;
	}

	#if flash override #end public function toString() : String
	{
		return "x:" + x + " y:" + y + " z:" + z;
	}
}
