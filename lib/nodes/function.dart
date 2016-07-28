
/*!
 * Stylus - Function
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart';

/**
 * Initialize a new `Function` with `name`, `params`, and `body`.
 *
 * @param {String} name
 * @param {Params|Function} params
 * @param {Block} body
 * @api public
 */

class Function extends Node {
  var name;

  var params;

  var block;

  Function fn;

  Function([name, params, body]) {
//  Node.call(this);
    this.name = name;
    this.params = params;
    this.block = body;
    if (params is Function) this.fn = params;
  }

  /**
   * Check function arity.
   *
   * @return {Boolean}
   * @api public
   */

  get arity {
    return this.params.length;
  }

  /**
   * Return hash.
   *
   * @return {String}
   * @api public
   */

  get hash {
    return 'function ' + this.name;
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone;
    if (truthy(this.fn)) {
      clone = new Function(
          this.name
      , this.fn);
    } else {
      clone = new Function(this.name);
      clone.params = this.params.clone(parent, clone);
      clone.block = this.block.clone(parent, clone);
    }
    clone.lineno = this.lineno;
    clone.column = this.column;
    clone.filename = this.filename;
    return clone;
  }

  /**
   * Return <name>(param1, param2, ...).
   *
   * @return {String}
   * @api public
   */

  toString() {
    if (truthy(this.fn)) {
      return this.name
          + '('
          + slice(
              this.fn.toString().match(new RegExp(r'^function *\w*\((.*?)\)')),
              1)
              .join(', ')
          + ')';
    } else {
      return this.name
          + '('
          + this.params.nodes.join(', ')
          + ')';
    }
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    var json = {
      '__type': 'Function',
      'name': this.name,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
    if (truthy(this.fn)) {
      json['fn'] = this.fn;
    } else {
      json['params'] = this.params;
      json['block'] = this.block;
    }
    return json;
  }
}