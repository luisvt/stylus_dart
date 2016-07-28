import '../utils.dart' as utils;
import '../visitor/normalizer.dart' show Normalizer;

/**
 * Returns true if the given selector exists.
 *
 * @param {String} sel
 * @return {Boolean}
 * @api public
 */

selectorExists(sel) {
  utils.assertString(sel, 'selector');

  if (!this.__selectorsMap__) {
    var visitor = new Normalizer(this.root.clone());
    visitor.visit(visitor.root);

    this.__selectorsMap__ = visitor.map;
  }

  return  this.__selectorsMap__.containsKey(sel.string);
};
