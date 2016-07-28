
/*!
 * Stylus - Call
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `Call` with `name` and `args`.
 *
 * @param {String} name
 * @param {Expression} args
 * @api public
 */

class Call extends Node {
  var name;

  var args;

  var block;

  Call([name, args]) {
//  Node.call(this);
    this.name = name;
    this.args = args;
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new Call(this.name);
    clone.args = this.args.clone(parent, clone);
    if (this.block) clone.block = this.block.clone(parent, clone);
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
    var args = this.args.nodes.map((node) {
      var str = node.toString();
      return str.substring(1, str.length - 1);
    }).join(', ');

    return this.name + '(' + args + ')';
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    var json = {
      '__type': 'Call',
      'name': this.name,
      'args': this.args,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
    if (this.block) json['block'] = this.block;
    return json;
  }
}
