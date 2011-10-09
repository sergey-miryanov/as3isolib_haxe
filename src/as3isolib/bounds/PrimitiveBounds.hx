//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.bounds;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.geom.Pt;

class PrimitiveBounds implements IBounds
{
	public var volume(getVolume, never) : Float;
	public var width(getWidth, never) : Float;
	public var length(getLength, never) : Float;
	public var height(getHeight, never) : Float;
	public var left(getLeft, never) : Float;
	public var right(getRight, never) : Float;
	public var back(getBack, never) : Float;
	public var front(getFront, never) : Float;
	public var bottom(getBottom, never) : Float;
	public var top(getTop, never) : Float;
	public var centerPt(getCenterPt, never) : Pt;
	public function getVolume() : Float
	{
		return _target.width * _target.length * _target.height;
	}
	public function getWidth() : Float
	{
		return _target.width;
	}
	public function getLength() : Float
	{
		return _target.length;
	}
	public function getHeight() : Float
	{
		return _target.height;
	}
	public function getLeft() : Float
	{
		return _target.x;
	}
	public function getRight() : Float
	{
		return _target.x + _target.width;
	}
	public function getBack() : Float
	{
		return _target.y;
	}
	public function getFront() : Float
	{
		return _target.y + _target.length;
	}
	public function getBottom() : Float
	{
		return _target.z;
	}
	public function getTop() : Float
	{
		return _target.z + _target.height;
	}
	public function getCenterPt() : Pt
	{
		var pt : Pt = new Pt();
		pt.x = _target.x + _target.width / 2;
		pt.y = _target.y + _target.length / 2;
		pt.z = _target.z + _target.height / 2;
		return pt;
	}
	public function getPts() : Array<Pt>
	{
		var a : Array<Pt> = [];
		a.push(new Pt(left, back, bottom));
		a.push(new Pt(right, back, bottom));
		a.push(new Pt(right, front, bottom));
		a.push(new Pt(left, front, bottom));
		a.push(new Pt(left, back, top));
		a.push(new Pt(right, back, top));
		a.push(new Pt(right, front, top));
		a.push(new Pt(left, front, top));
		return a;
	}
	public function intersects(bounds : IBounds) : Bool
	{
		if(Math.abs(centerPt.x - bounds.centerPt.x) <= _target.width / 2 + bounds.width / 2 && Math.abs(centerPt.y - bounds.centerPt.y) <= _target.length / 2 + bounds.length / 2 && Math.abs(centerPt.z - bounds.centerPt.z) <= _target.height / 2 + bounds.height / 2) return true		else return false;
	}
	public function containsPt(target : Pt) : Bool
	{
		if((left <= target.x && target.x <= right) && (back <= target.y && target.y <= front) && (bottom <= target.z && target.z <= top)) 
		{
			return true;
		}
		else return false;
	}
	var _target : IIsoDisplayObject;
	public function new(target : IIsoDisplayObject)
	{
		this._target = target;
	}
}
