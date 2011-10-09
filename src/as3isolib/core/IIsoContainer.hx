//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.data.INode;
import flash.display.Sprite;

interface IIsoContainer implements INode, implements IInvalidation
{
	var includeInLayout(getIncludeInLayout, setIncludeInLayout) : Bool;
	var displayListChildren(getDisplayListChildren, never) : Array<IIsoContainer>;
	var depth(getDepth, never) : Int;
	var container(getContainer, never) : Sprite;
	function getIncludeInLayout() : Bool;
	function setIncludeInLayout(value : Bool) : Bool;
	function getDisplayListChildren() : Array<IIsoContainer>;
	function getDepth() : Int;
	function getContainer() : Sprite;
	function render(recursive : Bool = true) : Void;
}
