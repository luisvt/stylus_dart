/**
 * Module dependencies.
 */

import '../visitor/compiler.dart' show Compiler;
import 'package:node_shims/js.dart';
import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'package:stylus_dart/utils.dart' as utils;
import 'package:node_shims/path.dart';
import 'dart:core';

/**
 * Return a url() function which resolves urls.
 *
 * Options:
 *
 *    - `paths` resolution path(s), merged with general lookup paths
 *    - `nocheck` don't check file existence
 *
 * Examples:
 *
 *    stylus(str)
 *      .set('filename', __dirname + '/css/test.styl')
 *      .define('url', stylus.resolver({ nocheck: true }))
 *      .render(function(err, css){ ... })
 *
 * @param {Object} [options]
 * @return {Function}
 * @api public
 */

resolver(options) {
  options = or(options, {});

  var resolver = new _Resolver();

  // Expose options to Evaluator
  resolver.options = options;
  resolver.raw = true;
  return resolver;
}

class _Resolver {
  String filename;

  var options;

  var paths;

  bool includeCSS;

  bool raw;

  call(url) {
    // Compile the url
    var compiler = new Compiler(url)
    , filename = url.filename;
    compiler.isURL = true;
    url = Uri.parse(url.nodes.map((node){
      return compiler.visit(node);
    }).join(''));

    // Parse literal
    var literal = new nodes.Literal('url("' + url.href + '")')
    , path = url.pathname
    , dest = this.options.dest
    , tail = ''
    , res;

    // Absolute or hash
    if (url.protocol || !path || '/' == path[0]) return literal;

    // Check that file exists
    if (!options.nocheck) {
      var _paths = options.paths ?? [];
      path = utils.lookup(path, _paths.concat(this.paths));
      if (!path) return literal;
    }

    if (this.includeCSS && extname(path) == '.css')
      return new nodes.Literal(url.href);

    if (url.search) tail += url.search;
    if (url.hash) tail += url.hash;

    if (dest && extname(dest) == '.css')
      dest = dirname(dest);

    res = relative(or(dest, dirname(this.filename)), options.nocheck
        ? join([dirname(filename), path])
        : path) + tail;

    if ('\\' == sep) res = res.replaceAll(new RegExp(r'\\/'), '/');

    return new nodes.Literal('url("' + res + '")');
  }
}