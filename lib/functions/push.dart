import '../utils.dart' show utils;

/**
 * Push the given args to `expr`.
 *
 * @param {Expression} expr
 * @param {Node} ...
 * @return {Unit}
 * @api public
 */

(module.exports = (expr){
  expr = utils.unwrap(expr);
  for (var i = 1, len = arguments.length; i < len; ++i) {
    expr.nodes.add(utils.unwrap(arguments[i]).clone());
  }
  return expr.nodes.length;
}).raw = true;
