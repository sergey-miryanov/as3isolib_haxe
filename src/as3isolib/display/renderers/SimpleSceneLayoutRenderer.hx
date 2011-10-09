//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.scene.IIsoScene;

class SimpleSceneLayoutRenderer implements ISceneLayoutRenderer
{
	public var collisionDetection(getCollisionDetection, setCollisionDetection) : Function;
	public var sortOnProps : Array<Dynamic>;
	public function renderScene(scene : IIsoScene) : Void
	{
		var children : Array<Dynamic> = scene.displayListChildren.slice();
		children.sortOn(sortOnProps, Array.NUMERIC);
		var child : IIsoDisplayObject;
		var i : UInt;
		var m : UInt = children.length;
		while(i < m)
		{
			child = IIsoDisplayObject(children[i]);
			if(child.depth != i) scene.setChildIndex(child, i);
			i++;
		}
;
	}
	var collisionDetectionFunc : Function;
	public function getCollisionDetection() : Function
	{
		return collisionDetectionFunc;
	}
	public function setCollisionDetection(value : Function) : Function
	{
		collisionDetectionFunc = value;
	}
}
