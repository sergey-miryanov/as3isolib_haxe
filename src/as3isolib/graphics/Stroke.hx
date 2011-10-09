//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.graphics;

import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

class Stroke implements IStroke
{
	public var weight : Float;
	public var color : Int;
	public var alpha : Float;
	public var usePixelHinting : Bool;
	public var scaleMode : LineScaleMode;
	public var caps : CapsStyle;
	public var joints : JointStyle;
	public var miterLimit : Float;
	public function new(weight : Float, 
						color : Int, 
						alpha : Float = 1.0, 
						usePixelHinting : Bool = false,
						scaleMode : LineScaleMode = null,
						caps : CapsStyle = null, 
						joints : JointStyle = null,
						miterLimit : Float = 0.0)
	{
		if(scaleMode == null)
			scaleMode = LineScaleMode.NORMAL;
		this.weight = weight;
		this.color = color;
		this.alpha = alpha;
		this.usePixelHinting = usePixelHinting;
		this.scaleMode = scaleMode;
		this.caps = caps;
		this.joints = joints;
		this.miterLimit = miterLimit;
	}

	public function apply(target : Graphics) : Void
	{
		target.lineStyle(weight, color, alpha, usePixelHinting, scaleMode, caps, joints, miterLimit);
	}
}
