import '../nodes/index.dart' as nodes;
import 'package:stylus_dart/functions/hsla.dart';
import 'package:stylus_dart/functions/component.dart';

/**
 * Return the lightness component of the given `color`,
 * or set the lightness component to the optional second `value` argument.
 *
 * Examples:
 *
 *    lightness(#00c)
 *    // => 100%
 *
 *    lightness(#00c, 80%)
 *    // => #99f
 *
 * @param {RGBA|HSLA} color
 * @param {Unit} [value]
 * @return {Unit|RGBA}
 * @api public
 */

lightness(color, value){
  if (value) {
    var hslaColor = color.hsla;
    return hsla(
      new nodes.Unit(hslaColor.h),
      new nodes.Unit(hslaColor.s),
      value,
      new nodes.Unit(hslaColor.a)
    );
  }
  return component(color, new nodes.String('lightness'));
}
