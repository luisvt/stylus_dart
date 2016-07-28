
/*!
 * Stylus - If
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `If` with the given `cond`.
 *
 * @param {Expression} cond
 * @param {Boolean|Block} negate, block
 * @api public
 */

class If {
	If(cond, negate) {
  Node.call(this);
  this.cond = cond;
  this.elses = [];
  if (negate && negate.nodeName) {
    this.block = negate;
  } else {
    this.negate = negate;
  }
	}
}

/**
 * Inherit from `Node.prototype`.
 */

If.prototype.__proto__ = Node.prototype;

/**
 * Return a clone of this node.
 * 
 * @return {Node}
 * @api public
 */

clone(parent) {

  var clone = new If();
  clone.cond = this.cond.clone(parent, clone);
  clone.block = this.block.clone(parent, clone);
  clone.elses = this.elses.map((node){ return node.clone(parent, clone); });
  clone.negate = this.negate;
  clone.postfix = this.postfix;
  clone.lineno = this.lineno;
  clone.column = this.column;
  clone.filename = this.filename;
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
    '__type': 'If',
    'cond': this.cond,
    'block': this.block,
    'elses': this.elses,
    'negate': this.negate,
    'postfix': this.postfix,
    'lineno': this.lineno,
    'column': this.column,
    'filename': this.filename
  };
}
