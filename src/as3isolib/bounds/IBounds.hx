//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.bounds;

import as3isolib.geom.Pt;

interface IBounds
{
	var width(getWidth, never) : Float;
	var length(getLength, never) : Float;
	var height(getHeight, never) : Float;
	var left(getLeft, never) : Float;
	var right(getRight, never) : Float;
	var back(getBack, never) : Float;
	var front(getFront, never) : Float;
	var bottom(getBottom, never) : Float;
	var top(getTop, never) : Float;
	var centerPt(getCenterPt, never) : Pt;
	function getWidth() : Float;
	function getLength() : Float;
	function getHeight() : Float;
	function getLeft() : Float;
	function getRight() : Float;
	function getBack() : Float;
	function getFront() : Float;
	function getBottom() : Float;
	function getTop() : Float;
	function getCenterPt() : Pt;
	function getPts() : Array<Pt>;
	function intersects(bounds : IBounds) : Bool;
	function containsPt(target : Pt) : Bool;
}
