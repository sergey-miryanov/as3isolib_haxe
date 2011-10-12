//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.bounds.IBounds;
import as3isolib.data.RenderData;
import flash.display.DisplayObject;
import flash.geom.Rectangle;

interface IIsoDisplayObject implements IIsoContainer
{
	var usePreciseValues : Bool;
	var renderAsOrphan(getRenderAsOrphan, setRenderAsOrphan) : Bool;
	var isoBounds(getIsoBounds, never) : IBounds;
	var screenBounds(getScreenBounds, never) : Rectangle;
	var inverseOriginX(getInverseOriginX, never) : Float;
	var inverseOriginY(getInverseOriginY, never) : Float;
	var isAnimated(getIsAnimated, setIsAnimated) : Bool;
	var x(getX, setX) : Float;
	var y(getY, setY) : Float;
	var z(getZ, setZ) : Float;
	var screenX(getScreenX, never) : Float;
	var screenY(getScreenY, never) : Float;
	var distance(getDistance, setDistance) : Float;
	var width(getWidth, setWidth) : Float;
	var length(getLength, setLength) : Float;
	var height(getHeight, setHeight) : Float;
	function getRenderData() : RenderData;
	function getRenderAsOrphan() : Bool;
	function setRenderAsOrphan(value : Bool) : Bool;
	function getIsoBounds() : IBounds;
	function getScreenBounds() : Rectangle;
	function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle;
	function getInverseOriginX() : Float;
	function getInverseOriginY() : Float;
	function moveTo(x : Float, y : Float, z : Float) : Void;
	function moveBy(x : Float, y : Float, z : Float) : Void;
	function getIsAnimated() : Bool;
	function setIsAnimated(value : Bool) : Bool;
	function getX() : Float;
	function setX(value : Float) : Float;
	function getY() : Float;
	function setY(value : Float) : Float;
	function getZ() : Float;
	function setZ(value : Float) : Float;
	function getScreenX() : Float;
	function getScreenY() : Float;
	function getDistance() : Float;
	function setDistance(value : Float) : Float;
	function setSize(width : Float, length : Float, height : Float) : Void;
	function getWidth() : Float;
	function setWidth(value : Float) : Float;
	function getLength() : Float;
	function setLength(value : Float) : Float;
	function getHeight() : Float;
	function setHeight(value : Float) : Float;
	function invalidatePosition() : Void;
	function invalidateSize() : Void;
	function clone() : Dynamic;
}
