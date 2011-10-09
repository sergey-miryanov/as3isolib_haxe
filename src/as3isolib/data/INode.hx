//
// (c) 2006 J.W.Opitz and (c) 2011 haxeports. See LICENSE
//

package as3isolib.data;

import eDpLib.events.IEventDispatcherProxy;

interface INode implements IEventDispatcherProxy
{
	var id(getId, setId) : String;
	var name(getName, setName) : String;
	var data(getData, setData) : Dynamic;
	var owner(getOwner, never) : INode;
	var hasParent(getHasParent, never) : Bool;
	var parent(getParent, never) : INode;
	var children(getChildren, never) : Array<INode>;
	var numChildren(getNumChildren, never) : Int;


	function getId() : String;
	function setId(value : String) : String;
	function getName() : String;
	function setName(value : String) : String;
	function getData() : Dynamic;
	function setData(value : Dynamic) : Dynamic;
	function getOwner() : Dynamic;
	function getParent() : INode;
	function getHasParent() : Bool;
	function getRootNode() : INode;
	function getDescendantNodes(includeBranches : Bool = false) : Array<INode>;
	function contains(value : INode) : Bool;
	function getChildren() : Array<INode>;
	function getNumChildren() : Int;
	function addChild(child : INode) : Void;
	function addChildAt(child : INode, index : Int) : Void;
	function getChildIndex(child : INode) : Int;
	function getChildAt(index : Int) : INode;
	function getChildByID(id : String) : INode;
	function setChildIndex(child : INode, index : Int) : Void;
	function removeChild(child : INode) : INode;
	function removeChildAt(index : Int) : INode;
	function removeChildByID(id : String) : INode;
	function removeAllChildren() : Void;
}
