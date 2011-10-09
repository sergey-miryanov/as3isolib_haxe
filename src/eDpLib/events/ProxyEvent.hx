//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package eDpLib.events;

import flash.events.Event;
import flash.events.IEventDispatcher;

/**
* ProxyEvent allows a proxy to redispatch event information on behalf of a IEventDispatcher not directly accessible through the display list.
*/
class ProxyEvent extends Event
{
	/**
	 * The original event being proxied for.
	 */
	public var targetEvent : Event;
	/**
	 * The proxy object dispatching on behalf of the original event's target.
	 */
	public var proxy : IEventDispatcher;
	/**
	 * The original event target who is being proxied for.
	 */
	public var proxyTarget : IEventDispatcher;

	/**
	 * Constructor
	 * 
	 * @param proxy The proxy object dispatching on behalf of the original event's target.
	 * @param targetEvt The original event being proxied for.
	 */
	public function new(proxy : IEventDispatcher, targetEvt : Event)
	{
		super(targetEvt.type, targetEvt.bubbles, targetEvt.cancelable);
		this.proxy = proxy;
		this.proxyTarget = Reflect.hasField(proxy,"proxyTarget") ?
			Reflect.field(proxy, "proxyTarget") : null;
		this.targetEvent = targetEvt;
	}

	/**
	* Just another accessor for the proxy property.
	*/
#if flash9
	@:getter(target) function get_target() : {} {
		return proxy;
	}
#else
	override function get_target() : Dynamic {
		return proxy;
	}
#end

	override public function clone() : Event
	{
		return new ProxyEvent(proxy, targetEvent);
	}
}
