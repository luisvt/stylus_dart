import '../nodes/index.dart' as nodes;
import 'package:stylus_dart/functions/rgba.dart';

/**
 * Return the red component of the given `color`,
 * or set the red component to the optional second `value` argument.
 *
 * Examples:
 *
 *    red(#c00)
 *    // => 204
 *
 *    red(#000, 255)
 *    // => #f00
 *
 * @param {RGBA|HSLA} color
 * @param {Unit} [value]
 * @return {Unit|RGBA}
 * @api public
 */

red(color, value){
  color = color.rgba;
  if (value) {
    return rgba(
      value,
      new nodes.Unit(color.g),
      new nodes.Unit(color.b),
      new nodes.Unit(color.a)
    );
  }
  return new nodes.Unit(color.r, '');
}
