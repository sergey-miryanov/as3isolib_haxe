//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.display;

import as3isolib.core.IFactory;
import as3isolib.core.IsoDisplayObject;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.errors.Error;

class IsoSprite extends IsoDisplayObject
{
	public var sprites(getSprites, setSprites) : Array<Dynamic>;
	public var actualSprites(getActualSprites, never) : Array<Dynamic>;
	var spritesArray : Array<Dynamic>;

	public function getSprites() : Array<Dynamic>
	{
		return spritesArray;
	}

	public function setSprites(value : Array<Dynamic>) : Array<Dynamic>
	{
		if(spritesArray != value) 
		{
			spritesArray = value;
			bSpritesInvalidated = true;
		}
		return value;
	}

	var actualSpriteObjects : Array<Dynamic>;
	public function getActualSprites() : Array<Dynamic>
	{
		return actualSpriteObjects.slice(0);
	}

	var bSpritesInvalidated : Bool;
	public function invalidateSkins() : Void
	{
		bSpritesInvalidated = true;
	}

	public function invalidateSprites() : Void
	{
		bSpritesInvalidated = true;
	}

	override public function getIsInvalidated() : Bool
	{
		return (bPositionInvalidated || bSpritesInvalidated);
	}

	override function renderLogic(recursive : Bool = true) : Void
	{
		if(bSpritesInvalidated) 
		{
			renderSprites();
			bSpritesInvalidated = false;
		}
		super.renderLogic(recursive);
	}

	function renderSprites() : Void
	{
		actualSpriteObjects = [];
		while(mainContainer.numChildren > 0)mainContainer.removeChildAt(0);
		var spriteObj : Dynamic;
		for(spriteObj in spritesArray)
		{
			if(Std.is(spriteObj, BitmapData)) 
			{
				var b : Bitmap = new Bitmap(cast(spriteObj,BitmapData));
				b.cacheAsBitmap = true;
				mainContainer.addChild(b);
				actualSpriteObjects.push(b);
			}
			else if(Std.is(spriteObj, DisplayObject)) 
			{
				mainContainer.addChild(cast(spriteObj,DisplayObject));
				actualSpriteObjects.push(spriteObj);
			}
			else if(Std.is(spriteObj, IFactory)) 
			{
				var spriteInstance : DisplayObject = (cast(spriteObj,IFactory)).newInstance();
				mainContainer.addChild(spriteInstance);
				actualSpriteObjects.push(spriteInstance);
			}
			else
			{
				switch(Type.typeof(spriteObj)) {
				case TClass(c):
					var spriteInstance : DisplayObject = cast Type.createInstance(spriteObj, []);
					mainContainer.addChild(spriteInstance);
					actualSpriteObjects.push(spriteInstance);
				default:
					throw new Error("skin asset is not of the following types: BitmapData, DisplayObject, ISpriteAsset, IFactory or Class cast as DisplayOject.");
				}
			}
		}
	}

	override function createChildren() : Void
	{
		super.createChildren();
		mainContainer = new MovieClip();
		attachMainContainerEventListeners();
	}

	public function new(descriptor : Dynamic = null)
	{
		spritesArray = [];
		actualSpriteObjects = [];
		bSpritesInvalidated = false;
		super(descriptor);
	}
}
