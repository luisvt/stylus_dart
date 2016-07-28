
/*!
 * Stylus - Null
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */
import './node.dart' show Node;
import 'index.dart' as nodes;

/**
 * Initialize a new `Null` node.
 *
 * @api public
 */

class Null_ extends Node {
  Null_() {
  }


  /**
   * Return 'Null'.
   *
   * @return {String}
   * @api public
   */

  inspect() => toString();

  toString() => 'null';

  /**
   * Return false.
   *
   * @return {Boolean}
   * @api public
   */

  toBoolean() {
    return nodes.$false;
  }

  /**
   * Check if the node is a null node.
   *
   * @return {Boolean}
   * @api public
   */

  get isNull {
    return true;
  }

  /**
   * Return hash.
   *
   * @return {String}
   * @api public
   */

  get hash {
    return null;
  }

  /**
   * Return a JSON representation of this node.
   *
   * @return {Object}
   * @api public
   */

  toJSON() {
    return {
      '__type': 'Null',
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }

}