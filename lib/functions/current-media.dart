import '../nodes.dart' show nodes;

/**
 * Returns the @media string for the current block
 *
 * @return {String}
 * @api public
 */

module.exports =  currentMedia(){
  var self = this;
  return new nodes.String(or(lookForMedia(this.closestBlock.node), ''));

   lookForMedia(node){
    if ('media' == node.nodeName) {
      node.val = self.visit(node.val);
      return node.toString();
    } else if (node.block.parent.node) {
      return lookForMedia(node.block.parent.node);
    }
  }
};
