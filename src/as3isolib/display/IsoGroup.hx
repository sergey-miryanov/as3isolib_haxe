//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display;

import as3isolib.bounds.IBounds;
import as3isolib.bounds.PrimitiveBounds;
import as3isolib.bounds.SceneBounds;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.core.IsoDisplayObject;
import as3isolib.core.as3isolib_internal;
import as3isolib.display.renderers.ISceneLayoutRenderer;
import as3isolib.display.renderers.SimpleSceneLayoutRenderer;
import as3isolib.display.scene.IIsoScene;
import flash.display.DisplayObjectContainer;

class IsoGroup extends IsoDisplayObject, implements IIsoScene
{
	public var hostContainer(getHostContainer, setHostContainer) : DisplayObjectContainer;
	public var invalidatedChildren(getInvalidatedChildren, none) : Array<Dynamic>;
	public function new(descriptor : Object)
	{
		renderer = new SimpleSceneLayoutRenderer();
		super(descriptor);
	}
	public function getHostContainer() : DisplayObjectContainer
	{
		return null;
	}
	public function setHostContainer(value : DisplayObjectContainer) : DisplayObjectContainer
	{
		{ };
	}
	public function getInvalidatedChildren() : Array<Dynamic>
	{
		var a : Array<Dynamic>;
		var child : IIsoDisplayObject;
		for(child in children)
		{
			if(child.isInvalidated) a.push(child);
		}
;
		return a;
	}
	override public function getIsoBounds() : IBounds
	{
		return if(bSizeSetExplicitly) new PrimitiveBounds(this)		else new SceneBounds(this);
	}
	var bSizeSetExplicitly : Bool;
	override public function setWidth(value : Float) : Float
	{
		super.width = value;
		bSizeSetExplicitly = !isNaN(value);
	}
	override public function setLength(value : Float) : Float
	{
		super.length = value;
		bSizeSetExplicitly = !isNaN(value);
	}
	override public function setHeight(value : Float) : Float
	{
		super.height = value;
		bSizeSetExplicitly = !isNaN(value);
	}
	public var renderer : ISceneLayoutRenderer;
	override function renderLogic(recursive : Bool) : Void
	{
		super.renderLogic(recursive);
		if(bIsInvalidated) 
		{
			if(!bSizeSetExplicitly) calculateSizeFromChildren();
			if(!renderer) renderer = new SimpleSceneLayoutRenderer();
			renderer.renderScene(this);
			bIsInvalidated = false;
		}
;
	}
	function calculateSizeFromChildren() : Void
	{
		var b : IBounds = new SceneBounds(this);
		isoWidth = b.width;
		isoLength = b.length;
		isoHeight = b.height;
	}
}
