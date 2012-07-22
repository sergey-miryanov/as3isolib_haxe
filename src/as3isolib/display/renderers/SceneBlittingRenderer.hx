//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.renderers;

import as3isolib.bounds.IBounds;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.IIsoView;
import as3isolib.display.scene.IIsoScene;
import as3isolib.errors.IsoError;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

class SceneBlittingRenderer implements ISceneRenderer
{
	public var target(getTarget, setTarget) : Dynamic;
	var _targetBitmap : Bitmap;
	var _targetObject : Dynamic;
	public function getTarget() : Dynamic
	{
		return _targetObject;
	}
	public function setTarget(value : Dynamic) : Dynamic
	{
		if(_targetObject != value) 
		{
			_targetObject = value;
			if (Std.is (_targetObject, Bitmap))
			{
				_targetBitmap = cast (_targetObject, Bitmap);
			}
			else if(Reflect.hasField (_targetObject, "bitmap"))
			{
				_targetBitmap = cast (_targetObject.bitmap, Bitmap);
			}
			else
				throw new IsoError("", "", null);
		}
;
	}
	public var view : IIsoView;
	public function renderScene(scene : IIsoScene) : Void
	{
		if(_targetBitmap == null)
			return;

		var sortedChildren : Array<Dynamic> = scene.displayListChildren.slice(0);
		sortedChildren.sort(isoDepthSort);
		var child : IIsoDisplayObject;
		var i : Int = 0;
		var m : Int = sortedChildren.length;
		while(i < m)
		{
			child = cast (sortedChildren[i], IIsoDisplayObject);
			if(child.depth != i) scene.setChildIndex(child, i);
			i++;
		}
;
		var offsetMatrix : Matrix = new Matrix();
		offsetMatrix.tx = view.getWidth () / 2 - view.currentX;
		offsetMatrix.ty = view.getHeight () / 2 - view.currentY;
		var sceneBitmapData : BitmapData = new BitmapData(Std.int (view.getWidth ()),
				Std.int (view.getHeight ()),
				true, 0);

		sceneBitmapData.draw(scene.container, offsetMatrix);
		if(_targetBitmap.bitmapData != null)
			_targetBitmap.bitmapData.dispose();

		_targetBitmap.bitmapData = sceneBitmapData;
	}
	function isoDepthSort(childA : Dynamic, childB : Dynamic) : Int
	{
		var boundsA : IBounds = childA.isoBounds;
		var boundsB : IBounds = childB.isoBounds;
		if(boundsA.right <= boundsB.left) return -1		else if(boundsA.left >= boundsB.right) return 1		else if(boundsA.front <= boundsB.back) return -1		else if(boundsA.back >= boundsB.front) return 1		else if(boundsA.top <= boundsB.bottom) return -1		else if(boundsA.bottom >= boundsB.top) return 1		else return 0;
	}
}
