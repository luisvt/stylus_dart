
/*!
 * Stylus - Query
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'package:node_shims/js.dart';

/**
 * Initialize a new `Query`.
 *
 * @api public
 */

class Query extends Node {
  List nodes;

  var type;

  var predicate;

  Query() {
    this.nodes = [];
    this.type = '';
    this.predicate = '';
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new Query();
    clone.predicate = this.predicate;
    clone.type = this.type;
    for (var i = 0, len = this.nodes.length; i < len; ++i) {
      clone.add(this.nodes[i].clone(parent, clone));
    }
    clone.lineno = this.lineno;
    clone.column = this.column;
    clone.filename = this.filename;
    return clone;
  }

  /**
   * Push the given `feature`.
   *
   * @param {Feature} feature
   * @api public
   */
  push(feature) {
    this.nodes.add(feature);
  }

  /**
   * Return resolved type of this query.
   *
   * @return {String}
   * @api private
   */

  get resolvedType {
    if (this.type != null) {
      return this.type.nodeName
          ? this.type.string
          : this.type;
    }
  }

  /**
   * Return resolved predicate of this query.
   *
   * @return {String}
   * @api private
   */

  get resolvedPredicate {
    if (this.predicate) {
      return this.predicate.nodeName
          ? this.predicate.string
          : this.predicate;
    }
  }

  /**
   * Merges this query with the `other`.
   *
   * @param {Query} other
   * @return {Query}
   * @api private
   */

  merge(other) {
    var query = new Query()
    ,
        p1 = this.resolvedPredicate
    ,
        p2 = other.resolvedPredicate
    ,
        t1 = this.resolvedType
    ,
        t2 = other.resolvedType
    ,
        type,
        pred;

    // Stolen from Sass :D
    t1 = or(t1, t2);
    t2 = or(t2, t1);
    if (('not' == p1) != ('not' == p2)) {
      if (t1 == t2) return null;
      type = ('not' == p1) ? t2 : t1;
      pred = ('not' == p1) ? p2 : p1;
    } else if (('not' == p1) && ('not' == p2)) {
      if (t1 != t2) return null;
      type = t1;
      pred = 'not';
    } else if (t1 != t2) {
      return null;
    } else {
      type = t1;
      pred = or(p1, p2);
    }
    query.predicate = pred;
    query.type = type;
    query.nodes = concat([this.nodes, other.nodes]);
    return query;
  }

  /**
   * Return "<a> and <b> and <c>"
   *
   * @return {String}
   * @api public
   */

  toString() {
    var pred = this.predicate ? this.predicate + ' ' : ''
    ,
        type = this.type ?? ''
    ,
        len = this.nodes.length
    ,
        str = pred + type;
    if (len) {
      str += (type && ' and ') + this.nodes.map((expr) {
        return expr.toString();
      }).join(' and ');
    }
    return str;
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      '__type': 'Query',
      'predicate': this.predicate,
      'type': this.type,
      'nodes': this.nodes,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }
}