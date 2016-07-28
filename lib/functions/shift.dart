import '../utils.dart' show utils;

/**
 * Shift an element from `expr`.
 *
 * @param {Expression} expr
 * @return {Node}
 * @api public
 */

 (module.exports = (expr){
   expr = utils.unwrap(expr);
   return shift(expr.nodes);
 }).raw = true;

