
/*!
 * Stylus - Token
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

//var inspect = require('util').inspect;

/**
 * Initialize a new `Token` with the given `type` and `val`.
 *
 * @param {String} type
 * @param {Mixed} val
 * @api private
 */

class Token {
  var type;

  var val;

  var lineno;

  var column;

  Token(type, val) {
    this.type = type;
    this.val = val;
  }

  /**
   * Custom inspect.
   *
   * @return {String}
   * @api public
   */

  inspect() {
    var val = ' ' + this.val;
    return '[Token:' + this.lineno + ':' + this.column + ' '
        + '\x1b[32m' + this.type + '\x1b[0m'
        + '\x1b[33m' + (this.val ? val : '') + '\x1b[0m'
        + ']';
  }

  /**
   * Return type or val.
   *
   * @return {String}
   * @api public
   */

  toString() {
    return (null == this.val
        ? this.type
        : this.val).toString();
  }
}