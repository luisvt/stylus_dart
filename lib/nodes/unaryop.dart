
/*!
 * Stylus - UnaryOp
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `UnaryOp` with `op`, and `expr`.
 *
 * @param {String} op
 * @param {Node} expr
 * @api public
 */

class UnaryOp extends Node {
  var op;

  var expr;

  UnaryOp(op, [expr]) {
    this.op = op;
    this.expr = expr;
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new UnaryOp(this.op);
    clone.expr = this.expr.clone(parent, clone);
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
      '__type': 'UnaryOp',
      'op': this.op,
      'expr': this.expr,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}