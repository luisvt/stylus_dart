import '../utils.dart' as utils;
import 'package:node_shims/js.dart';
import 'package:node_shims/path.dart' as path;

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
var use = new _Use();
class _Use {
  var renderer;

  var options;


  call(plugin, options) {
    utils.assertString(plugin, 'plugin');

    if (options) {
      utils.assertType(options, 'object', 'options');
      options = parseObject(options);
    }

    // lookup
    plugin = plugin.string;
    var found = utils.lookup(plugin, this.options.paths, this.options.filename);
    if (!found) throw new Exception('failed to locate plugin file "' + plugin + '"');

    // use
    var fn = require(path.resolve(found));
    if (fn is! Function) {
      throw new Exception('plugin "' + plugin + '" does not export a function');
    }
    this.renderer.use(fn(or(options, this.options)));
  }
}

/**
 * Attempt to parse object node to the javascript object.
 *
 * @param {Object} obj
 * @return {Object}
 * @api private
 */

 parseObject(obj){
  obj = obj.vals;
  convert(node){
    switch (node.nodeName) {
      case 'object':
        return parseObject(node);
      case 'boolean':
        return node.isTrue;
      case 'unit':
        return node.type ? node.toString() : node.val;
      case 'string':
      case 'literal':
        return node.val;
      default:
        return node.toString();
    }
  }

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
}
