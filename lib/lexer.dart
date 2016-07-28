
/*!
 * Stylus - Lexer
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './token.dart' show Token;
import 'package:node_shims/js.dart';
import 'nodes/index.dart' as nodes;
import 'errors.dart' as errors;

/**
 * Expose `Lexer`.
 */

//exports = module.exports = Lexer;
/**
 * Operator aliases.
 */

var alias = {
    'and': '&&'
  , 'or': '||'
  , 'is': '=='
  , 'isnt': '!='
  , 'is not': '!='
  , ':=': '?='
};

class Lexer {
  List stash;

  List indentStack;

  RegExp indentRe;

  int lineno;

  int column;

  String str;

  var prev;

  bool isURL;

/**
 * Initialize a new `Lexer` with the given `str` and `options`.
 *
 * @param {String} str
 * @param {Object} options
 * @api private
 */

 Lexer(str, options) {
  options = or(options, {});
  this.stash = [];
  this.indentStack = [];
  this.indentRe = null;
  this.lineno = 1;
  this.column = 1;

  // HACK!
   comment(str, val, offset, s) {
    var inComment = s.lastIndexOf('/*', offset) > s.lastIndexOf('*/', offset)
      , commentIdx = s.lastIndexOf('//', offset)
      , i = s.lastIndexOf('\n', offset)
      , double = 0
      , single = 0;

    if (~commentIdx && commentIdx > i) {
      while (i != offset) {
        if ("'" == s[i]) single ? single-- : single++;
        if ('"' == s[i]) double ? double-- : double++;

        if ('/' == s[i] && '/' == s[i + 1]) {
          inComment = !single && !double;
          break;
        }
        ++i;
      }
    }

    return inComment
      ? str
      : val + '\r';
  }

  // Remove UTF-8 BOM.
  if ('\uFEFF' == str.charAt(0)) str = slice(str, 1);

  this.str = str
    .replace(new RegExp(r'\s+$'), '\n')
    .replace(new RegExp(r'\r\n?/'), '\n')
    .replace(new RegExp(r'\\ *\n/'), '\r')
    .replace(new RegExp(r'([,(:](?!\/\/[^ ])) *(?:\/\/[^\n]*|\/\*.*?\*\/)?\n\s*/'), comment)
    .replace(new RegExp(r'\s*\n[ \t]*([,)])/'), comment);;
}

  /**
   * Custom inspect.
   */

  inspect(){
    var tok
      , tmp = this.str
      , buf = [];
    while ('eos' != (tok = this.next()).type) {
      buf.add(tok.inspect());
    }
    this.str = tmp;
    return buf.concat(tok.inspect()).join('\n');
  }

  /**
   * Lookahead `n` tokens.
   *
   * @param {Number} n
   * @return {Object}
   * @api private
   */

  lookahead(n){
    var fetch = n - this.stash.length;
    while (fetch-- > 0) this.stash.add(this.advance());
    return this.stash[--n];
  }

  /**
   * Consume the given `len`.
   *
   * @param {Number|Array} len
   * @api private
   */

  skip(len){
    var chunk = len[0];
    len = chunk ? chunk.length : len;
    this.str = this.str.substring(len);
    if (chunk) {
      this.move(chunk);
    } else {
      this.column += len;
    }
  }

  /**
   * Move current line and column position.
   *
   * @param {String} str
   * @api private
   */

  move(str){
    var lines = str.match(new RegExp(r'\n/'))
      , idx = str.lastIndexOf('\n');

    if (lines) this.lineno += lines.length;
    this.column = ~idx
      ? str.length - idx
      : this.column + str.length;
  }

  /**
   * Fetch next token including those stashed by peek.
   *
   * @return {Token}
   * @api private
   */

  next() {
    var tok = or(this.stashed(), this.advance());
    this.prev = tok;
    return tok;
  }

  /**
   * Check if the current token is a part of selector.
   *
   * @return {Boolean}
   * @api private
   */

  isPartOfSelector() {
    var tok = or(this.stash[this.stash.length - 1], this.prev);
    switch (tok?.type) {
      // #for
      case 'color':
        return 2 == tok.val.raw.length;
      // .or
      case '.':
      // [is]
      case '[':
        return true;
    }
    return false;
  }

