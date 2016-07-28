import '../utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Assign `type` to the given `unit` or return `unit`'s type.
 *
 * @param {Unit} unit
 * @param {String|Ident} type
 * @return {Unit}
 * @api public
 */

unit(unit, type){
  utils.assertType(unit, 'unit', 'unit');

  // Assign
  if (type) {
    utils.assertString(type, 'type');
    return new nodes.Unit(unit.val, type.string);
  } else {
    return unit.type ?? '';
  }
}
