import '../utils.dart' as utils;
import 'package:node_shims/path.dart' as path;

/**
 * Return the extname of `path`.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

extname(p){
  utils.assertString(p, 'path');
  return path.extname(p.val);
}
