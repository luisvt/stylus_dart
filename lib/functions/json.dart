import '../utils.dart' as utils;
import '../nodes/index.dart' as nodes;
import 'dart:convert';
import 'package:json_object/json_object.dart';

/**
 * Convert a .json file into stylus variables or object.
 * Nested variable object keys are joined with a dash (-)
 *
 * Given this sample media-queries.json file:
 * {
 *   "small": "screen and (max-width:400px)",
 *   "tablet": {
 *     "landscape": "screen and (min-width:600px) and (orientation:landscape)",
 *     "portrait": "screen and (min-width:600px) and (orientation:portrait)"
 *   }
 * }
 *
 * Examples:
 *
 *    json('media-queries.json')
 *
 *    @media small
 *    // => @media screen and (max-width:400px)
 *
 *    @media tablet-landscape
 *    // => @media screen and (min-width:600px) and (orientation:landscape)
 *
 *    vars = json('vars.json', { hash: true })
 *    body
 *      width: vars.width
 *
 * @param {String} path
 * @param {Boolean} [local]
 * @param {String} [namePrefix]
 * @api public
*/

json(path, local, namePrefix){
  utils.assertString(path, 'path');

  // lookup
  path = path.string;
  var found = utils.lookup(path, this.options.paths, this.options.filename)
    , options = (local && 'object' == local.nodeName) && local;

  if (!found) {
    // optional JSON file
    if (options && options.get('optional').toBoolean().isTrue) {
      return nodes.$null;
    }
    throw new Exception('failed to locate .json file ' + path);
  }

  // read
  var json = JSON.decode(readFile(found, 'utf8'));

  convert(obj, options){
    var ret = new nodes.Object()
    , leaveStrings = options.get('leave-strings').toBoolean();

    for (var key in obj) {
      var val = obj[key];
      if (val is JsonObject) {
        ret.set(key, convert(val, options));
      } else {
        val = utils.coerce(val);
        if ('string' == val.nodeName && leaveStrings.isFalse) {
          val = utils.parseString(val.string);
        }
        ret.set(key, val);
      }
    }
    return ret;
  }

  if (options) {
    return convert(json, options);
  } else {
    oldJson(json, local, namePrefix);
  }
}

/**
 * Old `json` BIF.
 *
 * @api private
 */

oldJson(json, local, namePrefix){
  if (namePrefix) {
    utils.assertString(namePrefix, 'namePrefix');
    namePrefix = namePrefix.val;
  } else {
    namePrefix = '';
  }
  local = local ? local.toBoolean() : new nodes.Boolean$(local);
  var scope = local.isTrue ? this.currentScope : this.global.scope;

  convert(obj, [prefix]){
    prefix = prefix ? prefix + '-' : '';
    for (var key in obj){
      var val = obj[key];
      var name = prefix + key;
      if (val is JsonObject) {
        convert(val, name);
      } else {
        val = utils.coerce(val);
        if ('string' == val.nodeName) val = utils.parseString(val.string);
        scope.add({ 'name': namePrefix + name, 'val': val });
      }
    }
  }

  convert(json);
  return;

}
