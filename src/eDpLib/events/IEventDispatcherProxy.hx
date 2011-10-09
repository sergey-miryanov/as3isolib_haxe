//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package eDpLib.events;

import flash.events.IEventDispatcher;

interface IEventDispatcherProxy implements IEventDispatcher
{
	var proxy(getProxy, setProxy) : IEventDispatcher;
	var proxyTarget(getProxyTarget, setProxyTarget) : IEventDispatcher;
	function getProxy() : IEventDispatcher;
	function setProxy(value : IEventDispatcher) : IEventDispatcher;
	function getProxyTarget() : IEventDispatcher;
	function setProxyTarget(value : IEventDispatcher) : IEventDispatcher;
}
