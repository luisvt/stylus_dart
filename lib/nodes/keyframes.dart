
/*!
 * Stylus - Keyframes
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './atrule.dart' show Atrule;

/**
 * Initialize a new `Keyframes` with the given `segs`,
 * and optional vendor `prefix`.
 *
 * @param {Array} segs
 * @param {String} prefix
 * @api public
 */

class Keyframes {
	Keyframes(segs, prefix) {
  Atrule.call(this, 'keyframes');
  this.segments = segs;
  this.prefix = or(prefix, 'official');
	}
}

/**
 * Inherit from `Atrule.prototype`.
 */

Keyframes.prototype.__proto__ = Atrule.prototype;

/**
 * Return a clone of this node.
 * 
 * @return {Node}
 * @api public
 */

clone(parent) {

  var clone = new Keyframes;
  clone.lineno = this.lineno;
  clone.column = this.column;
  clone.filename = this.filename;
  clone.segments = this.segments.map((node) { return node.clone(parent, clone); });
  clone.prefix = this.prefix;
  clone.block = this.block.clone(parent, clone);
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
    '__type': 'Keyframes',
    'segments': this.segments,
    'prefix': this.prefix,
    'block': this.block,
    'lineno': this.lineno,
    'column': this.column,
    'filename': this.filename
  };
}

/**
 * Return `@keyframes name`.
 *
 * @return {String}
 * @api public
 */

toString() {

  return '@keyframes ' + this.segments.join('');
}
