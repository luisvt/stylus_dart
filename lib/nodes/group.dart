
/*!
 * Stylus - Group
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `Group`.
 *
 * @api public
 */

class Group {
	Group() {
//  Node.call(this);
  this.nodes = [];
  this.extends = [];
	}
}

/**
 * Inherit from `Node.prototype`.
 */

Group.prototype.__proto__ = Node.prototype;

/**
 * Push the given `selector` node.
 *
 * @param {Selector} selector
 * @api public
 */

push(selector) {

  this.nodes.add(selector);
}

/**
 * Return this set's `Block`.
 */

Group.prototype.__defineGetter__('block', (){
  return this.nodes[0].block;
});

/**
 * Assign `block` to each selector in this set.
 *
 * @param {Block} block
 * @api public
 */

Group.prototype.__defineSetter__('block', (block){
  for (var i = 0, len = this.nodes.length; i < len; ++i) {
    this.nodes[i].block = block;
  }
});

/**
 * Check if this set has only placeholders.
 *
 * @return {Boolean}
 * @api public
 */

Group.prototype.__defineGetter__('hasOnlyPlaceholders', (){
  return this.nodes.every((selector) { return selector.isPlaceholder; });
});

/**
 * Return a clone of this node.
 * 
 * @return {Node}
 * @api public
 */

clone(parent) {

  var clone = new Group;
  clone.lineno = this.lineno;
  clone.column = this.column;
  this.nodes.forEach((node){
    clone.add(node.clone(parent, clone));
  });
  clone.filename = this.filename;
  clone.block = this.block.clone(parent, clone);
  return clone;
}

/**
 * Return a JSON representation of this node.
 *
 * @return {Object}
 * @api public
 */

toJSON() {

  return {
    '__type': 'Group',
    'nodes': this.nodes,
    'block': this.block,
    'lineno': this.lineno,
    'column': this.column,
    'filename': this.filename
  };
}
