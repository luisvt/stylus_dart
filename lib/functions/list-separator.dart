import '../utils.dart' show utils;

/**
 * Return the separator of the given `list`.
 *
 * Examples:
 *
 *    list1 = a b c
 *    list-separator(list1)
 *    // => ' '
 *
 *    list2 = a, b, c
 *    list-separator(list2)
 *    // => ','
 *
 * @param {Experssion} list
 * @return {String}
 * @api public
 */

(module.exports =  listSeparator(list){
  list = utils.unwrap(list);
  return new nodes.String(list.isList ? ',' : ' ');
}).raw = true;
