
/*!
 * Stylus - Return
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart';
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Initialize a new `Return` node with the given `expr`.
 *
 * @param {Expression} expr
 * @api public
 */

class Return extends Node {
  var expr;

  Return([expr]) {
    this.expr = or(expr, nodes.$null);
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new Return();
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
      '__type': 'Return',
      'expr': this.expr,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}