import as3isolib.display.IsoSprite;
import as3isolib.display.primitive.IsoBox;
import as3isolib.display.scene.IsoGrid;
import as3isolib.display.scene.IsoScene;

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;

public class IsoApplication extends Sprite
{
	private var scene:IsoScene;
	private var assets:Object;
	
	private var loader:Loader
	
	private function loadAssets ():void
	{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, loader_initHandler);
			loader.load(new URLRequest("assets/swf/assets.swf"));
			
	}
	
	private function loader_initHandler (evt:Event):void
	{
			buildScene();
	}
	
	private function buildScene ():void
	{
			scene = new IsoScene();
			scene.hostContainer = this; //it is recommended to use an IsoView
			
			var treeTrunkClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition("TreeTrunk") as Class;
			var treeLeavesClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition("TreeLeaves") as Class;
			
			var grid:IsoGrid = new IsoGrid();
			grid.showOrigin = false;
			scene.addChild(grid);
			
			var s0:IsoSprite = new IsoSprite();
			s0.setSize(25, 25, 65);
			s0.moveTo(50, 50, 0);
			s0.sprites = [treeTrunkClass];
			scene.addChild(s0);
			
			var s1:IsoSprite = new IsoSprite();
			s1.setSize(125, 125, 100);
			s1.moveTo(0, 0, 75);
			s1.sprites = [treeLeavesClass];
			scene.addChild(s1);
			
			scene.render();
	}
	
	public function IsoApplication ()
	{
			loadAssets();
	}
}
