import '../utils.dart' as utils;
import 'package:node_shims/js.dart';
import '../nodes/index.dart' as nodes;

/**
 * Add property `name` with the given `expr`
 * to the mixin-able block.
 *
 * @param {String|Ident|Literal} name
 * @param {Expression} expr
 * @return {Property}
 * @api public
 */

addProperty(name, expr){
  utils.assertType(name, 'expression', 'name');
  name = utils.unwrap(name).first;
  utils.assertString(name, 'name');
  utils.assertType(expr, 'expression', 'expr');
  var prop = new nodes.Property([name], expr);
  var block = this.closestBlock;

  var len = block.nodes.length
    , head = slice(block.nodes, 0, block.index)
    , tail = slice(block.nodes, block.index++, len);
  head.add(prop);
  block.nodes = head.concat(tail);

  return prop;
}
