
/*!
 * Stylus - Root
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart' as ns;

/**
 * Initialize a new `Root` node.
 *
 * @api public
 */

class Root extends Node {
  List nodes;

  Root() {
    this.nodes = [];
  }

  /**
   * Push a `node` to this block.
   *
   * @param {Node} node
   * @api public
   */

  push(node) {
    this.nodes.add(node);
  }

  /**
   * Unshift a `node` to this block.
   *
   * @param {Node} node
   * @api public
   */

  unshift(node) {
    ns.unshift(this.nodes, node);
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone([p]) {
    var clone = new Root();
    clone.lineno = this.lineno;
    clone.column = this.column;
    clone.filename = this.filename;
    this.nodes.forEach((node) {
      clone.add(node.clone(clone, clone));
    });
    return clone;
  }

  /**
   * Return "root".
   *
   * @return {String}
   * @api public
   */

  toString() {
    return '[Root]';
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      '__type': 'Root',
      'nodes': this.nodes,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}