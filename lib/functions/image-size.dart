import '../utils.dart' as utils;
import '../nodes/index.dart' as nodes;
import 'package:stylus_dart/functions/image.dart';

/**
 * Return the width and height of the given `img` path.
 *
 * Examples:
 *
 *    image-size('foo.png')
 *    // => 200px 100px
 *
 *    image-size('foo.png')[0]
 *    // => 200px
 *
 *    image-size('foo.png')[1]
 *    // => 100px
 *
 * Can be used to test if the image exists,
 * using an optional argument set to `true`
 * (without this argument this function throws error
 * if there is no such image).
 *
 * Example:
 *
 *    image-size('nosuchimage.png', true)[0]
 *    // => 0
 *
 * @param {String} img
 * @param {Boolean} ignoreErr
 * @return {Expression}
 * @api public
 */

imageSize(img, ignoreErr) {
  utils.assertType(img, 'string', 'img');
  var _img;
  try {
    _img = new Image(this, img.string);
  } catch (err) {
    if (ignoreErr) {
      return [new nodes.Unit(0), new nodes.Unit(0)];
    } else {
      throw err;
    }
  }

  // Read size
  _img.open();
  var size = img.size();
  img.close();

  // Return (w h)
  var expr = [];
  expr.add(new nodes.Unit(size[0], 'px'));
  expr.add(new nodes.Unit(size[1], 'px'));

  return expr;
}
