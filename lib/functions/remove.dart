import '../utils.dart' as utils;

/**
 * Remove the given `key` from the `object`.
 *
 * @param {Object} object
 * @param {String} key
 * @return {Object}
 * @api public
 */

remove(object, key){
  utils.assertType(object, 'object', 'object');
  utils.assertString(key, 'key');
   object.vals.remove(key.string);
  return object;
}
