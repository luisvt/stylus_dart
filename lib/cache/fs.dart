/**
 * Module dependencies.
 */

import 'package:crypto/crypto.dart' show crypto;
import 'package:node_shims/process.dart';
import 'package:node_shims/js.dart';
import 'package:node_shims/path.dart';
import 'dart:convert';

class FSCache {
  var _location;

  FSCache(options) {
    options = or(options, {});
    this._location = or(options['cache location'], '.styl-cache');
    if (!fs.existsSync(this._location)) fs.mkdirSync(this._location);
  }


  /**
   * Set cache item with given `key` to `value`.
   *
   * @param {String} key
   * @param {Object} value
   * @api private
   */

  set(key, value) {
    fs.writeFileSync(join([this._location, key]), JSON.encode(value));
  }

  /**
   * Get cache item with given `key`.
   *
   * @param {String} key
   * @return {Object}
   * @api private
   */

  get(key) {
    var data = fs.readFileSync(join(this._location, key), 'utf-8');
    return JSON.parse(data, FSCache.fromJSON);
  }

  /**
   * Check if cache has given `key`.
   *
   * @param {String} key
   * @return {Boolean}
   * @api private
   */

  has(key) {
    return fs.existsSync(join(this._location, key));
  }

  /**
   * Generate key for the source `str` with `options`.
   *
   * @param {String} str
   * @param {Object} options
   * @return {String}
   * @api private
   */

  key(str, options) {
    var hash = crypto.createHash('sha1');
    hash.update(str + version + options.prefix);
    return hash.digest('hex');
  }

  /**
   * JSON to Stylus nodes converter.
   *
   * @api private
   */

  static fromJSON(key, val) {
    if (val && val.__type) {
      val.__proto__ = nodes[val.__type].prototype;
    }
    return val;
  }
}
