//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.errors;

class IsoError extends Error
{
	public var info : String;
	public var data : Object;
	public function new(message : String, info : String, data : Object)
	{
		super(message);
		this.info = info;
		this.data = data;
	}
}
