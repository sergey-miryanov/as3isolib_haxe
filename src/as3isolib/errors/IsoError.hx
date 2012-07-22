//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.errors;

import flash.errors.Error;

class IsoError extends Error
{
	public var info : String;
	public var data : Dynamic;
	public function new(message : String, info : String, data : Dynamic)
	{
		super(message);
		this.info = info;
		this.data = data;
	}
}
