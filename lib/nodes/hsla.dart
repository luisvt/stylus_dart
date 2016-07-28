/*!
 * Stylus - HSLA
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './node.dart' show Node;
import 'index.dart' as nodes;
import 'dart:math' as Math;

/**
 * Initialize a new `HSLA` with the given h,s,l,a component values.
 *
 * @param {Number} h
 * @param {Number} s
 * @param {Number} l
 * @param {Number} a
 * @api public
 */

class HSLA extends Node {
  var h;

  var s;

  var l;

  var a;

  HSLA hsla;

  HSLA(h, s, l, a) {
//  Node.call(this);
    this.h = clampDegrees(h);
    this.s = clampPercentage(s);
    this.l = clampPercentage(l);
    this.a = clampAlpha(a);
    this.hsla = this;
  }

  /**
   * Return hsla(n,n,n,n).
   *
   * @return {String}
   * @api public
   */

  toString() {
    return 'hsla('
        + this.h + ','
        + this.s.toFixed(0) + '%,'
        + this.l.toFixed(0) + '%,'
        + this.a + ')';
  }

  /**
   * Return a clone of this node.
   *
   * @return {Node}
   * @api public
   */

  clone(parent) {
    var clone = new HSLA(
        this.h
    , this.s
    , this.l
    , this.a);
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
      '__type': 'HSLA',
      'h': this.h,
      's': this.s,
      'l': this.l,
      'a': this.a,
      'lineno': this.lineno,
      'column': this.column,
      'filename': this.filename
    };
  }

  /**
   * Return rgba `RGBA` representation.
   *
   * @return {RGBA}
   * @api public
   */

  get rgba {
    return nodes.RGBA.fromHSLA(this);
  }

  /**
   * Return hash.
   *
   * @return {String}
   * @api public
   */
  String get hash {
    return this.rgba.toString();
  }

  /**
   * Add h,s,l to the current component values.
   *
   * @param {Number} h
   * @param {Number} s
   * @param {Number} l
   * @return {HSLA} new node
   * @api public
   */
  add(h, s, l) {
    return new HSLA(
        this.h + h
    , this.s + s
    , this.l + l
    , this.a);
  }

  /**
   * Subtract h,s,l from the current component values.
   *
   * @param {Number} h
   * @param {Number} s
   * @param {Number} l
   * @return {HSLA} new node
   * @api public
   */
  sub(h, s, l) {
    return this.add(-h, -s, -l);
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
      case '==':
      case '!=':
      case '<=':
      case '>=':
      case '<':
      case '>':
      case 'is a':
      case '||':
      case '&&':
        return this.rgba.operate(op, right);
      default:
        return this.rgba
            .operate(op, right)
            .hsla;
    }
  }

  /**
   * Adjust lightness by `percent`.
   *
   * @param {Number} percent
   * @return {HSLA} for chaining
   * @api public
   */
  adjustLightness(percent) {
    this.l = clampPercentage(this.l + this.l * (percent / 100));
    return this;
  }

  /**
   * Adjust hue by `deg`.
   *
   * @param {Number} deg
   * @return {HSLA} for chaining
   * @api public
   */

  adjustHue(deg) {
    this.h = clampDegrees(this.h + deg);
    return this;
  }

  /**
   * Return `HSLA` representation of the given `color`.
   *
   * @param {RGBA} color
   * @return {HSLA}
   * @api public
   */
  static fromRGBA(rgba) {
    var r = rgba.r / 255,
        g = rgba.g / 255,
        b = rgba.b / 255,
        a = rgba.a;

    var min = Math.min(r, Math.min(g, b)),
        max = Math.max(r, Math.max(g, b)),
        l = (max + min) / 2,
        d = max - min,

        h = max == min ? 0 :
        /**/max == r ? 60 * (g - b) / d :
        /**/max == g ? 60 * (b - r) / d + 120 :
        /**/max == b ? 60 * (r - g) / d + 240 :
        /**/null,

        s = max == min ? 0 :
        /**/l < .5 ? d / (2 * l) :
        /**/d / (2 - 2 * l);

//    switch (max) {
//      case min:
//        h = 0;
//        break;
//      case r:
//        h = 60 * (g - b) / d;
//        break;
//      case g:
//        h = 60 * (b - r) / d + 120;
//        break;
//      case b:
//        h = 60 * (r - g) / d + 240;
//        break;
//    }

//    if (max == min) {
//      s = 0;
//    } else if (l < .5) {
//      s = d / (2 * l);
//    } else {
//      s = d / (2 - 2 * l);
//    }

    h %= 360;
    s *= 100;
    l *= 100;

    return new HSLA(h, s, l, a);
  }

}

/**
 * Clamp degree `n` >= 0 and <= 360.
 *
 * @param {Number} n
 * @return {Number}
 * @api private
 */
clampDegrees(n) {
  n = n % 360;
  return n >= 0 ? n : 360 + n;
}

/**
 * Clamp percentage `n` >= 0 and <= 100.
 *
 * @param {Number} n
 * @return {Number}
 * @api private
 */
clampPercentage(n) {
  return Math.max(0, Math.min(n, 100));
}

/**
 * Clamp alpha `n` >= 0 and <= 1.
 *
 * @param {Number} n
 * @return {Number}
 * @api private
 */
clampAlpha(n) {
  return Math.max(0, Math.min(n, 1));
}
