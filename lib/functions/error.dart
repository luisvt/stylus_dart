import '../utils.dart' show utils;

/**
 * Throw an error with the given `msg`.
 *
 * @param {String} msg
 * @api public
 */

module.exports =  error(msg){
  utils.assertType(msg, 'string', 'msg');
  var err = new Error(msg.val);
  err.fromStylus = true;
  throw err;
};
