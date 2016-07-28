
/*!
 * Stylus - Media
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './atrule.dart' show Atrule;

/**
 * Initialize a new `Media` with the given `val`
 *
 * @param {String} val
 * @api public
 */

class Media {
	Media(val) {
  Atrule.call(this, 'media');
  this.val = val;
	}
}

/**
 * Inherit from `Atrule.prototype`.
 */

Media.prototype.__proto__ = Atrule.prototype;

/**
 * Clone this node.
 *
 * @return {Media}
 * @api public
 */

clone(parent) {

  var clone = new Media;
  clone.val = this.val.clone(parent, clone);
  clone.block = this.block.clone(parent, clone);
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
    '__type': 'Media',
    'val': this.val,
    'block': this.block,
    'lineno': this.lineno,
    'column': this.column,
    'filename': this.filename
  };
}

/**
 * Return @media "val".
 *
 * @return {String}
 * @api public
 */

toString() {

  return '@media ' + this.val;
}
