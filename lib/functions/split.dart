import '../utils.dart' as utils;
import 'dart:mirrors';
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Splits the given `val` by `delim`
 *
 * @param {String} delim
 * @param {String|Ident} val
 * @return {Expression}
 * @api public
 */

split(delim, val){
  utils.assertString(delim, 'delimiter');
  utils.assertString(val, 'val');
  var splitted = val.string.split(delim.string);
  var expr = new nodes.Expression();
  Type ItemNode = val is  nodes.Ident
    ? nodes.Ident
    : nodes.String;
  for (var i = 0, len = splitted.length; i < len; ++i) {
    expr.nodes.add(reflectClass(ItemNode).newInstance(const Symbol(''), [splitted[i]]).reflectee);
  }
  return expr;
}
