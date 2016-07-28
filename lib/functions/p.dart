import '../utils.dart' as utils;
import '../nodes/index.dart' as nodes;
import 'package:node_shims/js.dart';

/**
 * Inspect the given `expr`.
 *
 * @param {Expression} expr
 * @api public
 */

p(arguments){
  slice(arguments, 0).forEach((expr){
    expr = utils.unwrap(expr);
    if (!expr.nodes.length) return;
    print('\u001b[90minspect:\u001b[0m %s' + expr.toString().replaceAll(new RegExp(r'^\(|\)$/'), ''));
  });
  return nodes.$null;
}
