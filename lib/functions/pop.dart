import '../utils.dart' as utils;

/**
 * Pop a value from `expr`.
 *
 * @param {Expression} expr
 * @return {Node}
 * @api public
 */

pop(expr) {
  expr = utils.unwrap(expr);
  return pop(expr.nodes);
}
