import '../utils.dart' show utils;

/**
 * Inspect the given `expr`.
 *
 * @param {Expression} expr
 * @api public
 */

(module.exports =  p(){
  super.slice()[].slice.call(arguments).forEach((expr){
    expr = utils.unwrap(expr);
    if (!expr.nodes.length) return;
    print('\u001b[90minspect:\u001b[0m %s', expr.toString().replace(new RegExp(r'^\(|\)$/'), ''));
  })
  return nodes.null;
}).raw = true;
