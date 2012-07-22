//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display;

import as3isolib.core.IInvalidation;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.geom.Pt;
import flash.display.Sprite;
import flash.events.IEventDispatcher;
import flash.geom.Point;

import as3isolib.display.scene.IIsoScene;

interface IIsoView implements IEventDispatcher, implements IInvalidation
{
	var scenes(getScenes, never) : Array<IIsoScene>;
	var numScenes(getNumScenes, never) : Int;
	var currentPt(getCurrentPt, never) : Pt;
	var currentX(getCurrentX, setCurrentX) : Float;
	var currentY(getCurrentY, setCurrentY) : Float;
	var currentZoom(getCurrentZoom, setCurrentZoom) : Float;
	//var width(none, none) : Float;
	//var height(none, none) : Float;
	var mainContainer(getMainContainer, never) : Sprite;

	function getScenes() : Array<IIsoScene>;
	function getNumScenes() : Int;
	function getCurrentPt() : Pt;
	function getCurrentX() : Float;
	function setCurrentX(value : Float) : Float;
	function getCurrentY() : Float;
	function setCurrentY(value : Float) : Float;
	function localToIso(localPt : Point) : Pt;
	function isoToLocal(isoPt : Pt) : Point;
	function centerOnPt(pt : Pt, isIsometric : Bool = true) : Void;
	function centerOnIso(iso : IIsoDisplayObject) : Void;
	function pan(px : Float, py : Float) : Void;
	function panBy(xBy : Float, yBy : Float) : Void;
	function panTo(xTo : Float, yTo : Float) : Void;
	function getCurrentZoom() : Float;
	function zoom(zFactor : Float) : Void;
	function reset() : Void;
	function render(recursive : Bool = false) : Void;
	function getWidth() : Float;
	function getHeight() : Float;
	function getMainContainer() : Sprite;
}
