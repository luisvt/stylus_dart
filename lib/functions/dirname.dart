import '../utils.dart' show utils;

/**
 * Return the dirname of `path`.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

module.exports =  dirname(p){
  utils.assertString(p, 'path');
  return path.dirname(p.val).replace(new RegExp(r'\\/'), '/');
};
