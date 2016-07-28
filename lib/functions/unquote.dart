import '../utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Unquote the given `string`.
 *
 * Examples:
 *
 *    unquote("sans-serif")
 *    // => sans-serif
 *
 *    unquote(sans-serif)
 *    // => sans-serif
 *
 * @param {String|Ident} string
 * @return {Literal}
 * @api public
 */

unquote(string){
  utils.assertString(string, 'string');
  return new nodes.Literal(string.string);
}
