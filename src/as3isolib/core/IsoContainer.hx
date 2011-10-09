//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.data.INode;
import as3isolib.data.Node;
import as3isolib.events.IsoEvent;
import eDpLib.events.ProxyEvent;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.errors.Error;

using as3isolib.ArrayUtil;

/**
 * IsoContainer is the base class that any isometric object must extend in order to be shown in the display list.
 * Developers should not instantiate this class directly but rather extend it.
 */
class IsoContainer extends Node, implements IIsoContainer
{
	public var includeInLayout(getIncludeInLayout, setIncludeInLayout) : Bool;
	public var displayListChildren(getDisplayListChildren, never) : Array<IIsoContainer>;
	public var isAddedToDisplay(getIsAddedToDisplay, never) : Bool;
	public var isAddedToStage(getIsAddedToStage, never) : Bool;
	public var isInvalidated(getIsInvalidated, never) : Bool;
	public var depth(getDepth, never) : Int;
	public var container(getContainer, never) : Sprite;
	var bIncludeInLayout : Bool;
	var includeInLayoutChanged : Bool;

	public function new()
	{
		bIncludeInLayout = true;
		includeInLayoutChanged = false;
		displayListChildrenArray = new Array<IIsoContainer>();
		super();
		addEventListener(IsoEvent.CHILD_ADDED, child_changeHandler);
		addEventListener(IsoEvent.CHILD_REMOVED, child_changeHandler);
		createChildren();
		proxyTarget = mainContainer;
	}

	public function getIncludeInLayout() : Bool
	{
		return bIncludeInLayout;
	}

