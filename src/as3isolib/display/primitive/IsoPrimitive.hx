//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display.primitive;

import as3isolib.core.IsoDisplayObject;
import as3isolib.enums.RenderStyleType;
import as3isolib.events.IsoEvent;
import as3isolib.graphics.IFill;
import as3isolib.graphics.IStroke;
import as3isolib.graphics.SolidColorFill;
import as3isolib.graphics.Stroke;
import flash.errors.Error;

/**
 * IsoPrimitive is the base class for primitive-type classes that will make great use of Flash's drawing API.
 * Developers should not directly instantiate this class but rather extend it or one of the other primitive-type subclasses.
 */
class IsoPrimitive extends IsoDisplayObject, implements IIsoPrimitive
{
	static inline public var DEFAULT_WIDTH : Float = 25.0;
	static inline public var DEFAULT_LENGTH : Float = 25.0;
	static inline public var DEFAULT_HEIGHT : Float = 25.0;

	static var DEFAULT_FILL : IFill = new SolidColorFill(0xFFFFFF, 1);
	public static var DEFAULT_STROKE : IStroke = new Stroke(0, 0x000000);

	public var styleType(getStyleType, setStyleType) : String;
	public var profileStroke(getProfileStroke, setProfileStroke) : IStroke;
	public var fill(getFill, setFill) : IFill;
	public var fills(getFills, setFills) : Array<IFill>;
	public var stroke(getStroke, setStroke) : IStroke;
	public var strokes(getStrokes, setStrokes) : Array<IStroke>;

	var edgesArray : Array<IStroke>;
	var fillsArray : Array<IFill>;
	var renderStyle : String;
	var pStroke : IStroke;
	var bSytlesInvalidated : Bool;

	public function getStyleType() : String
	{
		return renderStyle;
	}

	public function setStyleType(value : String) : String
	{
		if(renderStyle != value) 
		{
			renderStyle = value;
			invalidateStyles();
			if(autoUpdate) render();
		}
		return value;
	}

	//////////////////////////////
	//	MATERIALS
	//////////////////////////////

		//	PROFILE STROKE
		//////////////////////////////

	public function getProfileStroke() : IStroke
	{
		return pStroke;
	}

	public function setProfileStroke(value : IStroke) : IStroke
	{
		if(pStroke != value) 
		{
			pStroke = value;
			invalidateStyles();

			if(autoUpdate)
				render();
		}
		return value;
	}

		//	MAIN FILL
		//////////////////////////////

	public function getFill() : IFill
	{
		return fills[0];
	}

	public function setFill(value : IFill) : IFill
	{
		fills = [value, value, value, value, value, value];
		return value;
	}

		//	FILLS
		//////////////////////////////

	public function getFills() : Array<IFill>
	{
		var temp : Array<IFill> = [];
		for(f in fillsArray)
			temp.push(f);

		return temp;
	}

	public function setFills(value : Array<IFill>) : Array<IFill>
	{
		if(value != null)
			fillsArray = value;
		else
			fillsArray = new Array<IFill>();

		invalidateStyles();

		if(autoUpdate)
			render();
		return value;
	}

		//	MAIN STROKE
		//////////////////////////////

	public function getStroke() : IStroke
	{
		return strokes[0];
	}

	public function setStroke(value : IStroke) : IStroke
	{
		strokes = [value, value, value, value, value, value];
		return value;
	}

		//	STROKES
		//////////////////////////////

	public function getStrokes() : Array<IStroke>
	{
		var temp : Array<IStroke> = [];
		for(s in edgesArray)
			temp.push(s);

		return temp;
	}

	public function setStrokes(value : Array<IStroke>) : Array<IStroke>
	{
		if(value != null)
			edgesArray = (value)
		else 
			edgesArray = new Array<IStroke>();

		invalidateStyles();

		if(autoUpdate)
			render();

		return value;
	}

	/////////////////////////////////////////////////////////
	//	RENDER
	/////////////////////////////////////////////////////////

	override function renderLogic(recursive : Bool = true) : Void
	{
		if(!hasParent && !renderAsOrphan)
			return;

		//we do this before calling super.render() so as to only perform drawing logic for the size or style invalidation, not both.
		if(bSizeInvalidated || bSytlesInvalidated) 
		{
			if(!validateGeometry())
				throw new Error("validation of geometry failed.");

			drawGeometry();
			validateSize();

			bSizeInvalidated = false;
			bSytlesInvalidated = false;
		}

		super.renderLogic(recursive);
	}

	/////////////////////////////////////////////////////////
	//	VALIDATION
	/////////////////////////////////////////////////////////

	/**
	 * For IIsoDisplayObject that make use of Flash's drawing API, validation of the geometry must occur before being rendered.
	 * 
	 * @return Boolean Flag indicating if the geometry is valid.
	 */
	function validateGeometry() : Bool
	{
		//overridden by subclasses
		return true;
	}

	function drawGeometry() : Void
	{
		//overridden by subclasses
	}

	////////////////////////////////////////////////////////////
	//	INVALIDATION
	////////////////////////////////////////////////////////////

	public function invalidateStyles() : Void
	{
		bSytlesInvalidated = true;

		if(!bInvalidateEventDispatched) 
		{
			dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
			bInvalidateEventDispatched = true;
		}
	}

	override public function getIsInvalidated() : Bool
	{
		return (bSizeInvalidated || bPositionInvalidated || bSytlesInvalidated);
	}

	////////////////////////////////////////////////////////////
	//	CLONE
	////////////////////////////////////////////////////////////

	override public function clone() : Dynamic
	{
		var cloneInstance : IIsoPrimitive = cast super.clone();
		cloneInstance.fills = fills;
		cloneInstance.strokes = strokes;
		cloneInstance.styleType = styleType;

		return cloneInstance;
	}

	public function new(descriptor : Dynamic)
	{
		renderStyle = RenderStyleType.SOLID;
		fillsArray = new Array<IFill>();
		edgesArray = new Array<IStroke>();
		bSytlesInvalidated = false;

		super(descriptor);

		if(!descriptor) 
		{
			width = DEFAULT_WIDTH;
			length = DEFAULT_LENGTH;
			height = DEFAULT_HEIGHT;
		}
;
	}
}
