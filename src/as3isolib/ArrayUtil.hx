//
// (c) 2011 haxeports. See LICENSE
//

package as3isolib;

class ArrayUtil {

	public static function indexOf(a:Array<Dynamic>, key:Dynamic) : Int {
		for(i in 0...a.length)
			if(a[i] == key)
				return i;
		return -1;
	}
}