//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.core;

import as3isolib.bounds.IBounds;
import as3isolib.bounds.PrimitiveBounds;
import as3isolib.data.RenderData;
import as3isolib.events.IsoEvent;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class IsoDisplayObject extends IsoContainer, implements IIsoDisplayObject
{
	public var isAnimated(getIsAnimated, setIsAnimated) : Bool;
	public var isoBounds(getIsoBounds, never) : IBounds;
	public var screenBounds(getScreenBounds, never) : Rectangle;
	public var inverseOriginX(getInverseOriginX, never) : Float;
	public var inverseOriginY(getInverseOriginY, never) : Float;
	public var x(getX, setX) : Float;
	public var screenX(getScreenX, never) : Float;
	public var y(getY, setY) : Float;
	public var screenY(getScreenY, never) : Float;
	public var z(getZ, setZ) : Float;
	public var distance(getDistance, setDistance) : Float;
	public var width(getWidth, setWidth) : Float;
	public var length(getLength, setLength) : Float;
	public var height(getHeight, setHeight) : Float;
	public var renderAsOrphan(getRenderAsOrphan, setRenderAsOrphan) : Bool;
	var cachedRenderData : RenderData;

	//////////////////////////////////////////////////////////////////
	//	GET RENDER DATA
	//////////////////////////////////////////////////////////////////
	/**
	 * @TODO Serious hack for NME
	 */
	public function getRenderData() : RenderData
	{
		var r : Rectangle = #if (flash || js) mainContainer.getBounds(mainContainer) #else mainContainer.nmeGetPixelBounds() #end; // todo nme needs a real getBounds()
		if(isInvalidated || cachedRenderData==null) 
		{
			var flag : Bool = bRenderAsOrphan; //set to allow for rendering regardless of hierarchy
			bRenderAsOrphan = true;

			render(true);

#if neko
			var fillColor = {a : 0, rgb : 0};
#else
			var fillColor = 0;
#end
			var bd : BitmapData = new BitmapData(Std.int(r.width) + 1, Std.int(r.height) + 1, true, fillColor);
			bd.draw(mainContainer, new Matrix(1, 0, 0, 1, -r.left, -r.top));

			var renderData : RenderData = new RenderData();
			renderData.x = mainContainer.x + r.left;
			renderData.y = mainContainer.y + r.top;
			renderData.bitmapData = bd;

			cachedRenderData = renderData;
			bRenderAsOrphan = flag; //set back to original
		}
		else 
		{
			cachedRenderData.x = mainContainer.x + r.left;
			cachedRenderData.y = mainContainer.y + r.top;
		}

		return cachedRenderData;
	}

	////////////////////////////////////////////////////////////////////////
	//	IS ANIMATED
	////////////////////////////////////////////////////////////////////////

	var _isAnimated : Bool;

	public function getIsAnimated() : Bool
	{
		return _isAnimated;
	}

	public function setIsAnimated(value : Bool) : Bool
	{
		_isAnimated = value;
		//mainContainer.cacheAsBitmap = value;
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	BOUNDS
	////////////////////////////////////////////////////////////////////////

	var isoBoundsObject : IBounds;

	public function getIsoBounds() : IBounds
	{
		if(isoBoundsObject == null || isInvalidated)
			isoBoundsObject = new PrimitiveBounds(this);

		return isoBoundsObject;
	}

	/**
	 * @TODO Serious hack for NME
	 */
	public function getScreenBounds() : Rectangle
	{
		var screenBounds : Rectangle = #if (flash || js) mainContainer.getBounds(mainContainer) #else mainContainer.nmeGetPixelBounds() #end; // todo nme needs a real getBounds()
		screenBounds.x += mainContainer.x;
		screenBounds.y += mainContainer.y;

		return screenBounds;
	}

	public function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle
	{
		var rect : Rectangle = screenBounds;

		var pt : Point = new Point(rect.x, rect.y);
		pt = (cast(parent,IIsoContainer)).container.localToGlobal(pt);
		pt = targetCoordinateSpace.globalToLocal(pt);

		rect.x = pt.x;
		rect.y = pt.y;

		return rect;
	}

	public function getInverseOriginX() : Float
	{
		return IsoMath.isoToScreen(new Pt(x + width, y + length, z)).x;
	}

	public function getInverseOriginY() : Float
	{
		return IsoMath.isoToScreen(new Pt(x + width, y + length, z)).y;
	}

	/////////////////////////////////////////////////////////
	//	POSITION
	/////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////
	//	X, Y, Z
	////////////////////////////////////////////////////////////////////////

	public function moveTo(x : Float, y : Float, z : Float) : Void
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function moveBy(x : Float, y : Float, z : Float) : Void
	{
		this.x += x;
		this.y += y;
		this.z += z;
	}

	////////////////////////////////////////////////////////////////////////
	//	USE PRECISE VALUES
	////////////////////////////////////////////////////////////////////////

	/**
	 * Flag indicating if positional and dimensional values are rounded to the nearest whole number or not.
	 */
	public var usePreciseValues : Bool;

	////////////////////////////////////////////////////////////////////////
	//	X
	////////////////////////////////////////////////////////////////////////

	/**
	 * @private
	 *
	 * The positional value based on the isometric x-axis.
	 */
	var isoX : Float;
	var oldX : Float;

	// xxx TODO was marked as [Bindable("move")] in original
	public function getX() : Float
	{
		return isoX;
	}

	public function setX(value : Float) : Float
	{
		if(!usePreciseValues) 
			value = Math.round(value);

		if(isoX != value) 
		{
			oldX = isoX;

			isoX = value;
			invalidatePosition();

			if(autoUpdate)
				render();
		}
		return value;
	}

	public function getScreenX() : Float
	{
		return IsoMath.isoToScreen(new Pt(x, y, z)).x;
	}

	////////////////////////////////////////////////////////////////////////
	//	Y
	////////////////////////////////////////////////////////////////////////

	var isoY : Float;
	var oldY : Float;

	public function getY() : Float
	{
		return isoY;
	}

	// xxx TODO marked [Bindable("move")] in original
	public function setY(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		if(isoY != value) 
		{
			oldY = isoY;

			isoY = value;
			invalidatePosition();

			if(autoUpdate)
				render();
		}
		return value;
	}

	public function getScreenY() : Float
	{
		return IsoMath.isoToScreen(new Pt(x, y, z)).y;
	}

	////////////////////////////////////////////////////////////////////////
	//	Z
	////////////////////////////////////////////////////////////////////////

	var isoZ : Float;
	var oldZ : Float;

	public function getZ() : Float
	{
		return isoZ;
	}

	public function setZ(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		if(isoZ != value) 
		{
			oldZ = isoZ;

			isoZ = value;
			invalidatePosition();

			if(autoUpdate)
				render();
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	DISTANCE
	////////////////////////////////////////////////////////////////////////
		
	var dist : Float;

	public function getDistance() : Float
	{
		return dist;
	}

	public function setDistance(value : Float) : Float
	{
		dist = value;
		return value;
	}

	/////////////////////////////////////////////////////////
	//	GEOMETRY
	/////////////////////////////////////////////////////////

	public function setSize(width : Float, length : Float, height : Float) : Void
	{
		this.width = width;
		this.length = length;
		this.height = height;
	}


	////////////////////////////////////////////////////////////////////////
	//	WIDTH
	////////////////////////////////////////////////////////////////////////

	var isoWidth : Float;
	var oldWidth : Float;

	public function getWidth() : Float
	{
		return isoWidth;
	}

	public function setWidth(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		value = Math.abs(value);

		if(isoWidth != value) 
		{
			oldWidth = isoWidth;

			isoWidth = value;
			invalidateSize();

			if(autoUpdate)
				render();
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	LENGTH
	////////////////////////////////////////////////////////////////////////

	var isoLength : Float;
	var oldLength : Float;

	public function getLength() : Float
	{
		return isoLength;
	}

	public function setLength(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		value = Math.abs(value);

		if(isoLength != value) 
		{
			oldLength = isoLength;

			isoLength = value;
			invalidateSize();

			if(autoUpdate)
				render();
		}
		return value;
	}

	////////////////////////////////////////////////////////////////////////
	//	HEIGHT
	////////////////////////////////////////////////////////////////////////

	var isoHeight : Float;
	var oldHeight : Float;

	public function getHeight() : Float
	{
		return isoHeight;
	}

	public function setHeight(value : Float) : Float
	{
		if(!usePreciseValues)
			value = Math.round(value);

		value = Math.abs(value);
		if(isoHeight != value) 
		{
			oldHeight = isoHeight;

			isoHeight = value;
			invalidateSize();

			if(autoUpdate)
				render();
		}
		return value;
	}

	/////////////////////////////////////////////////////////
	//	RENDER AS ORPHAN
	/////////////////////////////////////////////////////////

	var bRenderAsOrphan : Bool;

	public function getRenderAsOrphan() : Bool
	{
		return bRenderAsOrphan;
	}

	public function setRenderAsOrphan(value : Bool) : Bool
	{
		bRenderAsOrphan = value;
		return value;
	}

	/////////////////////////////////////////////////////////
	//	RENDERING
	/////////////////////////////////////////////////////////

	/**
	 * Flag indicating whether a property change will automatically trigger a render phase.
	 */
	public var autoUpdate : Bool;

	override function renderLogic(recursive : Bool = true) : Void
	{
		if(!hasParent && !renderAsOrphan)
			return;

		if(bPositionInvalidated) 
		{
			validatePosition();
			bPositionInvalidated = false;
		}

		if(bSizeInvalidated) 
		{
			validateSize();
			bSizeInvalidated = false;
		}

		//set the flag back for the next time we invalidate the object
		bInvalidateEventDispatched = false;

		super.renderLogic(recursive);
	}

	////////////////////////////////////////////////////////////////////////
	//	INCLUDE LAYOUT
	////////////////////////////////////////////////////////////////////////
	
	/**
	 * @inheritDoc
	 */
	/* override public function set includeInLayout (value:Boolean):void
	   {
	   super.includeInLayout = value;
	   if (includeInLayoutChanged)
	   {
	   if (!bInvalidateEventDispatched)
	   {
	   dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
	   bInvalidateEventDispatched = true;
	   }
	   }
	 } */

	/////////////////////////////////////////////////////////
	//	VALIDATION
	/////////////////////////////////////////////////////////

	/**
	 * Takes the given 3D isometric coordinates and positions them in cartesian coordinates relative to the parent container.
	 */
	function validatePosition() : Void
	{
		var pt : Pt = new Pt(x, y, z);
		IsoMath.isoToScreen(pt);

		mainContainer.x = pt.x;
		mainContainer.y = pt.y;

		var evt : IsoEvent = new IsoEvent(IsoEvent.MOVE, true);
		evt.propName = "position";
		evt.oldValue = { x : oldX, y : oldY, z : oldZ };
		evt.newValue = { x : isoX, y : isoY, z : isoZ };

		dispatchEvent(evt);
	}

	/**
	 * Takes the given 3D isometric sizes and performs the necessary rendering logic.
	 */
	function validateSize() : Void
	{
		var evt : IsoEvent = new IsoEvent(IsoEvent.RESIZE, true);
		evt.propName = "size";
		evt.oldValue = {
			width : oldWidth,
			length : oldLength,
			height : oldHeight,
		};
		evt.newValue = {
			width : isoWidth,
			length : isoLength,
			height : isoHeight,
		};
		dispatchEvent(evt);
	}

	/////////////////////////////////////////////////////////
	//	INVALIDATION
	/////////////////////////////////////////////////////////

	/**
	 * @private
	 *
	 * Flag indicated that an IsoEvent.INVALIDATE has already been dispatched, negating the need to dispatch another.
	 */
	var bInvalidateEventDispatched : Bool;

	var bPositionInvalidated : Bool;

	var bSizeInvalidated : Bool;

	public function invalidatePosition() : Void
	{
		bPositionInvalidated = true;
		if(!bInvalidateEventDispatched) 
		{
			dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
			bInvalidateEventDispatched = true;
		}
	}

	public function invalidateSize() : Void
	{
		bSizeInvalidated = true;
		if(!bInvalidateEventDispatched) 
		{
			dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
			bInvalidateEventDispatched = true;
		}
	}

	override public function getIsInvalidated() : Bool
	{
		return (bPositionInvalidated || bSizeInvalidated);
	}

	/////////////////////////////////////////////////////////
	//	CREATE CHILDREN
	/////////////////////////////////////////////////////////

	override function createChildren() : Void
	{
		super.createChildren();
		mainContainer.cacheAsBitmap = _isAnimated;
	}

	/////////////////////////////////////////////////////////
	//	CLONE
	/////////////////////////////////////////////////////////

	public function clone() : Dynamic
	{
		//var CloneClass : Class<Dynamic> = getDefinitionByName(getQualifiedClassName(this)) as Class;
		//var cloneInstance : IIsoDisplayObject = new CloneClass();
		var CloneClass : Class<IsoDisplayObject> = Type.getClass(this);
		var cloneInstance : IIsoDisplayObject = Type.createInstance(CloneClass,[]);
		cloneInstance.setSize(isoWidth, isoLength, isoHeight);

		return cloneInstance;
	}

	function createObjectFromDescriptor(descriptor : Dynamic) : Void
	{
		var prop : String;
		for(prop in Reflect.fields(descriptor))
		{
			if(Reflect.hasField(this, prop)) 
				Reflect.setField(this, prop, Reflect.field(descriptor,prop));
		}
	}

	public function new(descriptor : Dynamic = null)
	{
		_isAnimated = false;
		usePreciseValues = false;
		isoX = 0;
		isoY = 0;
		isoZ = 0;
		isoWidth = 0;
		isoLength = 0;
		isoHeight = 0;
		bRenderAsOrphan = false;
		autoUpdate = false;
		bInvalidateEventDispatched = false;
		bPositionInvalidated = false;
		bSizeInvalidated = false;

		super();

		if(descriptor) 
			createObjectFromDescriptor(descriptor);
	}
}
