import 'package:node_shims/js.dart';
import 'package:node_shims/path.dart' as path;

/**
 * Peform a path join.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

pathjoin([arguments]){
  var paths = slice(arguments, 0).map((path){
    return path.first.string;
  });
  return path.join(paths).replaceAll(new RegExp(r'\\/'), '/');
}
