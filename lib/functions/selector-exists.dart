import '../utils.dart' show utils;

/**
 * Returns true if the given selector exists.
 *
 * @param {String} sel
 * @return {Boolean}
 * @api public
 */

module.exports =  selectorExists(sel) {
  utils.assertString(sel, 'selector');

  if (!this.__selectorsMap__) {
    import '../visitor/normalizer.dart' show Normalizer;
    visitor.visit(visitor.root);

    this.__selectorsMap__ = visitor.map;
  }

  return  this.__selectorsMap__.containsKey(sel.string);
};
