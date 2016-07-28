import 'package:path.dart' show path;

/**
 * Peform a path join.
 *
 * @param {String} path
 * @return {String}
 * @api public
 */

(module.exports =  pathjoin(){
  var paths = super.slice()[].slice.call(arguments).map((path){
    return path.first.string;
  });
  return path.join.apply(null, paths).replace(new RegExp(r'\\/'), '/');
}).raw = true;
