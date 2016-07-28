import '../utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Returns substring of the given `val`.
 *
 * @param {String|Ident} val
 * @param {Number} start
 * @param {Number} [length]
 * @return {String|Ident}
 * @api public
 */

substr(val, start, length){
  utils.assertString(val, 'val');
  utils.assertType(start, 'unit', 'start');
  length = length && length.val;
  var res = val.string.substr(start.val, length);
  return val is  nodes.Ident
      ? new nodes.Ident(res)
      : new nodes.String(res);
}
