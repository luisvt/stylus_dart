
/*!
 * Stylus - plugin - url
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import '../visitor/compiler.dart' show Compiler;
import 'package:node_shims/js.dart';
import 'package:stylus_dart/functions/extname.dart';
import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'package:stylus_dart/utils.dart' as utils;
import 'package:event_emitter/event_emitter.dart';

EventEmitter events = new EventEmitter();

/**
 * Mime table.
 */

var defaultMimes = {
    '.gif': 'image/gif'
  , '.png': 'image/png'
  , '.jpg': 'image/jpeg'
  , '.jpeg': 'image/jpeg'
  , '.svg': 'image/svg+xml'
  , '.webp': 'image/webp'
  , '.ttf': 'application/x-font-ttf'
  , '.eot': 'application/vnd.ms-fontobject'
  , '.woff': 'application/font-woff'
  , '.woff2': 'application/font-woff2'
};

/**
 * Supported encoding types
 */
var encodingTypes = {
  'BASE_64': 'base64',
  'UTF8': 'charset=utf-8'
};

/**
 * Return a url() function with the given `options`.
 *
 * Options:
 *
 *    - `limit` bytesize limit defaulting to 30Kb
 *    - `paths` image resolution path(s), merged with general lookup paths
 *
 * Examples:
 *
 *    stylus(str)
 *      .set('filename', __dirname + '/css/test.styl')
 *      .define('url', stylus.url({ paths: [__dirname + '/public'] }))
 *      .render(function(err, css){ ... })
 *
 * @param {Object} options
 * @return {Function}
 * @api public
 */

url(options) {
  options = or(options, {});

  List _paths = options.paths ?? [];
  var sizeLimit = null != options.limit ? options.limit : 30000;
  var mimes = options.mimes ?? defaultMimes;

  /**
   * @param {object} url - The path to the image you want to encode.
   * @param {object} enc - The encoding for the image. Defaults to base64, the 
   * other valid option is `utf8`.
   */
   fn(url, enc){
    // Compile the url
    var compiler = new Compiler(url)
      , encoding = encodingTypes.BASE_64;

    compiler.isURL = true;
    url = url.nodes.map((node){
      return compiler.visit(node);
    }).join('');

    // Parse literal
    url = Uri.parse(url);
    var ext = extname(url.pathname)
      , mime = mimes[ext]
      , hash = url.hash ?? ''
      , literal = new nodes.Literal('url("' + url.href + '")')
      , paths = _paths..addAll(this.paths)
      , buf
      , result;

    // Not supported
    if (!mime) return literal;

    // Absolute
    if (url.protocol) return literal;

    // Lookup
    var found = utils.lookup(url.pathname, paths);

    // Failed to lookup
    if (!found) {
      events.emit(
          'file not found'
        , 'File ' + literal + ' could not be found, literal url retained!'
      );

      return literal;
    }

    // Read data
    buf = fs.readFileSync(found);

    // Too large
    if (false != sizeLimit && buf.length > sizeLimit) return literal;

    if (enc && 'utf8' == enc.first.val.toLowerCase()) {
      encoding = encodingTypes.UTF8;
      result = buf.toString('utf8').replaceAll(new RegExp(r'\s+/'), ' ')
        .replaceAllMapped(new RegExp(r'[{}\|\\\^~\[\]`"<>#%]/'), (match) {
          return '%' + match[0].codeUnitAt(0).toRadixString(16).toUpperCase();
        }).trim();
    } else {
      result = buf.toString(encoding) + hash;
    }

    // Encode
    return new nodes.Literal('url("data:' + mime + ';' +  encoding + ',' + result + '")');
  };

  fn.raw = true;
  return fn;
}

// Exporting default mimes so we could easily access them
var mimes = defaultMimes;

