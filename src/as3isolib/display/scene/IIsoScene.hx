//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.bounds.IBounds;
import as3isolib.core.IIsoContainer;
import flash.display.DisplayObjectContainer;

interface IIsoScene implements IIsoContainer
{
	var isoBounds(getIsoBounds, never) : IBounds;
	var invalidatedChildren(getInvalidatedChildren, never) : Array<IIsoContainer>;
	var hostContainer(getHostContainer, setHostContainer) : DisplayObjectContainer;
	function getIsoBounds() : IBounds;
	function getInvalidatedChildren() : Array<IIsoContainer>;
	function getHostContainer() : DisplayObjectContainer;
	function setHostContainer(value : DisplayObjectContainer) : DisplayObjectContainer;
}
