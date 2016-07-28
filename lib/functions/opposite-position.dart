import '../utils.dart' show utils;

/**
 * Return the opposites of the given `positions`.
 *
 * Examples:
 *
 *    opposite-position(top left)
 *    // => bottom right
 *
 * @param {Expression} positions
 * @return {Expression}
 * @api public
 */

(module.exports =  oppositePosition(positions){
  var expr = [];
  utils.unwrap(positions).nodes.forEach((pos, i){
    utils.assertString(pos, 'position ' + i);
    pos = ((){ switch (pos.string) {
      case 'top': return 'bottom';
      case 'bottom': return 'top';
      case 'left': return 'right';
      case 'right': return 'left';
      case 'center': return 'center';
      default: throw new Error('invalid position ' + pos);
    }})();
    expr.add(new nodes.Literal(pos));
  });
  return expr;
}).raw = true;
