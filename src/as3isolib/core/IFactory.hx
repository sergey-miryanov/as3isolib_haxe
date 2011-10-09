//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

interface IFactory
{
	var baseClass : Class<Dynamic>;
	var properties : Dynamic;
	var eventListenerDescriptors : Array<EventListenerDescriptor>;

	function newInstance() : Dynamic;
}
