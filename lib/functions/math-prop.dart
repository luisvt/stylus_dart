import '../nodes.dart' show nodes;

/**
 * Get Math `prop`.
 *
 * @param {String} prop
 * @return {Unit}
 * @api private
 */

module.exports =  math(prop){
  return new nodes.Unit(Math[prop.string]);
};
