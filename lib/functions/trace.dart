import '../nodes.dart' show nodes;

/**
 * Output stack trace.
 *
 * @api public
 */

module.exports =  trace(){
  print(this.stack);
  return nodes.null;
};
