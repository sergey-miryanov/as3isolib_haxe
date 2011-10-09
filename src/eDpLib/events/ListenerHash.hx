//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package eDpLib.events;

class ListenerHash
{
	public var listeners : Array<Dynamic->Void>;

	public function new() {
		listeners = new Array();
	}

	public function addListener(listener : Dynamic->Void) : Void
	{
		if(!contains(listener)) 
			listeners.push(listener);
	}

	public function removeListener(listener : Dynamic->Void) : Void
	{
		if(contains(listener)) 
		{
			var i : Int = 0;
			var m : Int = listeners.length;
			while(i < m)
			{
				if(listener == listeners[i]) break;
				i++;
			}
			listeners.splice(i, 1);
		}
	}

	public function contains(listener : Dynamic->Void) : Bool
	{
		for(func in listeners)
		{
			if(func == listener) return true;
		}
		return false;
	}
}
