import '../utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Returns string with all matches of `pattern` replaced by `replacement` in given `val`
 *
 * @param {String} pattern
 * @param {String} replacement
 * @param {String|Ident} val
 * @return {String|Ident}
 * @api public
 */

replace(pattern, replacement, val){
  utils.assertString(pattern, 'pattern');
  utils.assertString(replacement, 'replacement');
  utils.assertString(val, 'val');
  pattern = new RegExp(pattern.string);
  var res = val.string.replace(pattern, replacement.string);
  return val is  nodes.Ident
    ? new nodes.Ident(res)
    : new nodes.String(res);
}