	public function setIncludeInLayout(value : Bool) : Bool
	{
		if(bIncludeInLayout != value) 
		{
			bIncludeInLayout = value;
			includeInLayoutChanged = true;
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	DISPLAY LIST CHILDREN
	////////////////////////////////////////////////////////////////////////
	var displayListChildrenArray : Array<IIsoContainer>;

	public function getDisplayListChildren() : Array<IIsoContainer>
	{
		var temp : Array<IIsoContainer> = [];

		for(child in displayListChildrenArray)
			temp.push(child);

		return temp;
	}

	////////////////////////////////////////////////////////////////////////
	//	CHILD METHODS
	////////////////////////////////////////////////////////////////////////

	//	ADD
	////////////////////////////////////////////////////////////////////////
	override public function addChildAt(child : INode, index : Int) : Void
	{
		if(Std.is(child,IIsoContainer)) 
		{
			var c : IIsoContainer = cast child;
			super.addChildAt(child, index);

			if(c.includeInLayout) 
			{
				displayListChildrenArray.push(c);

				if(index > mainContainer.numChildren) 
					index = mainContainer.numChildren;

				//referencing explicit removal of child RTE - http://life.neophi.com/danielr/2007/06/rangeerror_error_2006_the_supp.html
				var p : DisplayObjectContainer = c.container.parent;
				if(p != null && p != mainContainer)
					p.removeChild(c.container);

				mainContainer.addChildAt(c.container, index);
			}
		}
		else 
			throw new Error("parameter child does not implement IContainer.");
	}

	//	SWAP
	////////////////////////////////////////////////////////////////////////

	override public function setChildIndex(child : INode, index : Int) : Void
	{
		if(!Std.is(child,IIsoContainer)) 
			throw new Error("parameter child does not implement IContainer.");

		else if(!child.hasParent || child.parent != this) 
			throw new Error("parameter child is not found within node structure.");

		else 
		{
			super.setChildIndex(child, index);
			var c : IIsoContainer = cast child;
			mainContainer.setChildIndex(c.container, index);
		}
	}

	//	REMOVE
	////////////////////////////////////////////////////////////////////////

	override public function removeChildByID(id : String) : INode
	{
		var child : IIsoContainer = cast super.removeChildByID(id);

		if(child != null && child.includeInLayout) 
		{
			var i : Int = displayListChildrenArray.indexOf(child);

			if(i > -1)
				displayListChildrenArray.splice(i, 1);

			mainContainer.removeChild((cast(child,IIsoContainer)).container);
		}
		return child;
	}

	override public function removeAllChildren() : Void
	{
		for(c in children)
		{
			var child : IIsoContainer = cast c;
			if(child.includeInLayout)
				mainContainer.removeChild(child.container);
		}

		displayListChildrenArray = new Array<IIsoContainer>();

		super.removeAllChildren();
	}

	//	CREATE
	////////////////////////////////////////////////////////////////////////

	/**
	 * Initialization method to create the child IContainer objects.
	 */
	function createChildren() : Void
	{
		//overriden by subclasses
		mainContainer = new Sprite();
		attachMainContainerEventListeners();
		//mainContainer.cacheAsBitmap = true
	}

	/**
	 * Attaches certain listener logic for adding and removing the main container from the stage and display list.
	 * Subclasses of IsoContainer that explicitly set/override the mainContainer (e.g. IsoSprite) should call this class afterwards.
	 */
	function attachMainContainerEventListeners() : Void
	{
		if(mainContainer != null) 
		{
			mainContainer.addEventListener(Event.ADDED, mainContainer_addedHandler, false, 0, true);
			mainContainer.addEventListener(Event.ADDED_TO_STAGE, mainContainer_addedToStageHandler, false, 0, true);
			mainContainer.addEventListener(Event.REMOVED, mainContainer_removedHandler, false, 0, true);
			mainContainer.addEventListener(Event.REMOVED_FROM_STAGE, mainContainer_removedFromStageHandler, false, 0, true);
		}
	}

	///////////////////////////////////////////////////////////////////////
	//	DISPLAY LIST & STAGE LOGIC
	///////////////////////////////////////////////////////////////////////
	var bAddedToDisplayList : Bool;
	var bAddedToStage : Bool;

	public function getIsAddedToDisplay() : Bool
	{
		return bAddedToDisplayList;
	}

	public function getIsAddedToStage() : Bool
	{
		return bAddedToStage;
	}

	function mainContainer_addedHandler(evt : Event) : Void
	{
		bAddedToDisplayList = true;
	}

	function mainContainer_addedToStageHandler(evt : Event) : Void
	{
		bAddedToStage = true;
	}

	function mainContainer_removedHandler(evt : Event) : Void
	{
		bAddedToDisplayList = false;
	}

	function mainContainer_removedFromStageHandler(evt : Event) : Void
	{
		bAddedToStage = false;
	}

	/////////////////////////////////////////////////////////////////
	//	IS INVALIDATED
	/////////////////////////////////////////////////////////////////
	var bIsInvalidated : Bool;
	public function getIsInvalidated() : Bool
	{
		return bIsInvalidated;
	}

	////////////////////////////////////////////////////////////////////////
	//	RENDER
	////////////////////////////////////////////////////////////////////////
	public function render(recursive : Bool = true) : Void
	{
		preRenderLogic();
		renderLogic(recursive);
		postRenderLogic();
	}

	/**
	 * Performs any logic prior to executing actual rendering logic on the IIsoContainer.
	 */
	function preRenderLogic() : Void
	{
		dispatchEvent(new IsoEvent(IsoEvent.RENDER));
	}

	/**
	 * Performs actual rendering logic on the IIsoContainer.
	 *
	 * @param recursive Flag indicating if child objects render upon validation.  Default value is <code>true</code>.
	 */
	function renderLogic(recursive : Bool = true) : Void
	{
		if(includeInLayoutChanged && parentNode != null) 
		{
			var p : IIsoContainer = cast parentNode;
			var i : Int = p.displayListChildren.indexOf(this);

			if(bIncludeInLayout) 
			{
				if(i == -1)
					p.displayListChildren.push(this);
			}

			else if(!bIncludeInLayout) 
			{
				if(i >= 0)
					p.displayListChildren.splice(i, 1);
			}

			mainContainer.visible = bIncludeInLayout; //rather than removing or adding to display list, we leave it be and just leave it to the flash player to maintain

			includeInLayoutChanged = false;
		}

		if(recursive) 
		{
			var child : IIsoContainer;
			for(c in children) {
				child = cast c;
				renderChild(child);
			}
		}
	}

	/**
	 * Performs any logic after executing actual rendering logic on the IIsoContainer.
	 */
	function postRenderLogic() : Void
	{
		dispatchEvent(new IsoEvent(IsoEvent.RENDER_COMPLETE));
	}

	function renderChild(child : IIsoContainer) : Void
	{
		child.render(true);
	}

	function child_changeHandler(evt : Event) : Void
	{
		bIsInvalidated = true;
	}

	////////////////////////////////////////////////////////////////////////
	//	EVENT DISPATCHER PROXY
	////////////////////////////////////////////////////////////////////////
	override public function dispatchEvent(event : Event) : Bool
	{
		if(event.bubbles) 
			return proxyTarget.dispatchEvent(new ProxyEvent(this, event));

		return super.dispatchEvent(event);
	}

	////////////////////////////////////////////////////////////////////////
	//	CONTAINER STRUCTURE
	////////////////////////////////////////////////////////////////////////
	var mainContainer : Sprite;

	public function getDepth() : Int
	{
		if(mainContainer.parent !=null)
			return mainContainer.parent.getChildIndex(mainContainer);

		return -1;
	}

	public function getContainer() : Sprite
	{
		return mainContainer;
	}

}
