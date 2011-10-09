//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import flash.events.IEventDispatcher;

class ClassFactory implements as3isolib.core.IFactory
{
	public var baseClass : Class<Dynamic>;
	public var properties : Dynamic;
	public var eventListenerDescriptors : Array<EventListenerDescriptor>;

	public function new(baseClass : Class<Dynamic>, properties = null)
	{
		this.baseClass = baseClass;
		this.properties = properties;
	}

	public function newInstance() : Dynamic
	{
		var instance : Dynamic = Type.createInstance(baseClass,[]);

		if(properties != null) 
			for(p in Reflect.fields(properties))
				Reflect.setField(instance, p, Reflect.field(properties,p));

		if(Std.is(instance, IEventDispatcher)) 
			for(descriptor in eventListenerDescriptors)
				(cast(instance,IEventDispatcher)).addEventListener(descriptor.type, descriptor.listener, descriptor.useCapture, descriptor.priority, descriptor.useWeakReference);

		return instance;
	}
}
