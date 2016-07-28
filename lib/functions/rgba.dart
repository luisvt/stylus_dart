import '../utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Return a `RGBA` from the r,g,b,a channels.
 *
 * Examples:
 *
 *    rgba(255,0,0,0.5)
 *    // => rgba(255,0,0,0.5)
 *
 *    rgba(255,0,0,1)
 *    // => #ff0000
 *
 *    rgba(#ffcc00, 50%)
 *    // rgba(255,204,0,0.5)
 *
 * @param {Unit|RGBA|HSLA} red
 * @param {Unit} green
 * @param {Unit} blue
 * @param {Unit} alpha
 * @return {RGBA}
 * @api public
 */

rgba(red, green, blue, alpha){
  switch (arguments.length) {
    case 1:
      utils.assertColor(red);
      return red.rgba;
    case 2:
      utils.assertColor(red);
      var color = red.rgba;
      utils.assertType(green, 'unit', 'alpha');
      alpha = green.clone();
      if ('%' == alpha.type) alpha.val /= 100;
      return new nodes.RGBA(
          color.r
        , color.g
        , color.b
        , alpha.val);
    default:
      utils.assertType(red, 'unit', 'red');
      utils.assertType(green, 'unit', 'green');
      utils.assertType(blue, 'unit', 'blue');
      utils.assertType(alpha, 'unit', 'alpha');
      var r = '%' == red.type ? (red.val * 2.55).round() : red.val
        , g = '%' == green.type ? (green.val * 2.55).round() : green.val
        , b = '%' == blue.type ? (blue.val * 2.55).round() : blue.val;

      alpha = alpha.clone();
      if (alpha && '%' == alpha.type) alpha.val /= 100;
      return new nodes.RGBA(
          r
        , g
        , b
        , alpha.val);
  }
}
