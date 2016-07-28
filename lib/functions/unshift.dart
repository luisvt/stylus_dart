import '../utils.dart' show utils;

/**
 * Unshift the given args to `expr`.
 *
 * @param {Expression} expr
 * @param {Node} ...
 * @return {Unit}
 * @api public
 */

(module.exports = (expr){
  expr = utils.unwrap(expr);
  for (var i = 1, len = arguments.length; i < len; ++i) {
    unshift(expr.nodes, utils.unwrap(arguments[i]));
  }
  return expr.nodes.length;
}).raw = true;
