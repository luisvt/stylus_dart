
/*!
 * Stylus - QueryList
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;

/**
 * Initialize a new `QueryList`.
 *
 * @api public
 */

class QueryList {
	QueryList() {
  Node.call(this);
  this.nodes = [];
	}
}

/**
 * Inherit from `Node.prototype`.
 */

QueryList.prototype.__proto__ = Node.prototype;

/**
 * Return a clone of this node.
 * 
 * @return {Node}
 * @api public
 */

clone(parent) {

  var clone = new QueryList;
  clone.lineno = this.lineno;
  clone.column = this.column;
  clone.filename = this.filename;
  for (var i = 0; i < this.nodes.length; ++i) {
    clone.add(this.nodes[i].clone(parent, clone));
  }
  return clone;
}

/**
 * Push the given `node`.
 *
 * @param {Node} node
 * @api public
 */

push(node) {

  this.nodes.add(node);
}

/**
 * Merges this query list with the `other`.
 *
 * @param {QueryList} other
 * @return {QueryList}
 * @api private
 */

merge(other) {

  var list = new QueryList
    , merged;
  this.nodes.forEach((query){
    for (var i = 0, len = other.nodes.length; i < len; ++i){
      merged = query.merge(other.nodes[i]);
      if (merged) list.add(merged);
    }
  });
  return list;
}

/**
 * Return "<a>, <b>, <c>"
 *
 * @return {String}
 * @api public
 */

toString() {

  return '(' + this.nodes.map((node){
    return node.toString();
  }).join(', ') + ')';
}

/**
 * Return a JSON representation of this node.
 *
 * @return {Object}
 * @api public
 */

toJSON() {

  return {
    '__type': 'QueryList',
    'nodes': this.nodes,
    'lineno': this.lineno,
    'column': this.column,
    'filename': this.filename
  };
}
