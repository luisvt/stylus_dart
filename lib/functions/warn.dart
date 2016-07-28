import '../utils.dart' show utils;

/**
 * Warn with the given `msg` prefixed by "Warning: ".
 *
 * @param {String} msg
 * @api public
 */

module.exports =  warn(msg){
  utils.assertType(msg, 'string', 'msg');
  console.warn('Warning: %s', msg.val);
  return nodes.null;
};
