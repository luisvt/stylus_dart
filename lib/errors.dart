
/*!
 * Stylus - errors
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Initialize a new `ParseError` with the given `msg`.
 *
 * @param {String} msg
 * @api private
 */

class ParseError implements Exception {
  String name;

  var message;

  ParseError(msg) {
    this.name = 'ParseError';
    this.message = msg;
//    Error.captureStackTrace(this, ParseError);
  }
}
/**
 * Initialize a new `SyntaxError` with the given `msg`.
 *
 * @param {String} msg
 * @api private
 */

class SyntaxError implements Exception {
  String name;

  var message;

  SyntaxError(msg) {
    this.name = 'SyntaxError';
    this.message = msg;
//    Error.captureStackTrace(this, ParseError);
  }
}
