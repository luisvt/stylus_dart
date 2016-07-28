
/*!
 * Stylus - Extend
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `Extend` with the given `selectors` array.
 *
 * @param {Array} selectors array of the selectors
 * @api public
 */

class Extend extends Node {
  var selectors;

  Extend(selectors) {
//  Node.call(this);
    this.selectors = selectors;
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    return new Extend(this.selectors);
  }

  /**
   * Return `@extend selectors`.
   *
   * @return {String}
   * @api public
   */

  toString() {
    return '@extend ' + this.selectors.join(', ');
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      '__type': 'Extend',
      'selectors': this.selectors,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}