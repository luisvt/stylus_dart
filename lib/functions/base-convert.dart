import '../utils.dart' as utils;
import '../nodes/index.dart' as nodes;
import 'package:node_shims/js.dart';

/**
 * Return a `Literal` `num` converted to the provided `base`, padded to `width`
 * with zeroes (default width is 2)
 *
 * @param {Number} num
 * @param {Number} base
 * @param {Number} width
 * @return {Literal}
 * @api public
 */

baseConvert(num, base, width) {
  utils.assertPresent(num, 'number');
  utils.assertPresent(base, 'base');
  num = utils.unwrap(num).nodes[0].val;
  base = utils.unwrap(base).nodes[0].val;
  width = or((width && utils
      .unwrap(width)
      .nodes[0].val), 2);
  var result = num.toString(base);
  while (result.length < width) {
    result = '0' + result;
  }
  return new nodes.Literal(result);
}
