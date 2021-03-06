import '../utils.dart' as utils;
import 'package:node_shims/js.dart';
import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'dart:math' as Math;

/**
 * Returns the transparent version of the given `top` color,
 * as if it was blend over the given `bottom` color.
 *
 * Examples:
 *
 *     transparentify(#808080)
 *     => rgba(0,0,0,0.5)
 *
 *     transparentify(#414141, #000)
 *     => rgba(255,255,255,0.25)
 *
 *     transparentify(#91974C, #F34949, 0.5)
 *     => rgba(47,229,79,0.5)
 *
 * @param {RGBA|HSLA} top
 * @param {RGBA|HSLA} [bottom=#fff]
 * @param {Unit} [alpha]
 * @return {RGBA}
 * @api public
 */
transparentify(top, bottom, alpha){
  utils.assertColor(top);
  top = top.rgba;
  // Handle default arguments
  bottom = or(bottom, new nodes.RGBA(255, 255, 255, 1));
  if (!alpha && bottom && !bottom.rgba) {
    alpha = bottom;
    bottom = new nodes.RGBA(255, 255, 255, 1);
  }
  utils.assertColor(bottom);
  bottom = bottom.rgba;
  var bestAlpha = ['r', 'g', 'b'].map((channel){
    return (top[channel] - bottom[channel]) / ((0 < (top[channel] - bottom[channel]) ? 255 : 0) - bottom[channel]);
  }).toList()
    ..sort((a, b){return b - a;})
    ..[0];
  if (alpha) {
    utils.assertType(alpha, 'unit', 'alpha');
    if ('%' == alpha.type) {
      bestAlpha = alpha.val / 100;
    } else if (!alpha.type) {
      bestAlpha = alpha = alpha.val;
    }
  }
  bestAlpha = Math.max(Math.min(bestAlpha, 1), 0);
  // Calculate the resulting color
   processChannel(channel) {
    if (0 == bestAlpha) {
      return bottom[channel];
    } else {
      return bottom[channel] + (top[channel] - bottom[channel]) / bestAlpha;
    }
  }
  return new nodes.RGBA(
    processChannel('r'),
    processChannel('g'),
    processChannel('b'),
    (bestAlpha * 100).round() / 100
  );
}
