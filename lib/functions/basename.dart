import '../utils.dart' show utils;

/**
 * Return the basename of `path`.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

module.exports =  basename(p, ext){
  utils.assertString(p, 'path');
  return path.basename(p.val, ext && ext.val);
};
