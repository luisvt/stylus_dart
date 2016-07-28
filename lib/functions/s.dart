import '../utils.dart' as utils;
import 'package:node_shims/js.dart';
import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'package:stylus_dart/visitor/compiler.dart';;

/**
 * Return a `Literal` with the given `fmt`, and
 * variable number of arguments.
 *
 * @param {String} fmt
 * @param {Node} ...
 * @return {Literal}
 * @api public
 */

s(fmt){
  fmt = utils.unwrap(fmt).nodes[0];
  utils.assertString(fmt);
  var self = this
    , str = fmt.string
    , args = arguments
    , i = 1;

  // format
  str = str.replace(new RegExp(r'%(s|d)/'), (_, specifier){
    var arg = or(args[i++], nodes.$null);
    switch (specifier) {
      case 's':
        return new Compiler(arg, self.options).compile();
      case 'd':
        arg = utils.unwrap(arg).first;
        if ('unit' != arg.nodeName) throw new Exception('%d requires a unit');
        return arg.val;
    }
  });

  return new nodes.Literal(str);
}