  /**
   * Fetch next token.
   *
   * @return {Token}
   * @api private
   */

  advance() {
    var column = this.column
      , line = this.lineno
      , tok = this.eos() ??
        this.$null()
      ?? this.sep()
      ?? this.keyword()
      ?? this.urlchars()
      ?? this.comment()
      ?? this.newline()
      ?? this.escaped()
      ?? this.important()
      ?? this.literal()
      ?? this.anonFunc()
      ?? this.atrule()
      ?? this.function()
      ?? this.brace()
      ?? this.paren()
      ?? this.color()
      ?? this.string()
      ?? this.unit()
      ?? this.namedop()
      ?? this.boolean()
      ?? this.unicode()
      ?? this.ident()
      ?? this.op()
      ?? this.eol()
      ?? this.space()
      ?? this.selector();
    tok.lineno = line;
    tok.column = column;
    return tok;
  }

  /**
   * Lookahead a single token.
   *
   * @return {Token}
   * @api private
   */

  peek() {
    return this.lookahead(1);
  }

  /**
   * Return the next possibly stashed token.
   *
   * @return {Token}
   * @api private
   */

  stashed() {
    return shift(this.stash);
  }

  /**
   * EOS | trailing outdents.
   */

  eos() {
    if (this.str.isNotEmpty) return null;
    if (this.indentStack.isNotEmpty) {
      shift(this.indentStack);
      return new Token('outdent');
    } else {
      return new Token('eos');
    }
  }

  /**
   * url char
   */

  urlchars() {
    var captures;
    if (!this.isURL) return null;
    if (truthy(captures = new RegExp(r'^[\/:@.;?&=*!,<>#%0-9]+').allMatches(this.str))) {
      this.skip(captures);
      return new Token('literal', new nodes.Literal(captures[0]));
    }
  }

  /**
   * ';' [ \t]*
   */

