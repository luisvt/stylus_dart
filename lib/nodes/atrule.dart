/*!
 * Stylus - at-rule
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart';

/**
 * Initialize a new at-rule node.
 *
 * @param {String} type
 * @api public
 */

class Atrule extends Node {
  var type;

  var block;

  var segments;

  Atrule(type) {
//  Node.call(this);
    this.type = type;
  }

  /**
   * Check if at-rule's block has only properties.
   *
   * @return {Boolean}
   * @api public
   */

  get hasOnlyProperties {
    if (falsey(this.block)) return false;

    var nodes = this.block.nodes;
    for (var i = 0, len = nodes.length; i < len; ++i) {
      var nodeName = nodes[i].nodeName;
      switch (nodes[i].nodeName) {
        case 'property':
        case 'expression':
        case 'comment':
          continue;
        default:
          return false;
      }
    }
    return true;
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new Atrule(this.type);
    if (this.block) clone.block = this.block.clone(parent, clone);
    clone.segments = this.segments.map((node) {
      return node.clone(parent, clone);
    });
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
    var json = {
      '__type': 'Atrule',
      'type': this.type,
      'segments': this.segments,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
    if (this.block) json.block = this.block;
    return json;
  }

  /**
   * Return @<type>.
   *
   * @return {String}
   * @api public
   */

  toString() {
    return '@' + this.type;
  }

  /**
   * Check if the at-rule's block has output nodes.
   *
   * @return {Boolean}
   * @api public
   */

  get hasOutput {
    return truthy(this.block) && _hasOutput(this.block);
  }
}

_hasOutput(block) {
  var nodes = block.nodes;

  // only placeholder selectors
  if (nodes.every((node){
    return 'group' == node.nodeName && node.hasOnlyPlaceholders;
  })) return false;

  // something visible
  return nodes.some((node) {
    switch (node.nodeName) {
      case 'property':
      case 'literal':
      case 'import':
        return true;
      case 'block':
        return _hasOutput(node);
      default:
        if (node.block) return _hasOutput(node.block);
    }
  });
}
