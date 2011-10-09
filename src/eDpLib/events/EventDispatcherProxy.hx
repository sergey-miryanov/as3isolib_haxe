//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//
package eDpLib.events;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

class EventDispatcherProxy implements IEventDispatcher, implements IEventDispatcherProxy
{
	public var proxyTarget(getProxyTarget, setProxyTarget) : IEventDispatcher;
	public var proxy(getProxy, setProxy) : IEventDispatcher;
	public var interceptedEventTypes(getInterceptedEventTypes, setInterceptedEventTypes) : Array<String>;
	public var deleteQueueAfterUpdate : Bool;
	var _proxyTarget : IEventDispatcher;

	public function getProxyTarget() : IEventDispatcher
	{
		return _proxyTarget;
	}

	public function setProxyTarget(value : IEventDispatcher) : IEventDispatcher
	{
		if(_proxyTarget != value) 
		{
			_proxyTarget = value;
			updateProxyListeners();
		}
		return value;
	}

	var _proxy : IEventDispatcher;
	public function getProxy() : IEventDispatcher
	{
		return _proxy;
	}

	public function setProxy(target : IEventDispatcher) : IEventDispatcher
	{
		if(_proxy != target) 
		{
			_proxy = target;
			eventDispatcher = new EventDispatcher(_proxy);
		}
		return target;
	}

	public function new()
	{
		listenerHashTable = new Hash();
		interceptedEventHash = new Hash();
		deleteQueueAfterUpdate = true;
		_proxyTargetListenerQueue = [];
		proxy = this;
		interceptedEventTypes = generateEventTypes();
	}

	var listenerHashTable : Hash<ListenerHash>;
	function setListenerHashProperty(type : String, listener : Dynamic->Void) : Void
	{
		var hash : ListenerHash;
		if(!listenerHashTable.exists(type)) 
		{
			hash = new ListenerHash();
			hash.addListener(listener);
			listenerHashTable.set(type, hash);
		}
		else 
		{
			hash = listenerHashTable.get(type);
			hash.addListener(listener);
		}
	}

	function hasListenerHashProperty(type : String) : Bool
	{
		return listenerHashTable.exists(type);
	}

	function getListenersForEventType(type : String) : Array<Dynamic->Void>
	{
		if(listenerHashTable.exists(type))
			return listenerHashTable.get(type).listeners
		else return [];
	}

	function removeListenerHashProperty(type : String, listener : Dynamic->Void) : Bool
	{
		if(listenerHashTable.exists(type)) 
		{
			var hash : ListenerHash = listenerHashTable.get(type);
			hash.removeListener(listener);
			return true;
		}
		return false;
	}
	var interceptedEventHash : Hash<String>;
	public function getInterceptedEventTypes() : Array<String>
	{
		var a : Array<String> = [];
		var p : Dynamic;
		for(p in interceptedEventHash)
			a.push(p);
		return a;
	}
	public function setInterceptedEventTypes(value : Array<String>) : Array<String>
	{
		var hash : Hash<String> = new Hash();
		for(type in value)
			hash.set(type, type);
		interceptedEventHash = hash;
		return value;
	}
	function generateEventTypes() : Array<String>
	{
		var evtTypes : Array<String> = [Event.ADDED, Event.ADDED_TO_STAGE, Event.ENTER_FRAME, Event.REMOVED, Event.REMOVED_FROM_STAGE, Event.RENDER, Event.TAB_CHILDREN_CHANGE, Event.TAB_ENABLED_CHANGE, Event.TAB_INDEX_CHANGE, FocusEvent.FOCUS_IN, FocusEvent.FOCUS_OUT, FocusEvent.KEY_FOCUS_CHANGE, FocusEvent.MOUSE_FOCUS_CHANGE, MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_WHEEL, MouseEvent.ROLL_OUT, MouseEvent.ROLL_OVER, KeyboardEvent.KEY_DOWN, KeyboardEvent.KEY_UP];
		return evtTypes;
	}
	function checkForInteceptedEventType(type : String) : Bool
	{
		return interceptedEventHash.exists(type);
	}
	function eventDelegateFunction(evt : Event) : Void
	{
		evt.stopImmediatePropagation();
		var pEvt : ProxyEvent = new ProxyEvent(proxy, evt);
		pEvt.proxyTarget = proxyTarget;
		var func : EventDispatcherProxy->ProxyEvent->Void;
		var listeners : Array<Dynamic->Void>;
		if(hasListenerHashProperty(evt.type)) 
		{
			listeners = getListenersForEventType(evt.type);
			for(func in listeners)
				//func(this, pEvt); xxx
				func(pEvt);
		}
	}

	function updateProxyListeners() : Void
	{
		var queueItem : Dynamic;
		for(queueItem in _proxyTargetListenerQueue)proxyTarget.addEventListener(queueItem.type, eventDelegateFunction, queueItem.useCapture, queueItem.priority, queueItem.useWeakReference);
		if(deleteQueueAfterUpdate) _proxyTargetListenerQueue = [];
	}

	var _proxyTargetListenerQueue : Array<Dynamic>;
	var eventDispatcher : EventDispatcher;

	public function hasEventListener(type : String) : Bool
	{
		if(checkForInteceptedEventType(type)) 
		{
			if(proxyTarget != null) return proxyTarget.hasEventListener(type)			else return false;
		}
		else return eventDispatcher.hasEventListener(type);
	}

	public function willTrigger(type : String) : Bool
	{
		if(checkForInteceptedEventType(type)) 
		{
			if(proxyTarget != null) return proxyTarget.willTrigger(type)
			else return false;
		}
		else return eventDispatcher.willTrigger(type);
	}

	public function addEventListener(type : String, listener : Dynamic->Void, useCapture : Bool=false, priority : Int=0, useWeakReference : Bool=false) : Void
	{
		if(checkForInteceptedEventType(type)) 
		{
			setListenerHashProperty(type, listener);
			if(proxyTarget != null)
				proxyTarget.addEventListener(type, eventDelegateFunction, useCapture, priority, useWeakReference)
			else 
			{
				var queueItem = {
					type : type,
					useCapture : useCapture,
					priority : priority,
					useWeakReference : useWeakReference,

				};
				_proxyTargetListenerQueue.push(queueItem);
			}
		}
		else 
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public function removeEventListener(type : String, listener : Dynamic->Void, useCapture : Bool=false) : Void
	{
		if(checkForInteceptedEventType(type)) 
		{
			if(hasListenerHashProperty(type)) 
			{
				removeListenerHashProperty(type, listener);
				if(proxyTarget == null) 
				{
					var quequeItem : Dynamic;
					var i : Int = 0;
					var l : Int = _proxyTargetListenerQueue.length;
					while(i < l)
					{
						quequeItem = _proxyTargetListenerQueue[i];
						if(quequeItem.type == type) 
						{
							_proxyTargetListenerQueue.splice(i, 1);
							return;
						}
						i++;
					}
				}
			}
		}
		else eventDispatcher.removeEventListener(type, listener, useCapture);
	}

	public function dispatchEvent(event : Event) : Bool
	{
		if(event.bubbles || checkForInteceptedEventType(event.type)) 
			return proxyTarget.dispatchEvent(new ProxyEvent(this, event))
		else return eventDispatcher.dispatchEvent(event);
	}
}
