
/*!
 * Stylus - Renderer
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './parser.dart' show Parser;
import 'package:node_shims/js.dart';
import 'package:node_shims/path.dart';
import 'package:json_object/json_object.dart';
import 'package:stylus_dart/visitor/evaluator.dart';
import 'package:stylus_dart/nodes/index.dart' as nodes;
import 'package:stylus_dart/visitor/normalizer.dart';
import 'utils.dart' as utils;
import './visitor/deps-resolver.dart' show DepsResolver;

/**
 * Expose `Renderer`.
 */

//module.exports = Renderer;

/**
 * Initialize a new `Renderer` with the given `str` and `options`.
 *
 * @param {String} str
 * @param {Object} options
 * @api public
 */

class Renderer extends EventEmitter {
  var options;

  var str;

  Parser parser;

  var events;

  var evaluator;

  var nodes;

  var sourcemap;

	Renderer(str, options) {
  options = or(options, {});
  options.globals = or(options.globals, {});
  options.functions = or(options.functions, {});
  options.use = or(options.use, []);
  options.use = options.use is List ? options.use : [options.use];
  options.imports = [join([__dirname, 'functions'])];
  options.paths = or(options.paths, []);
  options.filename = or(options.filename, 'stylus');
  options.Evaluator = or(options.Evaluator, Evaluator);
  this.options = options;
  this.str = str;
  this.events = events;
}

/**
 * Expose events explicitly.
 */

//module.exports.events = events;

/**
 * Parse and evaluate AST, then callback `fn(err, css, js)`.
 *
 * @param {Function} fn
 * @api public
 */

render(fn) {

  var parser = this.parser = new Parser(this.str, this.options);

  // use plugin(s)
  for (var i = 0, len = this.options.use.length; i < len; i++) {
    this.use(this.options.use[i]);
  }

  try {
    nodes.filename = this.options.filename;
    // parse
    var ast = parser.parse();

    // evaluate
    this.evaluator = new this.options.Evaluator(ast, this.options);
    this.nodes = nodes;
    this.evaluator.renderer = this;
    ast = this.evaluator.evaluate();

    // normalize
    var normalizer = new Normalizer(ast, this.options);
    ast = normalizer.normalize();

    // compile
    var compiler = this.options.sourcemap
      ? new (require('./visitor/sourcemapper'))(ast, this.options)
      : new (require('./visitor/compiler'))(ast, this.options)
      , css = compiler.compile();

    // expose sourcemap
    if (this.options.sourcemap) this.sourcemap = compiler.map.toJSON();
  } catch (err) {
    var options = new JsonObject();
    options.input = err.input || this.str;
    options.filename = err.filename || this.options.filename;
    options.lineno = err.lineno || parser.lexer.lineno;
    options.column = err.column || parser.lexer.column;
    if (!fn) throw utils.formatException(err, options);
    return fn(utils.formatException(err, options));
  }

  // fire `end` event
  var listeners = this.listeners('end');
  if (fn) listeners.add(fn);
  for (var i = 0, len = listeners.length; i < len; i++) {
    var ret = listeners[i](null, css);
    if (ret) css = ret;
  }
  if (!fn) return css;
}

/**
 * Get dependencies of the compiled file.
 *
 * @param {String} [filename]
 * @return {Array}
 * @api public
 */

deps(filename) {

  var opts = utils.merge({ 'cache': false }, this.options);
  if (filename) opts.filename = filename;

  try {
    nodes.filename = opts.filename;
    // parse
    var ast = parser.parse()
      , resolver = new DepsResolver(ast, opts);

    // resolve dependencies
    return resolver.resolve();
  } catch (err) {
    var options = {};
    options.input = err.input || this.str;
    options.filename = err.filename || opts.filename;
    options.lineno = err.lineno || parser.lexer.lineno;
    options.column = err.column || parser.lexer.column;
    throw utils.formatException(err, options);
  }
}

/**
 * Set option `key` to `val`.
 *
 * @param {String} key
 * @param {Mixed} val
 * @return {Renderer} for chaining
 * @api public
 */

set(key, val) {

  this.options[key] = val;
  return this;
}

/**
 * Get option `key`.
 *
 * @param {String} key
 * @return {Mixed} val
 * @api public
 */

get(key) {

  return this.options[key];
}

/**
 * Include the given `path` to the lookup paths array.
 *
 * @param {String} path
 * @return {Renderer} for chaining
 * @api public
 */

include(path) {

  this.options.paths.add(path);
  return this;
}

/**
 * Use the given `fn`.
 *
 * This allows for plugins to alter the renderer in
 * any way they wish, exposing paths etc.
 *
 * @param {Function}
 * @return {Renderer} for chaining
 * @api public
 */

use(fn) {

  fn.call(this, this);
  return this;
}

/**
 * Define function or global var with the given `name`. Optionally
 * the function may accept full expressions, by setting `raw`
 * to `true`.
 *
 * @param {String} name
 * @param {Function|Node} fn
 * @return {Renderer} for chaining
 * @api public
 */

define(name, fn, raw) {

  fn = utils.coerce(fn, raw);

  if (fn.nodeName) {
    this.options.globals[name] = fn;
    return this;
  }

  // function
  this.options.functions[name] = fn;
  if (null != raw) fn.raw = raw;
  return this;
}

/**
 * Import the given `file`.
 *
 * @param {String} file
 * @return {Renderer} for chaining
 * @api public
 */

import(file) {

  this.options.imports.add(file);
  return this;
}


