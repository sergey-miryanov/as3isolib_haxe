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
import flash.utils.getTimer;

class SceneBlittingRenderer implements ISceneRenderer
{
	public var target(getTarget, setTarget) : Object;
	var _targetBitmap : Bitmap;
	var _targetObject : Object;
	public function getTarget() : Object
	{
		return _targetObject;
	}
	public function setTarget(value : Object) : Object
	{
		if(_targetObject != value) 
		{
			_targetObject = value;
			if(_targetObject is Bitmap) _targetBitmap = Bitmap(_targetObject)			else if(_targetObject.hasOwnProperty("bitmap")) _targetBitmap = Bitmap(_targetObject.bitmap)			else throw new IsoError("");
		}
;
	}
	public var view : IIsoView;
	public function renderScene(scene : IIsoScene) : Void
	{
		if(!_targetBitmap) return;
		var sortedChildren : Array<Dynamic> = scene.displayListChildren.slice();
		sortedChildren.sort(isoDepthSort);
		var child : IIsoDisplayObject;
		var i : UInt;
		var m : UInt = sortedChildren.length;
		while(i < m)
		{
			child = IIsoDisplayObject(sortedChildren[i]);
			if(child.depth != i) scene.setChildIndex(child, i);
			i++;
		}
;
		var offsetMatrix : Matrix = new Matrix();
		offsetMatrix.tx = view.width / 2 - view.currentX;
		offsetMatrix.ty = view.height / 2 - view.currentY;
		var sceneBitmapData : BitmapData = new BitmapData(view.width, view.height, true, 0);
		sceneBitmapData.draw(scene.container, offsetMatrix);
		if(_targetBitmap.bitmapData) _targetBitmap.bitmapData.dispose();
		_targetBitmap.bitmapData = sceneBitmapData;
	}
	function isoDepthSort(childA : Object, childB : Object) : Int
	{
		var boundsA : IBounds = childA.isoBounds;
		var boundsB : IBounds = childB.isoBounds;
		if(boundsA.right <= boundsB.left) return -1		else if(boundsA.left >= boundsB.right) return 1		else if(boundsA.front <= boundsB.back) return -1		else if(boundsA.back >= boundsB.front) return 1		else if(boundsA.top <= boundsB.bottom) return -1		else if(boundsA.bottom >= boundsB.top) return 1		else return 0;
	}
}
