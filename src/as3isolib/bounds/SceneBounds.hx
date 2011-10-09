//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.bounds;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.scene.IIsoScene;
import as3isolib.geom.Pt;

class SceneBounds implements IBounds
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
	public var excludeAnimatedChildren(getExcludeAnimatedChildren, setExcludeAnimatedChildren) : Bool;
	public function getVolume() : Float
	{
		return width * length * height;
	}
	public function getWidth() : Float
	{
		return _right - _left;
	}
	public function getLength() : Float
	{
		return _front - _back;
	}
	public function getHeight() : Float
	{
		return _top - _bottom;
	}
	var _left : Float;
	public function getLeft() : Float
	{
		return _left;
	}
	var _right : Float;
	public function getRight() : Float
	{
		return _right;
	}
	var _back : Float;
	public function getBack() : Float
	{
		return _back;
	}
	var _front : Float;
	public function getFront() : Float
	{
		return _front;
	}
	var _bottom : Float;
	public function getBottom() : Float
	{
		return _bottom;
	}
	var _top : Float;
	public function getTop() : Float
	{
		return _top;
	}
	public function getCenterPt() : Pt
	{
		var pt : Pt = new Pt();
		pt.x = (_right - _left) / 2;
		pt.y = (_front - _back) / 2;
		pt.z = (_top - _bottom) / 2;
		return pt;
	}
	public function getPts() : Array<Pt>
	{
		var a : Array<Pt> = [];
		a.push(new Pt(_left, _back, _bottom));
		a.push(new Pt(_right, _back, _bottom));
		a.push(new Pt(_right, _front, _bottom));
		a.push(new Pt(_left, _front, _bottom));
		a.push(new Pt(_left, _back, _top));
		a.push(new Pt(_right, _back, _top));
		a.push(new Pt(_right, _front, _top));
		a.push(new Pt(_left, _front, _top));
		return a;
	}
	public function intersects(bounds : IBounds) : Bool
	{
		return false;
	}
	public function containsPt(target : Pt) : Bool
	{
		if((_left <= target.x && target.x <= _right) && (_back <= target.y && target.y <= _front) && (_bottom <= target.z && target.z <= _top)) 
		{
			return true;
		}
		else return false;
	}
	var _target : IIsoScene;
	public function new(target : IIsoScene)
	{
		_left = Math.NaN;
		_right = Math.NaN;
		_back = Math.NaN;
		_front = Math.NaN;
		_bottom = Math.NaN;
		_top = Math.NaN;
		excludeAnimated = false;
		this._target = target;
		calculateBounds();
	}
	var excludeAnimated : Bool;
	public function getExcludeAnimatedChildren() : Bool
	{
		return excludeAnimated;
	}
	public function setExcludeAnimatedChildren(value : Bool) : Bool
	{
		excludeAnimated = value;
		calculateBounds();
		return value;
	}
	function calculateBounds() : Void
	{
		for(c in _target.displayListChildren)
		{
			if(Std.is(c, IIsoDisplayObject)) {
				var child : IIsoDisplayObject = cast c;
				if(excludeAnimated && child.isAnimated) continue;
				if(Math.isNaN(_left) || child.isoBounds.left < _left) _left = child.isoBounds.left;
				if(Math.isNaN(_right) || child.isoBounds.right > _right) _right = child.isoBounds.right;
				if(Math.isNaN(_back) || child.isoBounds.back < _back) _back = child.isoBounds.back;
				if(Math.isNaN(_front) || child.isoBounds.front > _front) _front = child.isoBounds.front;
				if(Math.isNaN(_bottom) || child.isoBounds.bottom < _bottom) _bottom = child.isoBounds.bottom;
				if(Math.isNaN(_top) || child.isoBounds.top > _top) _top = child.isoBounds.top;
			} else {
				throw "Unknown type here";
			}
		}

		if(Math.isNaN(_left)) _left = 0;
		if(Math.isNaN(_right)) _right = 0;
		if(Math.isNaN(_back)) _back = 0;
		if(Math.isNaN(_front)) _front = 0;
		if(Math.isNaN(_bottom)) _bottom = 0;
		if(Math.isNaN(_top)) _top = 0;
	}

}
