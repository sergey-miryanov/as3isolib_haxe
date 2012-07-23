//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.scene;

import as3isolib.bounds.IBounds;
import as3isolib.bounds.SceneBounds;
import as3isolib.core.ClassFactory;
import as3isolib.core.IFactory;
import as3isolib.core.IIsoContainer;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.core.IsoContainer;
import as3isolib.data.INode;
import as3isolib.display.renderers.DefaultSceneLayoutRenderer;
import as3isolib.display.renderers.ISceneLayoutRenderer;
import as3isolib.display.renderers.ISceneRenderer;
import as3isolib.events.IsoEvent;
import flash.display.DisplayObjectContainer;

import flash.errors.Error;

using as3isolib.ArrayUtil;

class IsoScene extends IsoContainer, implements IIsoScene
{
	public var isoBounds(getIsoBounds, never) : IBounds;
	public var hostContainer(getHostContainer, setHostContainer) : DisplayObjectContainer;
	public var invalidatedChildren(getInvalidatedChildren, never) : Array<IIsoContainer>;
	public var layoutRenderer(getLayoutRenderer, setLayoutRenderer) : Dynamic;
	public var styleRenderers(getStyleRenderers, setStyleRenderers) : Iterable <ISceneLayoutRenderer>;

	var _isoBounds : IBounds;
	public function getIsoBounds() : IBounds
	{
		return new SceneBounds(this);
	}

	var host : DisplayObjectContainer;
	public function getHostContainer() : DisplayObjectContainer
	{
		return host;
	}

	public function setHostContainer(value : DisplayObjectContainer) : DisplayObjectContainer
	{
		if(value != null && host != value) 
		{
			if(host != null && host.contains(container)) 
			{
				host.removeChild(container);
				ownerObject = null;
			}
			else if(hasParent) parent.removeChild(this);
			host = value;
			if(host != null) 
			{
				host.addChild(container);
				ownerObject = host;
				parentNode = null;
			}
		}
		return value;
	}

	var invalidatedChildrenArray : Array<IIsoContainer>;
	public function getInvalidatedChildren() : Array<IIsoContainer>
	{
		return invalidatedChildrenArray;
	}

	override public function addChildAt(child : INode, index : Int) : Void
	{
		if(Std.is(child, IIsoDisplayObject)) 
		{
			super.addChildAt(child, index);
			child.addEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			bIsInvalidated = true;
		}
		else throw new Error("parameter child is not of type IIsoDisplayObject");
	}

	override public function setChildIndex(child : INode, index : Int) : Void
	{
		super.setChildIndex(child, index);
		bIsInvalidated = true;
	}

	override public function removeChildByID(id : String) : INode
	{
		var child : INode = super.removeChildByID(id);
		if(child != null) 
		{
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			bIsInvalidated = true;
		}
		return child;
	}

	override public function removeAllChildren() : Void
	{
		var child : INode;
		for(child in children)
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
		super.removeAllChildren();
		bIsInvalidated = true;
	}

	function child_invalidateHandler(evt : IsoEvent) : Void
	{
		var child = evt.target;
		if(invalidatedChildrenArray.indexOf(child) == -1)
			invalidatedChildrenArray.push(child);
		bIsInvalidated = true;
	}

	public var layoutEnabled : Bool;
	var bLayoutIsFactory : Bool;
	var layoutObject : Dynamic;

	public function getLayoutRenderer() : Dynamic
	{
		return layoutObject;
	}

	public function setLayoutRenderer(value : Dynamic) : Dynamic
	{
		if(!value) 
		{
			layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
			bLayoutIsFactory = true;
			bIsInvalidated = true;
		}
		if(value && layoutObject != value) 
		{
			if(Std.is(value, IFactory)) bLayoutIsFactory = true;
			else if(Std.is(value,ISceneLayoutRenderer)) bLayoutIsFactory = false;
			else throw new Error("value for layoutRenderer is not of type IFactory or ISceneLayoutRenderer");
			layoutObject = value;
			bIsInvalidated = true;
		}
	}

	public var stylingEnabled : Bool;
	var styleRendererFactories : Iterable <ISceneLayoutRenderer>;

	public function getStyleRenderers() : Iterable <ISceneLayoutRenderer>
	{
		return styleRendererFactories;
	}

	public function setStyleRenderers(value : Iterable <ISceneLayoutRenderer>) : Iterable <ISceneLayoutRenderer>
	{
		if(value != null) styleRendererFactories = value;
		else styleRendererFactories = null;
		bIsInvalidated = true;
		return value;
	}

	public function invalidateScene() : Void
	{
		bIsInvalidated = true;
	}

	override function renderLogic(recursive : Bool = true) : Void
	{
		super.renderLogic(recursive);
		if(bIsInvalidated) 
		{
			if(layoutEnabled) 
			{
				var sceneLayoutRenderer : ISceneLayoutRenderer;
				if(bLayoutIsFactory) 
					sceneLayoutRenderer = (cast(layoutObject,IFactory)).newInstance();
				else 
					sceneLayoutRenderer = cast layoutObject;
				if(sceneLayoutRenderer != null)
					sceneLayoutRenderer.renderScene(this);
			}
			if(stylingEnabled && !Lambda.empty (styleRendererFactories))
			{
				mainContainer.graphics.clear();
				for(sceneRenderer in styleRendererFactories)
				{
					if(sceneRenderer != null)
						sceneRenderer.renderScene(this);
				}
			}
			bIsInvalidated = false;
		}
	}

	override function postRenderLogic() : Void
	{
		invalidatedChildrenArray = [];
		super.postRenderLogic();
		sceneRendered();
	}

	function sceneRendered() : Void
	{
	}

	public function new()
	{
		invalidatedChildrenArray = [];
		layoutEnabled = true;
		bLayoutIsFactory = true;
		stylingEnabled = true;
		styleRendererFactories = new Array<ISceneLayoutRenderer>();
		super();
		layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
	}
}
