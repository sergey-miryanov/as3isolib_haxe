//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.graphics;

import flash.geom.Matrix;

interface IBitmapFill implements IFill
{
	var matrix(getMatrix, setMatrix) : Matrix;
	var repeat(getRepeat, setRepeat) : Bool;
	function getMatrix() : Matrix;
	function setMatrix(value : Matrix) : Matrix;
	function getRepeat() : Bool;
	function setRepeat(value : Bool) : Bool;
}
