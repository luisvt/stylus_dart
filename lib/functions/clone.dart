import '../utils.dart' as utils;

/**
 * Return a clone of the given `expr`.
 *
 * @param {Expression} expr
 * @return {Node}
 * @api public
 */

clone(expr){
  utils.assertPresent(expr, 'expr');
  return expr.clone();
}
