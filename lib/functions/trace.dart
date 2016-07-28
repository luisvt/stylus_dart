import 'package:stylus_dart/nodes/index.dart' as nodes;

/**
 * Output stack trace.
 *
 * @api public
 */
trace(){
  print(this.stack);
  return nodes.$null;
}
