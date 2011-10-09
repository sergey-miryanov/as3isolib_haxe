//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.graphics;

import as3isolib.enum.IsoOrientation;
import as3isolib.utils.IsoDrawingUtil;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedSuperclassName;

class BitmapFill implements IBitmapFill
{
	public var source(getSource, setSource) : Object;
	public var orientation(getOrientation, setOrientation) : Object;
	public var colorTransform(getColorTransform, setColorTransform) : ColorTransform;
	public var matrix(getMatrix, setMatrix) : Matrix;
	public var repeat(getRepeat, setRepeat) : Bool;
	public function new(source : Object, orientation : Object, matrix : Matrix, colorTransform : ColorTransform, repeat : Bool, smooth : Bool)
	{
		this.source = source;
		this.orientation = orientation;
		if(matrix) this.matrix = matrix;
		this.colorTransform = colorTransform;
		this.repeat = repeat;
		this.smooth = smooth;
	}
	var bitmapData : BitmapData;
	var sourceObject : Object;
	public function getSource() : Object
	{
		return sourceObject;
	}
	public function setSource(value : Object) : Object
	{
		sourceObject = value;
		if(bitmapData) 
		{
			bitmapData.dispose();
			bitmapData = null;
		}
;
		var tempSprite : DisplayObject;
		if(value is BitmapData) 
		{
			bitmapData = BitmapData(value);
			return;
		}
;
		if(value is Class) 
		{
			var classInstance : Class<Dynamic> = Class(value);
			if(getQualifiedSuperclassName(classInstance) == "flash.display::BitmapData") 
			{
				bitmapData = new classInstance(1, 1);
				return;
			}
			else tempSprite = new classInstance();
		}
		else if(value is Bitmap) bitmapData = Bitmap(value).bitmapData		else if(value is DisplayObject) tempSprite = DisplayObject(value)		else if(value is String) 
		{
			classInstance = Class(getDefinitionByName(String(value)));
			if(classInstance) tempSprite = new classInstance();
		}
		else return;
		if(!bitmapData && tempSprite) 
		{
			if(tempSprite.width > 0 && tempSprite.height > 0) 
			{
				bitmapData = new BitmapData(tempSprite.width, tempSprite.height);
				bitmapData.draw(tempSprite, new Matrix(), cTransform);
			}
;
		}
;
		if(cTransform) bitmapData.colorTransform(bitmapData.rect, cTransform);
	}
	var _orientation : Object;
	public function getOrientation() : Object
	{
		return _orientation;
	}
	var _orientationMatrix : Matrix;
	public function setOrientation(value : Object) : Object
	{
		_orientation = value;
		if(!value) return;
		if(value is String) 
		{
			if(value == IsoOrientation.XY || value == IsoOrientation.XZ || value == IsoOrientation.YZ) _orientationMatrix = IsoDrawingUtil.getIsoMatrix(value as String)			else _orientationMatrix = null;
		}
		else if(value is Matrix) _orientationMatrix = Matrix(value)		else throw new Error("value is not of type String or Matrix");
	}
	var cTransform : ColorTransform;
	public function getColorTransform() : ColorTransform
	{
		return cTransform;
	}
	public function setColorTransform(value : ColorTransform) : ColorTransform
	{
		cTransform = value;
		if(bitmapData && cTransform) bitmapData.colorTransform(bitmapData.rect, cTransform);
	}
	var matrixObject : Matrix;
	public function getMatrix() : Matrix
	{
		return matrixObject;
	}
	public function setMatrix(value : Matrix) : Matrix
	{
		matrixObject = value;
	}
	var bRepeat : Bool;
	public function getRepeat() : Bool
	{
		return bRepeat;
	}
	public function setRepeat(value : Bool) : Bool
	{
		bRepeat = value;
	}
	public var smooth : Bool;
	public function begin(target : Graphics) : Void
	{
		var m : Matrix = new Matrix();
		if(_orientationMatrix) m.concat(_orientationMatrix);
		if(matrix) m.concat(matrix);
		target.beginBitmapFill(bitmapData, m, repeat, smooth);
	}
	public function end(target : Graphics) : Void
	{
		target.endFill();
	}
	public function clone() : IFill
	{
		return new BitmapFill(source, orientation, matrix, colorTransform, repeat, smooth);
	}
}
