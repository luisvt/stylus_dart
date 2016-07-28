
/*!
 * Stylus - stack - Frame
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import './scope.dart' show Scope;

/**
 * Initialize a new `Frame` with the given `block`.
 *
 * @param {Block} block
 * @api private
 */

class Frame {
  Scope _scope;

  var block;

  var parent;

  Frame(block) {
    this._scope = false == block.scope
        ? null
        : new Scope();
    this.block = block;
  }

  /**
   * Return this frame's scope or the parent scope
   * for scope-less blocks.
   *
   * @return {Scope}
   * @api public
   */
  get scope {
    return this._scope ?? this.parent.scope;
  }

  /**
   * Lookup the given local variable `name`.
   *
   * @param {String} name
   * @return {Node}
   * @api private
   */
  lookup(name) {
    return this.scope.lookup(name);
  }

  /**
   * Custom inspect.
   */
  String inspect() {
    return '[Frame '
        + (false == this.block.scope
            ? 'scope-less'
            : this.scope.inspect())
        + ']';
  }
}
