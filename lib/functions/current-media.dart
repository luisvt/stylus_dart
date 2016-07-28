import '../nodes/index.dart' as nodes;
import 'package:node_shims/js.dart';

/**
 * Returns the @media string for the current block
 *
 * @return {String}
 * @api public
 */

var currentMedia = new _CurentMedia();

class _CurentMedia {
  var closestBlock;

  call() {
    var self = this;

    lookForMedia(node) {
      if ('media' == node.nodeName) {
        node.val = self.visit(node.val);
        return node.toString();
      } else if (node.block.parent.node) {
        return lookForMedia(node.block.parent.node);
      }
    }
    return new nodes.String(or(lookForMedia(this.closestBlock.node), ''));
  }
}
