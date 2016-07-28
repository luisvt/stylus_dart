
/*!
 * Stylus - Arguments
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'index.dart' as nodes;
import 'package:stylus_dart/nodes/expression.dart';

/**
 * Initialize a new `Arguments`.
 *
 * @api public
 */

class Arguments extends Expression {
  Map map;

  Arguments() {
//  super.Expression()nodes.Expression.call(this);
    this.map = {};
  }


  /**
   * Initialize an `Arguments` object with the nodes
   * from the given `expr`.
   *
   * @param {Expression} expr
   * @return {Arguments}
   * @api public
   */

  static fromExpression(expr) {
    var args = new Arguments(), len = expr.nodes.length;
    args.lineno = expr.lineno;
    args.column = expr.column;
    args.isList = expr.isList;
    for (var i = 0; i < len; ++i) {
      args.add(expr.nodes[i]);
    }
    return args;
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = super.clone(parent);
    clone.map = {};
    for (var key in this.map.keys) {
      clone.map[key] = this.map[key].clone(parent, clone);
    }
    clone.isList = this.isList;
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
      '__type': 'Arguments',
      'map': this.map,
      'isList': this.isList,
      'preserve': this.preserve,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename,
      'nodes': this.nodes
    };
  }
}