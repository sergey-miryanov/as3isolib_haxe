//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.events;

import flash.events.Event;

class IsoEvent extends Event
{
	static inline public var INVALIDATE : String = "as3isolib_invalidate";
	static inline public var RENDER : String = "as3isolib_render";
	static inline public var RENDER_COMPLETE : String = "as3isolib_renderComplete";
	static inline public var MOVE : String = "as3isolib_move";
	static inline public var RESIZE : String = "as3isolib_resize";
	static inline public var CHILD_ADDED : String = "as3isolib_childAdded";
	static inline public var CHILD_REMOVED : String = "as3isolib_childRemoved";

	public var propName : String;
	public var oldValue : Dynamic;
	public var newValue : Dynamic;

	public function new(type : String, bubbles : Bool=false, cancelable : Bool=false)
	{
		super(type, bubbles, cancelable);
	}

	override public function clone() : Event
	{
		var evt : IsoEvent = new IsoEvent(type, bubbles, cancelable);
		evt.propName = propName;
		evt.oldValue = oldValue;
		evt.newValue = newValue;
		return evt;
	}
}
