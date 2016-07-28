import '../utils.dart' as utils;
import '../nodes/index.dart' as nodes;

/**
 * Color component name map.
 */

var componentMap = {
    'red': 'r'
  , 'green': 'g'
  , 'blue': 'b'
  , 'alpha': 'a'
  , 'hue': 'h'
  , 'saturation': 's'
  , 'lightness': 'l'
};

/**
 * Color component unit type map.
 */

var unitMap = {
    'hue': 'deg'
  , 'saturation': '%'
  , 'lightness': '%'
};

/**
 * Color type map.
 */

var typeMap = {
    'red': 'rgba'
  , 'blue': 'rgba'
  , 'green': 'rgba'
  , 'alpha': 'rgba'
  , 'hue': 'hsla'
  , 'saturation': 'hsla'
  , 'lightness': 'hsla'
};

/**
 * Return component `name` for the given `color`.
 *
 * @param {RGBA|HSLA} color
 * @param {String} name
 * @return {Unit}
 * @api public
 */

component(color, name) {
  utils.assertColor(color, 'color');
  utils.assertString(name, 'name');
  var _name = name.string
    , unit = unitMap[name]
    , type = typeMap[name];
  _name = componentMap[name];
  if (!name) throw new Exception('invalid color component "' + name + '"');
  return new nodes.Unit(color[type][name], unit);
}
