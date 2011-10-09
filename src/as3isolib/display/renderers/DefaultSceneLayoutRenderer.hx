//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.core.IIsoContainer;
import as3isolib.core.IsoDisplayObject;
import as3isolib.display.scene.IIsoScene;
#if flash
import flash.utils.TypedDictionary;
#else
typedef Deps = {
	var obj : IsoDisplayObject;
	var depends : Array<IsoDisplayObject>;
};
#end

/**
 * The DefaultSceneLayoutRenderer is the default renderer responsible for performing the isometric position-based depth sorting on the child objects of the target IIsoScene.
 * @TODO haxe IntHash approach is about 9% slower than a TypedDictionary approach
 */
class DefaultSceneLayoutRenderer implements ISceneLayoutRenderer
{
	public var collisionDetection(getCollisionDetection, setCollisionDetection) : IsoDisplayObject->IsoDisplayObject->Int;

	var collisionDetectionFunc : IsoDisplayObject->IsoDisplayObject->Int;
	// It's faster to make class variables & a method, rather than to do a local function closure
	var depth : Int;
	
	var scene : IIsoScene;

#if flash
	var visited : TypedDictionary<IsoDisplayObject,Bool>;
	var dependency : TypedDictionary<IsoDisplayObject,Array<IsoDisplayObject>>;
#else
	var visited : IntHash<Bool>;
	var dependency : IntHash<Deps>;
#end

	public function new() {
		visited = new #if flash TypedDictionary() #else IntHash() #end;
	}

	/**
	 * @TODO Render engine assumes all scene children are DisplayObjects, not Containers
	 */
	public function renderScene(scene : IIsoScene) : Void
	{
		this.scene = scene;
		#if DEBUG_PERFORMANCE
		var startTime:Float = haxe.Timer.stamp();
		#end

		// Rewrite #2 by David Holz, dependency version (naive for now)
		
		// TODO - cache dependencies between frames, only adjust invalidated objects, keeping old ordering as best as possible
		// IIsoDisplayObject -> [obj that should be behind the key]
		dependency = #if flash new TypedDictionary() #else new IntHash() #end;

		// For now, use the non-rearranging display list so that the dependency sort will tend to create similar output each pass
		var children : Array<IIsoContainer> = scene.displayListChildren;

		// Full naive cartesian scan, see what objects are behind child[i]
		// TODO - screen space subdivision to limit dependency scan
		var max : Int = children.length;
		var i : Int = 0;
		while(i < max)
		{
			var behind : Array<IsoDisplayObject> = [];
			var objA : IsoDisplayObject = cast children[i];

			// TODO - direct access ("public var isoX" instead of "function get x") of the object's fields is a TON faster.
			//   Even "final function get" doesn't inline it to direct access, yielding the same speed as plain "function get".
			//   use namespaces to provide raw access?
			//   rename interface class = IsoDisplayObject, concrete class = IsoDisplayObject_impl with public fields?
			
			//var rightA:Number = objA.isoX + objA.isoWidth;
			//var frontA:Number = objA.isoY + objA.isoLength;
			//var topA:Number = objA.isoZ + objA.isoHeight;

			// TODO - getting bounds objects REALLY slows us down, too.  It creates a new one every time you ask for it!
			var rightA : Float = objA.x + objA.width;
			var frontA : Float = objA.y + objA.length;
			var topA : Float = objA.z + objA.height;

			var j : Int = 0;
			while(j < max)
			{
				var objB : IsoDisplayObject = cast children[j];
				if(collisionDetectionFunc != null)
					collisionDetectionFunc(objA, objB);

				// See if B should go behind A
				// simplest possible check, interpenetrations also count as "behind", which does do a bit more work later, but the inner loop tradeoff for a faster check makes up for it
				if( (objB.x < rightA) && 
					(objB.y < frontA) && 
					(objB.z < topA) && 
					(i != j)) 
				{
					behind.push(objB);
				}
				++j;
			}
			#if flash 
				dependency.set(objA, behind);
			#else
				dependency.set(objA.UID, {obj : objA, depends:behind});
			#end
			++i;
		}

		//trace("dependency scan time", getTimer() - startTime, "ms");
		
		// TODO - set the invalidated children first, then do a rescan to make sure everything else is where it needs to be, too?  probably need to order the invalidated children sets from low to high index
		
		// Set the childrens' depth, using dependency ordering
		depth = 0;
		for(o in children) {
			var obj : IsoDisplayObject = cast o;
			#if flash
			if(true != visited.get(obj))
				place(obj);
			#else
			if(true != visited.get(obj.UID))
				place(obj);
			#end
		}

		// Clear out temporary dictionary so we're not retaining memory between calls
		visited = #if flash new TypedDictionary() #else new IntHash() #end;

		// DEBUG OUTPUT
		
		//trace("--------------------");
		//for (i = 0; i < max; ++i)
		//	trace(dumpBounds(sortedChildren[i].isoBounds), dependency[sortedChildren[i]].length);
		#if DEBUG_PERFORMANCE
		trace("scene render time " + Std.string((haxe.Timer.stamp() - startTime) * 1000) + "ms (manual sort)");
		#end
	}

	/**
	 * Dependency-ordered depth placement of the given objects and its dependencies.
	 */
	function place(obj : IsoDisplayObject) : Void
	{
		#if flash
			visited.set(obj, true);
			for(i in dependency.get(obj)) {
				var inner : IsoDisplayObject = i;
				if(true != visited.get(inner)) 
					place(inner);
			}
		#else
			visited.set(obj.UID, true);
			for(i in dependency.get(obj.UID).depends) {
				var inner : IsoDisplayObject = i;
				if(true != visited.get(inner.UID)) 
					place(inner);
			}
		#end
		if(depth != obj.depth) 
		{
			scene.setChildIndex(obj, depth);
		}
		depth++;
	}

	/////////////////////////////////////////////////////////////////
	//	COLLISION DETECTION
	/////////////////////////////////////////////////////////////////
	public function getCollisionDetection() : IsoDisplayObject->IsoDisplayObject->Int
	{
		return collisionDetectionFunc;
	}

	public function setCollisionDetection(value : IsoDisplayObject->IsoDisplayObject->Int) : IsoDisplayObject->IsoDisplayObject->Int
	{
		collisionDetectionFunc = value;
		return value;
	}

}
