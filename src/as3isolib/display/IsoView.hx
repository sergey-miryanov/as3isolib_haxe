//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display;

import as3isolib.core.IFactory;
import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.renderers.IViewRenderer;
import as3isolib.display.scene.IIsoScene;
import as3isolib.events.IsoEvent;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.errors.Error;

using as3isolib.ArrayUtil;

class IsoView extends Sprite, implements IIsoView
{
	public var currentPt(getCurrentPt, never) : Pt;
	public var currentX(getCurrentX, setCurrentX) : Float;
	public var currentY(getCurrentY, setCurrentY) : Float;
	public var isInvalidated(getIsInvalidated, never) : Bool;
	public var currentZoom(getCurrentZoom, setCurrentZoom) : Float;
	public var viewRenderers(getViewRenderers, setViewRenderers) : Array<Dynamic>;
	public var scenes(getScenes, never) : Array<IIsoScene>;
	public var numScenes(getNumScenes, never) : Int;
	public var size(getSize, never) : Point;
	public var clipContent(getClipContent, setClipContent) : Bool;
	public var rangeOfMotionTarget(getRangeOfMotionTarget, setRangeOfMotionTarget) : DisplayObject;
	public var mainContainer(getMainContainer, never) : Sprite;
	public var backgroundContainer(getBackgroundContainer, never) : Sprite;
	public var foregroundContainer(getForegroundContainer, never) : Sprite;
	public var showBorder(getShowBorder, setShowBorder) : Bool;
	public var usePreciseValues : Bool;
	var targetScreenPt : Pt;
	var currentScreenPt : Pt;

	public function getCurrentPt() : Pt
	{
		return cast currentScreenPt.clone();
	}
	public function getCurrentX() : Float
	{
		return currentScreenPt.x;
	}
	public function setCurrentX(value : Float) : Float
	{
		if(currentScreenPt.x != value) 
		{
			if(targetScreenPt == null)
				targetScreenPt = cast currentScreenPt.clone();
			targetScreenPt.x = usePreciseValues ? value : Math.round(value);
			bPositionInvalidated = true;
			if(autoUpdate) render();
		}
		return value;
	}

	public function getCurrentY() : Float
	{
		return currentScreenPt.y;
	}
	public function setCurrentY(value : Float) : Float
	{
		if(currentScreenPt.y != value) 
		{
			if(targetScreenPt == null)
				targetScreenPt = cast currentScreenPt.clone();
			targetScreenPt.y = usePreciseValues ? value : Math.round(value);
			bPositionInvalidated = true;
			if(autoUpdate) render();
		}
		return value;
	}
	public function localToIso(localPt : Point) : Pt
	{
		localPt = localToGlobal(localPt);
		localPt = mainContainer.globalToLocal(localPt);
		return IsoMath.screenToIso(new Pt(localPt.x, localPt.y, 0));
	}
	public function isoToLocal(isoPt : Pt) : Point
	{
		isoPt = IsoMath.isoToScreen(isoPt);
		var temp : Point = new Point(isoPt.x, isoPt.y);
		temp = mainContainer.localToGlobal(temp);
		return globalToLocal(temp);
	}
	var bPositionInvalidated : Bool;
	public function getIsInvalidated() : Bool
	{
		return bPositionInvalidated;
	}
	public function invalidatePosition() : Void
	{
		bPositionInvalidated = true;
	}
	public function getInvalidatedScenes() : Array<IIsoScene>
	{
		var a : Array<IIsoScene> = [];
		for(scene in scenesArray)
		{
			if(scene.isInvalidated) a.push(scene);
		}
		return a;
	}
	public function render(recursive : Bool = false) : Void
	{
		preRenderLogic();
		renderLogic(recursive);
		postRenderLogic();
	}
	function preRenderLogic() : Void
	{
		dispatchEvent(new IsoEvent(IsoEvent.RENDER));
	}
	function renderLogic(recursive : Bool = true) : Void
	{
		if(bPositionInvalidated) 
		{
			validatePosition();
			bPositionInvalidated = false;
		}
		if(recursive) 
		{
			var scene : IIsoScene;
			for(scene in scenesArray)scene.render(recursive);
		}
		if(viewRenderers != null && numScenes > 0) 
		{
			var viewRenderer : IViewRenderer;
			var factory : IFactory;
			for(factory in viewRendererFactories)
			{
				viewRenderer = factory.newInstance();
				viewRenderer.renderView(this);
			}
		}
	}
	function postRenderLogic() : Void
	{
		dispatchEvent(new IsoEvent(IsoEvent.RENDER_COMPLETE));
	}