  sep() {
    var captures;
    if (truthy(captures = new RegExp(r'^;[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      return new Token(';');
    }
  }

  /**
   * '\r'
   */

  eol() {
    if ('\r' == this.str[0]) {
      ++this.lineno;
      this.skip(1);
      return this.advance();
    }
  }

  /**
   * ' '+
   */

  space() {
    var captures;
    if (truthy(captures = new RegExp(r'^([ \t]+)').allMatches(this.str))) {
      this.skip(captures);
      return new Token('space');
    }
  }

  /**
   * '\\' . ' '*
   */

  escaped() {
    var captures;
    if (truthy(captures = new RegExp(r'^\\(.)[ \t]*').allMatches(this.str))) {
      var c = captures[1];
      this.skip(captures);
      return new Token('ident', new nodes.Literal(c));
    }
  }

  /**
   * '@css' ' '* '{' .* '}' ' '*
   */

  literal() {
    // HACK attack !!!
    var captures;
    if (truthy(captures = new RegExp(r'^@css[ \t]*\{').allMatches(this.str))) {
      this.skip(captures);
      var c
        , braces = 1
        , css = ''
        , node;
      while (truthy(c = this.str[0])) {
        this.str = this.str.substring(1);
        switch (c) {
          case '{': ++braces; break;
          case '}': --braces; break;
          case '\n':
          case '\r':
            ++this.lineno;
            break;
        }
        css += c;
        if (!braces) break;
      }
      css = css.replaceAll(new RegExp(r'\s*}$'), '');
      node = new nodes.Literal(css);
      node.css = true;
      return new Token('literal', node);
    }
  }

  /**
   * '!important' ' '*
   */

  important() {
    var captures;
    if (truthy(captures = new RegExp(r'^!important[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      return new Token('ident', new nodes.Literal('!important'));
    }
  }

  /**
   * '{' | '}'
   */

  brace() {
    var captures;
    if (truthy(captures = new RegExp(r'^([{}])').allMatches(this.str))) {
      this.skip(1);
      var brace = captures[1];
      return new Token(brace, brace);
    }
  }

  /**
   * '(' | ')' ' '*
   */

  paren() {
    var captures;
    if (truthy(captures = new RegExp(r'^([()])([ \t]*)').allMatches(this.str))) {
      var paren = captures[1];
      this.skip(captures);
      if (')' == paren) this.isURL = false;
      var tok = new Token(paren, paren);
      tok.space = captures[2];
      return tok;
    }
  }

  /**
   * 'null'
   */

  $null() {
    var captures
      , tok;
    if (truthy(captures = new RegExp(r'^(null)\b[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      if (this.isPartOfSelector()) {
        tok = new Token('ident', new nodes.Ident(captures[0]));
      } else {
        tok = new Token('null', nodes.$null);
      }
      return tok;
    }
  }

  /**
   *   'if'
   * | 'else'
   * | 'unless'
   * | 'return'
   * | 'for'
   * | 'in'
   */

  keyword() {
    var captures
      , tok;
    if (truthy(captures = new RegExp(r'^(return|if|else|unless|for|in)\b[ \t]*').allMatches(this.str))) {
      var keyword = captures[1];
      this.skip(captures);
      if (this.isPartOfSelector()) {
        tok = new Token('ident', new nodes.Ident(captures[0]));
      } else {
        tok = new Token(keyword, keyword);
      }
      return tok;
    }
  }

  /**
   *   'not'
   * | 'and'
   * | 'or'
   * | 'is'
   * | 'is not'
   * | 'isnt'
   * | 'is a'
   * | 'is defined'
   */

  namedop() {
    var captures
      , tok;
    if (truthy(captures = new RegExp(r'^(not|and|or|is a|is defined|isnt|is not|is)(?!-)\b([ \t]*)').allMatches(this.str))) {
      var op = captures[1];
      this.skip(captures);
      if (this.isPartOfSelector()) {
        tok = new Token('ident', new nodes.Ident(captures[0]));
      } else {
        op = or(alias[op], op);
        tok = new Token(op, op);
      }
      tok.space = captures[2];
      return tok;
    }
  }

  /**
   *   ','
   * | '+'
   * | '+='
   * | '-'
   * | '-='
   * | '*'
   * | '*='
   * | '/'
   * | '/='
   * | '%'
   * | '%='
   * | '**'
   * | '!'
   * | '&'
   * | '&&'
   * | '||'
   * | '>'
   * | '>='
   * | '<'
   * | '<='
   * | '='
   * | '=='
   * | '!='
   * | '!'
   * | '~'
   * | '?='
   * | ':='
   * | '?'
   * | ':'
   * | '['
   * | ']'
   * | '.'
   * | '..'
   * | '...'
   */

  op() {
    var captures;
    if (truthy(captures = new RegExp(r'^([.]{1,3}|&&|\|\||[!<>=?:]=|\*\*|[-+*\/%]=?|[,=?:!~<>&\[\]])([ \t]*)').allMatches(this.str))) {
      var op = captures[1];
      this.skip(captures);
      op = or(alias[op], op);
      var tok = new Token(op, op);
      tok.space = captures[2];
      this.isURL = false;
      return tok;
    }
  }

  /**
   * '@('
   */

  anonFunc() {
    var tok;
    if ('@' == this.str[0] && '(' == this.str[1]) {
      this.skip(2);
      tok = new Token('function', new nodes.Ident('anonymous'));
      tok.anonymous = true;
      return tok;
    }
  }

  /**
   * '@' (-(\w+)-)?[a-zA-Z0-9-_]+
   */

  atrule() {
    var captures;
    if (truthy(captures = new RegExp(r'^@(?:-(\w+)-)?([a-zA-Z0-9-_]+)[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var vendor = captures[1]
        , type = captures[2]
        , tok;
      switch (type) {
        case 'require':
        case 'import':
        case 'charset':
        case 'namespace':
        case 'media':
        case 'scope':
        case 'supports':
          return new Token(type);
        case 'document':
          return new Token('-moz-document');
        case 'block':
          return new Token('atblock');
        case 'extend':
        case 'extends':
          return new Token('extend');
        case 'keyframes':
          return new Token(type, vendor);
        default:
          return new Token('atrule', (vendor ? '-' + vendor + '-' + type : type));
      }
    }
  }

  /**
   * '//' *
   */

  comment() {
    // Single line
    if ('/' == this.str[0] && '/' == this.str[1]) {
      var end = this.str.indexOf('\n');
      if (-1 == end) end = this.str.length;
      this.skip(end);
      return this.advance();
    }

    // Multi-line
    if ('/' == this.str[0] && '*' == this.str[1]) {
      var end = this.str.indexOf('*/');
      if (-1 == end) end = this.str.length;
      var str = this.str.substring(0, end + 2)
        , lines = str.split(new RegExp(r'\n|\r')).length - 1
        , suppress = true
        , inline = false;
      this.lineno += lines;
      this.skip(end + 2);
      // output
      if ('!' == str[2]) {
        str = str.replace('*!', '*');
        suppress = false;
      }
      if (this.prev && ';' == this.prev.type) inline = true;
      return new Token('comment', new nodes.Comment(str, suppress, inline));
    }
  }

  /**
   * 'true' | 'false'
   */

  boolean() {
    var captures;
    if (truthy(captures = new RegExp(r'^(true|false)\b([ \t]*)').allMatches(this.str))) {
      var val = nodes.Boolean('true' == captures[1]);
      this.skip(captures);
      var tok = new Token('boolean', val);
      tok.space = captures[2];
      return tok;
    }
  }

  /**
   * 'U+' [0-9A-Fa-f?]{1,6}(?:-[0-9A-Fa-f]{1,6})?
   */

  unicode() {
    var captures;
    if (truthy(captures = new RegExp(r'^u\+[0-9a-f?]{1,6}(?:-[0-9a-f]{1,6})?/').allMatches(this.str))) {
      this.skip(captures);
      return new Token('literal', new nodes.Literal(captures[0]));
    }
  }

  /**
   * -*[_a-zA-Z$] [-\w\d$]* '('
   */

  function() {
    var captures;
    if (truthy(captures = new RegExp(r'^(-*[_a-zA-Z$][-\w\d$]*)\(([ \t]*)').allMatches(this.str))) {
      var name = captures[1];
      this.skip(captures);
      this.isURL = 'url' == name;
      var tok = new Token('function', new nodes.Ident(name));
      tok.space = captures[2];
      return tok;
    }
  }

  /**
   * -*[_a-zA-Z$] [-\w\d$]*
   */

  ident() {
    var captures;
    if (truthy(captures = new RegExp(r'^-*[_a-zA-Z$][-\w\d$]*').allMatches(this.str))) {
      this.skip(captures);
      return new Token('ident', new nodes.Ident(captures[0]));
    }
  }

  /**
   * '\n' ' '+
   */

  newline() {
    var captures, re;

    // we have established the indentation regexp
    if (truthy(this.indentRe)){
      captures = this.indentRe.allMatches(this.str);
    // figure out if we are using tabs or spaces
    } else {
      // try tabs
      re = new RegExp(r'^\n([\t]*)[ \t]*');
      captures = re.allMatches(this.str);

      // nope, try spaces
      if (captures && !captures[1].length) {
        re = new RegExp(r'^\n([ \t]*)');
        captures = re.allMatches(this.str);
      }

      // established
      if (captures && captures[1].length) this.indentRe = re;
    }


    if (captures) {
      var tok
        , indents = captures[1].length;

      this.skip(captures);
      if (this.str[0] == ' ' || this.str[0] == '\t') {
        throw new errors.SyntaxError('Invalid indentation. You can use tabs or spaces to indent, but not both.');
      }

      // Blank line
      if ('\n' == this.str[0]) return this.advance();

      // Outdent
      if (this.indentStack.isNotEmpty && indents < this.indentStack[0]) {
        while (this.indentStack.isNotEmpty && this.indentStack[0] > indents) {
          this.stash.add(new Token('outdent'));
          shift(this.indentStack);
        }
        tok = pop(this.stash);
      // Indent
      } else if (indents && indents != this.indentStack[0]) {
        unshift(this.indentStack, indents);
        tok = new Token('indent');
      // Newline
      } else {
        tok = new Token('newline');
      }

      return tok;
    }
  }

  /**
   * '-'? (digit+ | digit* '.' digit+) unit
   */

  unit() {
    var captures;
    if (truthy(captures = new RegExp(r'^(-)?(\d+\.\d+|\d+|\.\d+)(%|[a-zA-Z]+)?[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var n = double.parse(captures[2]);
      if ('-' == captures[1]) n = -n;
      var node = new nodes.Unit(n, captures[3]);
      node.raw = captures[0];
      return new Token('unit', node);
    }
  }

  /**
   * '"' [^"]+ '"' | "'"" [^']+ "'"
   */

  string() {
    var captures;
    if (truthy(captures = new RegExp('^("[^"]*"|\'[^\']*\')[ \\t]*').allMatches(this.str))) {
      var str = captures[1]
        , quote = captures[0][0];
      this.skip(captures);
      str = str.substring(1,-1).replace(new RegExp(r'\\n/'), '\n');
      return new Token('string', new nodes.String(str, quote));
    }
  }

  /**
   * #rrggbbaa | #rrggbb | #rgba | #rgb | #nn | #n
   */

  color() {
    return this.rrggbbaa()
        ?? this.rrggbb()
      ?? this.rgba()
      ?? this.rgb()
      ?? this.nn()
      ?? this.n();
  }

  /**
   * #n
   */

  n() {
    var captures;
    if (truthy(captures = new RegExp(r'^#([a-fA-F0-9]{1})[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var n = int.parse(captures[1] + captures[1], radix: 16)
        , color = new nodes.RGBA(n, n, n, 1);
      color.raw = captures[0];
      return new Token('color', color);
    }
  }

  /**
   * #nn
   */

  nn() {
    var captures;
    if (truthy(captures = new RegExp(r'^#([a-fA-F0-9]{2})[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var n = int.parse(captures[1], radix: 16)
        , color = new nodes.RGBA(n, n, n, 1);
      color.raw = captures[0];
      return new Token('color', color);
    }
  }

  /**
   * #rgb
   */

  rgb() {
    var captures;
    if (truthy(captures = new RegExp(r'^#([a-fA-F0-9]{3})[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var rgb = captures[1]
        , r = int.parse(rgb[0] + rgb[0], radix: 16)
        , g = int.parse(rgb[1] + rgb[1], radix: 16)
        , b = int.parse(rgb[2] + rgb[2], radix: 16)
        , color = new nodes.RGBA(r, g, b, 1);
      color.raw = captures[0];
      return new Token('color', color);
    }
  }

  /**
   * #rgba
   */

  rgba() {
    var captures;
    if (truthy(captures = new RegExp(r'^#([a-fA-F0-9]{4})[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var rgb = captures[1]
        , r = int.parse(rgb[0] + rgb[0], radix: 16)
        , g = int.parse(rgb[1] + rgb[1], radix: 16)
        , b = int.parse(rgb[2] + rgb[2], radix: 16)
        , a = int.parse(rgb[3] + rgb[3], radix: 16)
        , color = new nodes.RGBA(r, g, b, a/255);
      color.raw = captures[0];
      return new Token('color', color);
    }
  }

  /**
   * #rrggbb
   */

  rrggbb() {
    var captures;
    if (truthy(captures = new RegExp(r'^#([a-fA-F0-9]{6})[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var rgb = captures[1]
        , r = int.parse(rgb.substr(0, 2), radix: 16)
        , g = int.parse(rgb.substr(2, 2), radix: 16)
        , b = int.parse(rgb.substr(4, 2), radix: 16)
        , color = new nodes.RGBA(r, g, b, 1);
      color.raw = captures[0];
      return new Token('color', color);
    }
  }

  /**
   * #rrggbbaa
   */

  rrggbbaa() {
    var captures;
    if (truthy(captures = new RegExp(r'^#([a-fA-F0-9]{8})[ \t]*').allMatches(this.str))) {
      this.skip(captures);
      var rgb = captures[1]
        , r = int.parse(rgb.substr(0, 2), radix: 16)
        , g = int.parse(rgb.substr(2, 2), radix: 16)
        , b = int.parse(rgb.substr(4, 2), radix: 16)
        , a = int.parse(rgb.substr(6, 2), radix: 16)
        , color = new nodes.RGBA(r, g, b, a/255);
      color.raw = captures[0];
      return new Token('color', color);
    }
  }

  /**
   * ^|[^\n,;]+
   */

  selector() {
    var captures;
    if (truthy(captures = new RegExp(r'^\^|.*?(?=\/\/(?![^\[]*\])|[,\n{])').allMatches(this.str))) {
      var selector = captures[0];
      this.skip(captures);
      return new Token('selector', selector);
    }
  }
}
