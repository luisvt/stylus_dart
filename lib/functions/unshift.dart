import '../utils.dart' as utils;
import 'package:node_shims/js.dart' as ns;

/**
 * Unshift the given args to `expr`.
 *
 * @param {Expression} expr
 * @param {Node} ...
 * @return {Unit}
 * @api public
 */

unshift(expr){
  expr = utils.unwrap(expr);
  for (var i = 1, len = arguments.length; i < len; ++i) {
    ns.unshift(expr.nodes, utils.unwrap(arguments[i]));
  }
  return expr.nodes.length;
}
