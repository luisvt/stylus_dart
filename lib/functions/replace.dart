import '../utils.dart' show utils;

/**
 * Returns string with all matches of `pattern` replaced by `replacement` in given `val`
 *
 * @param {String} pattern
 * @param {String} replacement
 * @param {String|Ident} val
 * @return {String|Ident}
 * @api public
 */

module.exports =  replace(pattern, replacement, val){
  utils.assertString(pattern, 'pattern');
  utils.assertString(replacement, 'replacement');
  utils.assertString(val, 'val');
  pattern = new RegExp(pattern.string, 'g');
  var res = val.string.replace(pattern, replacement.string);
  return val is  nodes.Ident
    ? new nodes.Ident(res)
    : new nodes.String(res);
};
