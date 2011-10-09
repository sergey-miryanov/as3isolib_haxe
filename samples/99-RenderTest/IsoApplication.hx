import as3isolib.display.primitive.IsoBox;
import as3isolib.display.primitive.IsoPrimitive;
import as3isolib.display.scene.IsoGrid;
import as3isolib.display.scene.IsoScene;
import as3isolib.display.IsoView;

import flash.display.Sprite;

import as3isolib.graphics.IFill;
import as3isolib.graphics.SolidColorFill;

class IsoApplication extends Sprite
{

	public function new()
	{
		super();
		flash.Lib.current.addChild(this);
		var scene:IsoScene = new IsoScene();
		scene.hostContainer = this;
		//scene.layoutRenderer = new as3isolib.display.renderers.HaxeSceneRenderer();

		for(x in 0...20) {
		for(y in 0...20) { 
			var box:IsoBox = new IsoBox();

			var fills:Array<IFill> = new Array();
			fills.push(new SolidColorFill(0xee0000, 0.3));
			fills.push(new SolidColorFill(0x00ff00, 0.9));
			fills.push(new SolidColorFill(0x0000ff, 0.9));
			box.fills = fills;
			box.stroke = IsoPrimitive.DEFAULT_STROKE;

			box.setSize(25, 25, 25);
			box.moveTo(x*25, y*25, 0);

			scene.addChild(box);
		}
		}
		scene.render();
	}


	public static function main() {
		var s = new IsoApplication();
	}
}

