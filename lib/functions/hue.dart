import '../nodes/index.dart' as nodes;
import 'hsla.dart';
import 'component.dart';

/**
 * Return the hue component of the given `color`,
 * or set the hue component to the optional second `value` argument.
 *
 * Examples:
 *
 *    hue(#00c)
 *    // => 240deg
 *
 *    hue(#00c, 90deg)
 *    // => #6c0
 *
 * @param {RGBA|HSLA} color
 * @param {Unit} [value]
 * @return {Unit|RGBA}
 * @api public
 */

hue(color, value){
  if (value) {
    var hslaColor = color.hsla;
    return hsla(
      value,
      new nodes.Unit(hslaColor.s),
      new nodes.Unit(hslaColor.l),
      new nodes.Unit(hslaColor.a)
    );
  }
  return component(color, new nodes.String('hue'));
}