	/**
	 * @TODO serious hack for NME
	 */
	function validatePosition() : Void
	{
		var dx : Float = currentScreenPt.x - targetScreenPt.x;
		var dy : Float = currentScreenPt.y - targetScreenPt.y;
		if(limitRangeOfMotion && romTarget != null) 
		{
			var ndx : Float = 0;
			var ndy : Float = 0;
			var rect : Rectangle = #if (flash || js) romTarget.getBounds(this) #else romTarget.nmeGetPixelBounds() #end; // todo nme needs a real getBounds()
			var isROMBigger : Bool = !romBoundsRect.containsRect(rect);
			if(isROMBigger) 
			{
				if(dx > 0) ndx = Math.min(dx, Math.abs(rect.left))				else ndx = -1 * Math.min(Math.abs(dx), Math.abs(rect.right - romBoundsRect.right));
				if(dy > 0) ndy = Math.min(dy, Math.abs(rect.top))				else ndy = -1 * Math.min(Math.abs(dy), Math.abs(rect.bottom - romBoundsRect.bottom));
			}
			targetScreenPt.x = targetScreenPt.x + dx - ndx;
			targetScreenPt.y = targetScreenPt.y + dy - ndy;
			dx = ndx;
			dy = ndy;
		}
		mContainer.x += dx;
		mContainer.y += dy;
		var evt : IsoEvent = new IsoEvent(IsoEvent.MOVE);
		evt.propName = "currentPt";
		evt.oldValue = currentScreenPt;
		currentScreenPt = cast targetScreenPt.clone();
		evt.newValue = currentScreenPt;
		dispatchEvent(evt);
	}
	public var autoUpdate : Bool;
	public function centerOnPt(pt : Pt, isIsometrc : Bool = true) : Void
	{
		var target : Pt = cast pt.clone();
		if(isIsometrc)
			IsoMath.isoToScreen(target);

		if(!usePreciseValues) 
		{
			target.x = Math.round(target.x);
			target.y = Math.round(target.y);
			target.z = Math.round(target.z);
		}
		targetScreenPt = target;
		bPositionInvalidated = true;
		render();
	}
	public function centerOnIso(iso : IIsoDisplayObject) : Void
	{
		centerOnPt(iso.isoBounds.centerPt);
	}
	public function pan(px : Float, py : Float) : Void
	{
		panBy(px, py);
	}
	public function panBy(xBy : Float, yBy : Float) : Void
	{
		targetScreenPt = cast currentScreenPt.clone();
		targetScreenPt.x += xBy;
		targetScreenPt.y += yBy;
		bPositionInvalidated = true;
		render();
	}
	public function panTo(xTo : Float, yTo : Float) : Void
	{
		targetScreenPt = new Pt(xTo, yTo);
		bPositionInvalidated = true;
		render();
	}
	public function getCurrentZoom() : Float
	{
		return zoomContainer.scaleX;
	}
	public function setCurrentZoom(value : Float) : Float
	{
		zoomContainer.scaleX = zoomContainer.scaleY = value;
		return value;
	}
	public function zoom(zFactor : Float) : Void
	{
		zoomContainer.scaleX = zoomContainer.scaleY = zFactor;
	}
	public function reset() : Void
	{
		zoomContainer.scaleX = zoomContainer.scaleY = 1;
		setSize(_w, _h);
		mContainer.x = 0;
		mContainer.y = 0;
		currentScreenPt = new Pt();
	}
	var viewRendererFactories : Array<Dynamic>;
	public function getViewRenderers() : Array<Dynamic>
	{
		return viewRendererFactories;
	}
	public function setViewRenderers(value : Array<Dynamic>) : Array<Dynamic>
	{
		if(value != null) 
		{
			var temp : Array<Dynamic> = [];
			for(obj in value)
			{
				if(Std.is(obj, IFactory))
					temp.push(obj);
			}
			viewRendererFactories = temp;
			bPositionInvalidated = true;
			if(autoUpdate) render();
		}
		else viewRendererFactories = [];
		return value;
	}
	var scenesArray : Array<IIsoScene>;
	public function getScenes() : Array<IIsoScene>
	{
		return scenesArray;
	}
	public function getNumScenes() : Int
	{
		return scenesArray.length;
	}
	public function addScene(scene : IIsoScene) : Void
	{
		addSceneAt(scene, scenesArray.length);
	}
	public function addSceneAt(scene : IIsoScene, index : Int) : Void
	{
		if(!containsScene(scene)) 
		{
			scenesArray.insert(index, scene);
			scene.hostContainer = null;
			sceneContainer.addChildAt(scene.container, index);
		}
		else throw new Error("IsoView instance already contains parameter scene");
	}
	public function containsScene(scene : IIsoScene) : Bool
	{
		var childScene : IIsoScene;
		for(childScene in scenesArray)
		{
			if(scene == childScene) return true;
		}
		return false;
	}
	public function getSceneByID(id : String) : IIsoScene
	{
		var scene : IIsoScene;
		for(scene in scenesArray)
		{
			if(scene.id == id) return scene;
		}
		return null;
	}
	public function removeScene(scene : IIsoScene) : IIsoScene
	{
		if(containsScene(scene)) 
		{
			var i : Int = scenesArray.indexOf(scene);
			scenesArray.splice(i, 1);
			sceneContainer.removeChild(scene.container);
			return scene;
		}
		else return null;
	}
	public function removeAllScenes() : Void
	{
		var scene : IIsoScene;
		for(scene in scenesArray)
		{
			if(sceneContainer.contains(scene.container)) 
			{
				sceneContainer.removeChild(scene.container);
				scene.hostContainer = null;
			}
		}
		scenesArray = [];
	}

