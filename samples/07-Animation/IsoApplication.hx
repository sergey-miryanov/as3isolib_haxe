import as3isolib.core.IIsoDisplayObject;
import as3isolib.display.IsoView;
import as3isolib.display.primitive.IsoBox;
import as3isolib.display.scene.IsoGrid;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;

import eDpLib.events.ProxyEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class IsoApplication extends Sprite
{
	private var box:IIsoDisplayObject;
	private var scene:IsoScene;

	public function new ()
	{
		super();
		flash.Lib.current.addChild(this);

		scene = new IsoScene();
		
		var g:IsoGrid = new IsoGrid();
		g.showOrigin = false;
		g.addEventListener(MouseEvent.CLICK, grid_mouseHandler);
		scene.addChild(g);
		
		box = new IsoBox();
		box.setSize(25, 25, 25);
		box.usePreciseValues = false;
		scene.addChild(box);
		
		var view:IsoView = new IsoView();
		view.clipContent = false;
		view.y = 50;
		view.setSize(150, 100);
		view.addScene(scene);
		addChild(view);

		scene.render();
	}

	var xTween : GenericActuator;
	var yTween : GenericActuator;
	private function grid_mouseHandler (evt:ProxyEvent):Void
	{
		var mEvt:MouseEvent = cast evt.targetEvent;
		var pt:Pt = new Pt(mEvt.localX, mEvt.localY);
		IsoMath.screenToIso(pt);

		if(xTween != null) xTween.stop(null,false,false);
		if(yTween != null) yTween.stop(null,false,false);
#if cpp
		xTween = cast Actuate.tween (box, 2, { x: pt.x, y: pt.y } ).onComplete (tweenCompleteHandler);
#else
		xTween = cast Actuate.update(box.setX, 2, [box.getX()], [pt.x]).onComplete(tweenCompleteHandler);
		yTween = cast Actuate.update(box.setY, 2, [box.getY()], [pt.y]).onComplete(tweenCompleteHandler);
#end
		if (!hasEventListener(Event.ENTER_FRAME))
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);

	}
	
	private function tweenCompleteHandler():Void
	{
		this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function enterFrameHandler (evt:Event):Void
	{
		scene.render();
	}

	public static function main() {
		var s = new IsoApplication();
	}
}
