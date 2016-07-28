import '../utils.dart' show utils;

/**
 * Return the extname of `path`.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

module.exports =  extname(p){
  utils.assertString(p, 'path');
  return path.extname(p.val);
};
