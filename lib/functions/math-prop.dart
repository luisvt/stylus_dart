import '../nodes/index.dart' as nodes;

/**
 * Get Math `prop`.
 *
 * @param {String} prop
 * @return {Unit}
 * @api private
 */

mathProp(prop){
  return new nodes.Unit(Math[prop.string]);
}
