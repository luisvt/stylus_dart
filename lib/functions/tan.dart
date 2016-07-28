import '../utils.dart' show utils;

/**
 * Return the tangent of the given `angle`.
 *
 * @param {Unit} angle
 * @return {Unit}
 * @api public
 */

module.exports =  tan(angle) {
  utils.assertType(angle, 'unit', 'angle');

  var radians = angle.val;

  if (angle.type == 'deg') {
    radians *= Math.PI / 180;
  }

  var m = Math.pow(10, 9);

  var sin = (Math.sin(radians) * m).round() / m
    , cos = (Math.cos(radians) * m).round() / m
    , tan = (m * sin / cos ).round() / m;

  return new nodes.Unit(tan, '');
};
