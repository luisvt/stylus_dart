
/*!
 * Stylus - Node
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import '../visitor/evaluator.dart' show Evaluator;
import 'package:node_shims/js.dart';
import 'package:stylus_dart/utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'package:stylus_dart/nodes/boolean.dart';

/**
 * Initialize a new `CoercionError` with the given `msg`.
 *
 * @param {String} msg
 * @api private
 */

class CoercionError implements Exception {
  String name;

  var message;

  CoercionError(msg) {
    this.name = 'CoercionError';
    this.message = msg;
//    Error.captureStackTrace(this, CoercionError);
  }
}
/**
 * Node constructor.
 *
 * @api public
 */

class Node {
  var lineno;

  var column;

  var filename;

  var val;

	Node() {
  this.lineno = or(nodes.lineno, 1);
  this.column = or(nodes.column, 1);
  this.filename = nodes.filename;
	}




  /**
   * Return this node.
   *
   * @return {Node}
   * @api public
   */

  get first {
    return this;
  }

  /**
   * Return hash.
   *
   * @return {String}
   * @api public
   */

  get hash {
    return this.val;
  }

  /**
   * Return node name.
   *
   * @return {String}
   * @api public
   */

  get nodeName {
    return this.constructor.name.toLowerCase();
  }

  /**
   * Return this node.
   * 
   * @return {Node}
   * @api public
   */

  clone(parent) {
    return this;
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }

  /**
   * Nodes by default evaluate to themselves.
   *
   * @return {Node}
   * @api public
   */

  eval() {
    return new Evaluator(this).evaluate();
  }

  /**
   * Return true.
   *
   * @return {Boolean}
   * @api public
   */

  Boolean toBoolean() {
    return nodes.$true;
  }

  /**
   * Return the expression, or wrap this node in an expression.
   *
   * @return {Expression}
   * @api public
   */

  toExpression() {
    if ('expression' == this.nodeName) return this;
    var expr = new nodes.Expression;
    expr.add(this);
    return expr;
  }

  /**
   * Return false if `op` is generally not coerced.
   *
   * @param {String} op
   * @return {Boolean}
   * @api private
   */

  shouldCoerce(op) {
    switch (op) {
      case 'is a':
      case 'in':
      case '||':
      case '&&':
        return false;
      default:
        return true;
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

  operate(op, right, [val]) {
    switch (op) {
      case 'is a':
        if ('string' == right.first.nodeName) {
          return nodes.Boolean(this.nodeName == right.val);
        } else {
          throw new Exception('"is a" expects a string, got ' + right.toString());
        }
        break;
      case '==':
        return nodes.Boolean(this.hash == right.hash);
      case '!=':
        return nodes.Boolean(this.hash != right.hash);
      case '>=':
        return nodes.Boolean(this.hash >= right.hash);
      case '<=':
        return nodes.Boolean(this.hash <= right.hash);
      case '>':
        return nodes.Boolean(this.hash > right.hash);
      case '<':
        return nodes.Boolean(this.hash < right.hash);
      case '||':
        return this.toBoolean().isTrue
          ? this
          : right;
      case 'in':
        var vals = utils.unwrap(right).nodes
          , len = vals && vals.length
          , hash = this.hash;
        if (!vals) throw new Exception('"in" given invalid right-hand operand, expecting an expression');

        // 'prop' in obj
        if (1 == len && 'object' == vals[0].nodeName) {
          return nodes.Boolean(vals[0].has(this.hash));
        }

        for (var i = 0; i < len; ++i) {
          if (hash == vals[i].hash) {
            return true;
          }
        }
        return false;
      case '&&':
        var a = this.toBoolean()
          , b = right.toBoolean();
        return a.isTrue && b.isTrue
          ? right
          : a.isFalse
            ? this
            : right;
      default:
        if ('[]' == op) {
          var msg = 'cannot perform '
            + this
            + '[' + right + ']';
        } else {
          var msg = 'cannot perform'
            + ' ' + this
            + ' ' + op
            + ' ' + right;
        }
        throw new Exception(msg);
    }
  }

  /**
   * Default coercion throws.
   *
   * @param {Node} other
   * @return {Node}
   * @api public
   */

  coerce(other) {
    if (other.nodeName == this.nodeName) return other;
    throw new CoercionError('cannot coerce ' + other + ' to ' + this.nodeName);
  }
}

