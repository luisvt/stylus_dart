
/*!
 * Stylus - Block
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart';

/**
 * Initialize a new `Block` node with `parent` Block.
 *
 * @param {Block} parent
 * @api public
 */

class Block extends Node {
  List nodes;

  var parent;

  var node;

  bool scope;

  Block(parent, node) {
//  Node.call(this);
    this.nodes = [];
    this.parent = parent;
    this.node = node;
    this.scope = true;
  }


  /**
   * Check if this block has properties..
   *
   * @return {Boolean}
   * @api public
   */

  get hasProperties {
    for (var i = 0, len = this.nodes.length; i < len; ++i) {
      if ('property' == this.nodes[i].nodeName) {
        return true;
      }
    }
  }

  /**
   * Check if this block has @media nodes.
   *
   * @return {Boolean}
   * @api public
   */

  get hasMedia {
    for (var i = 0, len = this.nodes.length; i < len; ++i) {
      var nodeName = this.nodes[i].nodeName;
      if ('media' == nodeName) {
        return true;
      }
    }
    return false;
  }

  /**
   * Check if this block is empty.
   *
   * @return {Boolean}
   * @api public
   */

  get isEmpty {
    return falsey(this.nodes.length);
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone_(parent, node) {
    parent = or(parent, this.parent);
    var clone = new Block(parent, or(node, this.node));
    clone.lineno = this.lineno;
    clone.column = this.column;
    clone.filename = this.filename;
    clone.scope = this.scope;
    this.nodes.forEach((node) {
      clone.add(node.clone(clone, clone));
    });
    return clone;
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
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      '__type': 'Block',
      // parent: this.parent,
      // node: this.node,
      'scope': this.scope,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename,
      'nodes': this.nodes
    };
  }
}