import '../utils.dart' as utils;
import 'package:node_shims/js.dart' as ns;

/**
 * Shift an element from `expr`.
 *
 * @param {Expression} expr
 * @return {Node}
 * @api public
 */

 shift(expr){
   expr = utils.unwrap(expr);
   return ns.shift(expr.nodes);
 }

