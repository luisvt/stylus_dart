/*!
 * Stylus - String
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `String` with the given `val`.
 *
 * @param {String} val
 * @param {String} quote
 * @api public
 */

class String {
	String([val, quote]) {
//  Node.call(this);
  this.val = val;
  this.string = val;
  this.prefixed = false;
  if ( quote is String) {
    this.quote = "'";
  } else {
    this.quote = quote;
  }
	}
}

/**
 * Inherit from `Node.prototype`.
 */

String.prototype.__proto__ = Node.prototype;

/**
 * Return quoted string.
 *
 * @return {String}
 * @api public
 */

toString() {

  return this.quote + this.val + this.quote;
}

/**
 * Return a clone of this node.
 * 
 * @return {Node}
 * @api public
 */

clone() {

  var clone = new String(this.val, this.quote);
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
    '__type': 'String',
    'val': this.val,
    'quote': this.quote,
    'lineno': this.lineno,
    'column': this.column,
    'filename': this.filename
  };
}

/**
 * Return Boolean based on the length of this string.
 *
 * @return {Boolean}
 * @api public
 */

toBoolean() {

  return nodes.Boolean(this.val.length);
}

/**
 * Coerce `other` to a string.
 *
 * @param {Node} other
 * @return {String}
 * @api public
 */

coerce(other) {

  switch (other.nodeName) {
    case 'string':
      return other;
    case 'expression':
      return new String(other.nodes.map((node){
        return this.coerce(node).val;
      }, this).join(' '));
    default:
      return new String(other.toString());
  }
}

/**
 * Operate on `right` with the given `op`.
 *
 * @param {String} op
 * @param {Node} right
 * @return {Node}
 * @api public
 */

operate(op, right) {

  switch (op) {
    case '%':
      var expr = new nodes.Expression;
      expr.add(this);

      // constructargs
      var args = 'expression' == right.nodeName
        ? utils.unwrap(right).nodes
        : [right];

      // apply
      return sprintf.apply(null, [expr].concat(args));
    case '+':
      var expr = new nodes.Expression;
      expr.add(new String(this.val + this.coerce(right).val));
      return expr;
    default:
      return super.operate( op, right);
  }
}
