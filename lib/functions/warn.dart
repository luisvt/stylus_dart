import '../utils.dart' as utils;
import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Warn with the given `msg` prefixed by "Warning: ".
 *
 * @param {String} msg
 * @api public
 */

warn(msg){
  utils.assertType(msg, 'string', 'msg');
  print('Warning: %s' + msg.val);
  return nodes.$null;
}
