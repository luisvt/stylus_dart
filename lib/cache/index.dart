import 'memory.dart';
import 'null.dart';
import 'fs.dart';

/**
 * Get cache object by `name`.
 *
 * @param {String|Function} name
 * @param {Object} options
 * @return {Object}
 * @api private
 */
getCache(name, options) {
  switch (name) {
   case 'fs':
     return new FSCache(options);
    case 'memory':
      return new MemoryCache(options);
    default:
      return new NullCache();
  }
}
