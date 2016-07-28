
/*!
 * Stylus - Boolean
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `Boolean` node with the given `val`.
 *
 * @param {Boolean} val
 * @api public
 */

class Boolean extends Node {
  Boolean(val) {
    Node.call(this);
    if (this.nodeName) {
      this.val = ! !val;
    } else {
      return new Boolean(val);
    }
  }


  /**
   * Return `this` node.
   *
   * @return {Boolean}
   * @api public
   */

  toBoolean() => this;

  /**
   * Return `true` if this node represents `true`.
   *
   * @return {Boolean}
   * @api public
   */

  get isTrue => this.val;

  /**
   * Return `true` if this node represents `false`.
   *
   * @return {Boolean}
   * @api public
   */

  get isFalse => !this.val;

  /**
   * Negate the value.
   *
   * @return {Boolean}
   * @api public
   */

  negate() => new Boolean(!this.val);

  /**
   * Return 'Boolean'.
   *
   * @return {String}
   * @api public
   */

  inspect() => '[Boolean ' + this.val + ']';

  /**
   * Return 'true' or 'false'.
   *
   * @return {String}
   * @api public
   */

  toString() => this.val
        ? 'true'
        : 'false';

  /**
   * Return a JSON representaiton of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() => {
      '__type': 'Boolean',
      'val': this.val
    };
}