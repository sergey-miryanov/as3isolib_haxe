//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.geom.transformations;

import as3isolib.geom.Pt;

interface IAxonometricTransformation
{
	function screenToSpace(screenPt : Pt) : Pt;
	function spaceToScreen(spacePt : Pt) : Pt;
}
