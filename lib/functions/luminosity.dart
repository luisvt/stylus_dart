import '../utils.dart' as utils;
import 'dart:math' as Math;
import '../nodes/index.dart' as nodes;

/**
 * Returns the relative luminance of the given `color`,
 * see http://www.w3.org/TR/WCAG20/#relativeluminancedef
 *
 * Examples:
 *
 *     luminosity(white)
 *     // => 1
 * 
 *     luminosity(#000)
 *     // => 0
 * 
 *     luminosity(red)
 *     // => 0.2126
 *
 * @param {RGBA|HSLA} color
 * @return {Unit}
 * @api public
 */

luminosity(color){
  utils.assertColor(color);
  color = color.rgba;
   processChannel(channel) {
    channel = channel / 255;
    return (0.03928 > channel)
      ? channel / 12.92
      : Math.pow(((channel + 0.055) / 1.055), 2.4);
  }
  return new nodes.Unit(
    0.2126 * processChannel(color.r)
    + 0.7152 * processChannel(color.g)
    + 0.0722 * processChannel(color.b)
  );
}
