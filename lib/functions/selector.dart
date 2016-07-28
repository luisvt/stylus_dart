import '../utils.dart' as utils;
import '../selector-parser.dart' show SelectorParser;
import 'package:stylus_dart/parser.dart';

/**
 * Return the current selector or compile
 * selector from a string or a list.
 *
 * @param {String|Expression}
 * @return {String}
 * @api public
 */

selector(){
  var stack = this.selectorStack
    , args = arguments;

  if (1 == args.length) {
    var expr = utils.unwrap(args[0])
      , len = expr.nodes.length;

    // selector('.a')
    if (1 == len) {
      utils.assertString(expr.first, 'selector');
      var val = expr.first.string
      , parsed = new SelectorParser(val).parse().val;

      if (parsed == val) return val;

      stack.add(parse(val));
    } else if (len > 1) {
      // selector-list = '.a', '.b', '.c'
      // selector(selector-list)
      if (expr.isList) {
        pushToStack(expr.nodes, stack);
      // selector('.a' '.b' '.c')
      } else {
        stack.add(parse(expr.nodes.map((node){
          utils.assertString(node, 'selector');
          return node.string;
        }).join(' ')));
      }
    }
  // selector('.a', '.b', '.c')
  } else if (args.length > 1) {
    pushToStack(args, stack);
  }

  return stack.length ? utils.compileSelectors(stack).join(',') : '&';
}

 pushToStack(selectors, stack) {
  selectors.forEach((sel) {
    sel = sel.first;
    utils.assertString(sel, 'selector');
    stack.add(parse(sel.string));
  });
}

 parse(selector) {
  var parser = new Parser(selector)
    , nodes;
  parser.state.add('selector-parts');
  nodes = parser.selector();
  nodes.forEach((node) {
    node.val = node.segments.map((seg){
      return seg.toString();
    }).join('');
  });
  return nodes;
}
