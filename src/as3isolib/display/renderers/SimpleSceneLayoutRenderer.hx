//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.core.IIsoDisplayObject;
import as3isolib.core.IIsoContainer;
import as3isolib.core.IsoDisplayObject;
import as3isolib.display.scene.IIsoScene;

class SimpleSceneLayoutRenderer implements ISceneLayoutRenderer
{
	public var collisionDetection(getCollisionDetection, setCollisionDetection) : IsoDisplayObject -> IsoDisplayObject -> Int;
	public var sorter : IIsoContainer -> IIsoContainer -> Int;

	public function new ()
	{
		sorter = null;
	}

	public function renderScene(scene : IIsoScene) : Void
	{
		var children = scene.displayListChildren;
		if (sorter != null)
		{
			children.sort (sorter);
		}

		var i : Int = 0;
		var m : Int = children.length;
		while(i < m)
		{
			var child = children[i];
			if(child.depth != i)
				scene.setChildIndex(child, i);

			i++;
		};
	}
	var collisionDetectionFunc : IsoDisplayObject -> IsoDisplayObject -> Int;
	public function getCollisionDetection() : IsoDisplayObject -> IsoDisplayObject -> Int
	{
		return collisionDetectionFunc;
	}
	public function setCollisionDetection(value : IsoDisplayObject -> IsoDisplayObject -> Int) : IsoDisplayObject -> IsoDisplayObject -> Int
	{
		collisionDetectionFunc = value;
		return value;
	}
}
