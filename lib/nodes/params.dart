
/*!
 * Stylus - Params
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `Params` with `name`, `params`, and `body`.
 *
 * @param {String} name
 * @param {Params} params
 * @param {Expression} body
 * @api public
 */

class Params extends Node {
  List nodes;

  Params() {
    this.nodes = [];
  }


  /**
   * Check function arity.
   *
   * @return {Boolean}
   * @api public
   */

  get length {
    return this.nodes.length;
  }


  /**
   * Push the given `node`.
   *
   * @param {Node} node
   * @api public
   */

  push(node) {
    this.nodes.add(node);
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new Params();
    clone.lineno = this.lineno;
    clone.column = this.column;
    clone.filename = this.filename;
    this.nodes.forEach((node) {
      clone.add(node.clone(parent, clone));
    });
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
      '__type': 'Params',
      'nodes': this.nodes,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}
