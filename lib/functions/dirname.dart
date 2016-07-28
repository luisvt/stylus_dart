import '../utils.dart' as utils;
import 'package:node_shims/path.dart' as path;

/**
 * Return the dirname of `path`.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

dirname(p){
  utils.assertString(p, 'path');
  return path.dirname(p.val).replaceAll(new RegExp(r'\\/'), '/');
}
