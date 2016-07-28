import '../utils.dart' as utils;
import '../nodes/index.dart' as nodes;

/**
 * Lookup variable `name` or return Null.
 *
 * @param {String} name
 * @return {Mixed}
 * @api public
 */

lookup(name){
  utils.assertType(name, 'string', 'name');
  var node = this.lookup(name.val);
  if (!node) return nodes.$null;
  return this.visit(node);
}
