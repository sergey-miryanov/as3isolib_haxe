//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

class EventListenerDescriptor
{
	public var type : String;
	public var listener : Dynamic->Void;
	public var useCapture : Bool;
	public var priority : Int;
	public var useWeakReference : Bool;
}
