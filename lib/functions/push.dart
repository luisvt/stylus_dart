import '../utils.dart' as utils;

/**
 * Push the given args to `expr`.
 *
 * @param {Expression} expr
 * @param {Node} ...
 * @return {Unit}
 * @api public
 */

push(expr){
  expr = utils.unwrap(expr);
  for (var i = 1, len = arguments.length; i < len; ++i) {
    expr.nodes.add(utils.unwrap(arguments[i]).clone());
  }
  return expr.nodes.length;
}
