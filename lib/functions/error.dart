import '../utils.dart' as utils;

/**
 * Throw an error with the given `msg`.
 *
 * @param {String} msg
 * @api public
 */

error(msg) {
  utils.assertType(msg, 'string', 'msg');
  var err = new Exception(msg.val);
  err.fromStylus = true;
  throw err;
}
