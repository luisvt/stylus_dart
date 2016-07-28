/*!
 * Stylus - SourceMapper
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './compiler.dart' show Compiler;

/**
 * Initialize a new `SourceMapper` generator with the given `root` Node
 * and the following `options`.
 *
 * @param {Node} root
 * @api public
 */

class SourceMapper {
	SourceMapper(root, options) {
  options = or(options, {});
  this.column = 1;
  this.lineno = 1;
  this.contents = {};
  this.filename = options.filename;
  this.dest = options.dest;

  var sourcemap = options.sourcemap;
  this.basePath = sourcemap.basePath || '.';
  this.inline = sourcemap.inline;
  this.comment = sourcemap.comment;
  if (this.dest && extname(this.dest) == '.css') {
    this.basename = basename(this.dest);
    this.dest = dirname(this.dest);
  } else {
    this.basename = basename(this.filename, extname(this.filename)) + '.css';
  }
  this.utf8 = false;

  this.map = new SourceMapGenerator({
    'file': this.basename,
    'sourceRoot': sourcemap.sourceRoot || null
  });
  Compiler.call(this, root, options);
	}
}

/**
 * Inherit from `Compiler.prototype`.
 */

SourceMapper.prototype.__proto__ = Compiler.prototype;

/**
 * Generate and write source map.
 *
 * @return {String}
 * @api private
 */

var compile = Compiler.prototype.compile;
compile() {

  var css = compile.call(this)
    , out = this.basename + '.map'
    , url = this.normalizePath(this.dest
      ? join(this.dest, out)
      : join(dirname(this.filename), out))
    , map;

  if (this.inline) {
    map = this.map.toString();
    url = 'data:application/json;'
      + (this.utf8 ?  'charset=utf-8;' : '') + 'base64,'
      + new Buffer(map).toString('base64');
  }
  if (this.inline || false != this.comment)
    css += '/*# sourceMappingURL=' + url + ' */';
  return css;
}

/**
 * Add mapping information.
 *
 * @param {String} str
 * @param {Node} node
 * @return {String}
 * @api private
 */

out(str, node) {

  if (node && node.lineno) {
    var filename = this.normalizePath(node.filename);

    this.map.addMapping({
      'original': {
        'line': node.lineno,
        'column': node.column - 1
      },
      'generated': {
        'line': this.lineno,
        'column': this.column - 1
      },
      'source': filename
    });

    if (this.inline && !this.contents[filename]) {
      this.map.setSourceContent(filename, fs.readFileSync(node.filename, 'utf-8'));
      this.contents[filename] = true;
    }
  }

  this.move(str);
  return str;
}

/**
 * Move current line and column position.
 *
 * @param {String} str
 * @api private
 */

move(str) {

  var lines = str.match(new RegExp(r'\n/'))
    , idx = str.lastIndexOf('\n');

  if (lines) this.lineno += lines.length;
  this.column = ~idx
    ? str.length - idx
    : this.column + str.length;
}

/**
 * Normalize the given `path`.
 *
 * @param {String} path
 * @return {String}
 * @api private
 */

normalizePath(path) {

  path = relative(this.dest || this.basePath, path);
  if ('\\' == sep) {
    path = path.replace(new RegExp(r'^[a-z]:\\/'), '/')
      .replace(new RegExp(r'\\/'), '/');
  }
  return path;
}

/**
 * Visit Literal.
 */

var literal = Compiler.prototype.visitLiteral;
visitLiteral(lit) {

  var val = literal.call(this, lit)
    , filename = this.normalizePath(lit.filename)
    , indentsRe = new RegExp(r'^\s+')
    , lines = val.split('\n');

  // add mappings for multiline literals
  if (lines.length > 1) {
    lines.forEach((line, i) {
      var indents = line.match(indentsRe)
        , column = indents && indents[0]
            ? indents[0].length
            : 0;

      if (lit.css) column += 2;

      this.map.addMapping({
        'original': {
          'line': lit.lineno + i,
          'column': column
        },
        'generated': {
          'line': this.lineno + i,
          'column': 0
        },
        'source': filename
      });
    }, this);
  }
  return val;
}

/**
 * Visit Charset.
 */

var charset = Compiler.prototype.visitCharset;
visitCharset(node) {

  this.utf8 = ('utf-8' == node.val.string.toLowerCase());
  return charset.call(this, node);
}