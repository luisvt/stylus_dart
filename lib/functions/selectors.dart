import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'package:stylus_dart/selector-parser.dart';

/**
 * Return a list with raw selectors parts
 * of the current group.
 *
 * For example:
 *
 *    .a, .b
 *      .c
 *        .d
 *          test: selectors() // => '.a,.b', '& .c', '& .d'
 *
 * @return {Expression}
 * @api public
 */

selectors(){
  var stack = this.selectorStack
    , expr = new nodes.Expression(true);

  if (stack.length) {
    for (var i = 0; i < stack.length; i++) {
      var group = stack[i]
        , nested;

      if (group.length > 1) {
        expr.add(new nodes.String(group.map((selector) {
          nested = new SelectorParser(selector.val).parse().nested;
          return (nested && i ? '& ' : '') + selector.val;
        }).join(',')));
      } else {
        var selector = group[0].val;
        nested = new SelectorParser(selector).parse().nested;
        expr.add(new nodes.String((nested && i ? '& ' : '') + selector));
      }
    }
  } else {
    expr.add(new nodes.String('&'));
  }
  return expr;
};
