//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;

interface IIsoPrimitive implements IIsoDisplayObject
{
	var styleType(getStyleType, setStyleType) : String;
	var fill(getFill, setFill) : IFill;
	var fills(getFills, setFills) : Array<IFill>;
	var stroke(getStroke, setStroke) : IStroke;
	var strokes(getStrokes, setStrokes) : Array<IStroke>;
	function getStyleType() : String;
	function setStyleType(value : String) : String;
	function getFill() : IFill;
	function setFill(value : IFill) : IFill;
	function getFills() : Array<IFill>;
	function setFills(value : Array<IFill>) : Array<IFill>;
	function getStroke() : IStroke;
	function setStroke(value : IStroke) : IStroke;
	function getStrokes() : Array<IStroke>;
	function setStrokes(value : Array<IStroke>) : Array<IStroke>;
	function invalidateStyles() : Void;
}
