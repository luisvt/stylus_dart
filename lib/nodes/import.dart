
/*!
 * Stylus - Import
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart';

/**
 * Initialize a new `Import` with the given `expr`.
 *
 * @param {Expression} expr
 * @api public
 */

class Import extends Node {
  var path;

  var once;

  var mtime;

  Import([expr, once]) {
    this.path = expr;
    this.once = or(once, false);
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new Import();
    clone.path = this.path.nodeName ? this.path.clone(parent, clone) : this.path;
    clone.once = this.once;
    clone.mtime = this.mtime;
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
      '__type': 'Import',
      'path': this.path,
      'once': this.once,
      'mtime': this.mtime,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}