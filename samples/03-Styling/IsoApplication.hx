import as3isolib.display.primitive.IsoBox;
import as3isolib.display.scene.IsoScene;
import as3isolib.enums.RenderStyleType;
import as3isolib.graphics.SolidColorFill;

import flash.display.Sprite;

class IsoApplication extends Sprite
{
	public function new()
	{
		super();
		flash.Lib.current.addChild(this);

		var box:IsoBox = new IsoBox();
		box.styleType = RenderStyleType.SHADED;

		box.fills = cast [
			new SolidColorFill(0xff0000, .5),
			new SolidColorFill(0x00ff00, .5),
			new SolidColorFill(0x0000ff, .5),
			new SolidColorFill(0xff0000, .5),
			new SolidColorFill(0x00ff00, .5),
			new SolidColorFill(0x0000ff, .5)
		];

		box.setSize(25, 30, 40);
		box.moveTo(200, 0, 0);
		
		var scene:IsoScene = new IsoScene();
		scene.hostContainer = this;
		scene.addChild(box);
		scene.render();
	}

	public static function main() {
		var s = new IsoApplication();
	}
}
