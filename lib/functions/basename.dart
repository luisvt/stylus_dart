import '../utils.dart' as utils;
import 'package:node_shims/path.dart' as path;

/**
 * Return the basename of `path`.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

basename(p, ext){
  utils.assertString(p, 'path');
  return path.basename(p.val, ext?.val);
}
