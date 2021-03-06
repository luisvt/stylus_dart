/*!
 * Stylus - Namespace
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `Namespace` with the given `val` and `prefix`
 *
 * @param {String|Call} val
 * @param {String} [prefix]
 * @api public
 */

class Namespace extends Node {
  var prefix;

  Namespace(val, prefix) {
    this.val = val;
    this.prefix = prefix;
  }

  /**
   * Return @namespace "val".
   *
   * @return {String}
   * @api public
   */

  toString() {
    return '@namespace ' + (this.prefix ? this.prefix + ' ' : '') + this.val;
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      '__type': 'Namespace',
      'val': this.val,
      'prefix': this.prefix,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}