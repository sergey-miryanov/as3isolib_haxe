//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.graphics;

import flash.display.Graphics;

interface IFill
{
	function begin(target : Graphics) : Void;
	function end(target : Graphics) : Void;
	function clone() : IFill;
}