	var _w : Float;
	var _h : Float;
	@:getter(width) function get_width() : Float {
		return _w;
	}

	@:getter(height) function get_height() : Float
	{
		return _h;
	}

	public function getWidth () : Float
	{
		return _w;
	}

	public function getHeight () : Float
	{
		return _h;
	}

	public function getSize() : Point
	{
		return new Point(_w, _h);
	}
	public function setSize(w : Float, h : Float) : Void
	{
		_w = Math.round(w);
		_h = Math.round(h);
		romBoundsRect = new Rectangle(0, 0, _w + 1, _h + 1);
		this.scrollRect = if(_clipContent) romBoundsRect		else null;
		zoomContainer.x = _w / 2;
		zoomContainer.y = _h / 2;
		drawBorder();
	}
	var _clipContent : Bool;
	public function getClipContent() : Bool
	{
		return _clipContent;
	}
	public function setClipContent(value : Bool) : Bool
	{
		if(_clipContent != value) 
		{
			_clipContent = value;
			reset();
		}
		return value;
	}
	var romTarget : DisplayObject;
	var romBoundsRect : Rectangle;
	public function getRangeOfMotionTarget() : DisplayObject
	{
		return romTarget;
	}
	public function setRangeOfMotionTarget(value : DisplayObject) : DisplayObject
	{
		romTarget = value;
		limitRangeOfMotion = (romTarget != null) ? true : false;
		return value;
	}
	public var limitRangeOfMotion : Bool;
	var zoomContainer : Sprite;
	var mContainer : Sprite;
	public function getMainContainer() : Sprite
	{
		return mContainer;
	}
	var bgContainer : Sprite;
	public function getBackgroundContainer() : Sprite
	{
		if(bgContainer == null) 
		{
			bgContainer = new Sprite();
			mContainer.addChildAt(bgContainer, 0);
		}
		return bgContainer;
	}
	var fgContainer : Sprite;
	public function getForegroundContainer() : Sprite
	{
		if(fgContainer == null) 
		{
			fgContainer = new Sprite();
			mContainer.addChild(fgContainer);
		}
		return fgContainer;
	}
	var sceneContainer : Sprite;
	var maskShape : Shape;
	var borderShape : Shape;
	var _showBorder : Bool;
	public function getShowBorder() : Bool
	{
		return _showBorder;
	}
	public function setShowBorder(value : Bool) : Bool
	{
		if(_showBorder != value) 
		{
			_showBorder = value;
			drawBorder();
		}
		return value;
	}
	function drawBorder() : Void
	{
		var g : Graphics = borderShape.graphics;
		g.clear();
		if(showBorder) 
		{
			g.lineStyle(0);
			g.drawRect(0, 0, _w, _h);
		}
	}
	public function new()
	{
		usePreciseValues = false;
		targetScreenPt = new Pt();
		currentScreenPt = new Pt();
		bPositionInvalidated = false;
		autoUpdate = false;
		viewRendererFactories = [];
		scenesArray = [];
		_clipContent = true;
		limitRangeOfMotion = true;
		_showBorder = true;
		super();
		sceneContainer = new Sprite();
		mContainer = new Sprite();
		mContainer.addChild(sceneContainer);
		zoomContainer = new Sprite();
		zoomContainer.addChild(mContainer);
		addChild(zoomContainer);
		maskShape = new Shape();
		addChild(maskShape);
		borderShape = new Shape();
		addChild(borderShape);
		setSize(400, 250);
	}
}
