import '../utils.dart' show utils;

/**
 * Pop a value from `expr`.
 *
 * @param {Expression} expr
 * @return {Node}
 * @api public
 */

(module.exports =  pop(expr) {
  expr = utils.unwrap(expr);
  return pop(expr.nodes);
}).raw = true;
