import '../utils.dart' show utils;

/**
*  Use the given `plugin`
*  
*  Examples:
*
*     use("plugins/add.js")
*
*     width add(10, 100)
*     // => width: 110
*/

module.exports =  use(plugin, options){
  utils.assertString(plugin, 'plugin');

  if (options) {
    utils.assertType(options, 'object', 'options');
    options = parseObject(options);
  }

  // lookup
  plugin = plugin.string;
  var found = utils.lookup(plugin, this.options.paths, this.options.filename);
  if (!found) throw new Error('failed to locate plugin file "' + plugin + '"');

  // use
  import 'package:ath.resolve(found.dart' show fn;
  if ('function' != typeof fn) {
    throw new Error('plugin "' + plugin + '" does not export a function');
  }
  this.renderer.use(fn(or(options, this.options)));
};

/**
 * Attempt to parse object node to the javascript object.
 *
 * @param {Object} obj
 * @return {Object}
 * @api private
 */

 parseObject(obj){
  obj = obj.vals;
  for (var key in obj) {
    var nodes = obj[key].nodes[0].nodes;
    if (nodes && nodes.length) {
      obj[key] = [];
      for (var i = 0, len = nodes.length; i < len; ++i) {
        obj[key].add(convert(nodes[i]));
      }
    } else {
      obj[key] = convert(obj[key].first);
    }
  }
  return obj;

   convert(node){
    switch (node.nodeName) {
      case 'object':
        return parseObject(node);
      case 'boolean':
        return node.isTrue;
      case 'unit':
        return node.type ? node.toString() : +node.val;
      case 'string':
      case 'literal':
        return node.val;
      default:
        return node.toString();
    }
  }
}