import '../utils.dart' as utils;

/**
 * Return length of the given `expr`.
 *
 * @param {Expression} expr
 * @return {Unit}
 * @api public
 */

length(expr){
  if (expr) {
    if (expr.nodes) {
      var nodes = utils.unwrap(expr).nodes;
      if (1 == nodes.length && 'object' == nodes[0].nodeName) {
        return nodes[0].length;
      } else {
        return nodes.length;
      }
    } else {
      return 1;
    }
  }
  return 0;
}
