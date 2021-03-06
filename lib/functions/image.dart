

/*!
 * Stylus - plugin - url
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

/**
 * Module dependencies.
 */

import '../utils.dart' as utils;
import 'package:node_shims/js.dart';
import 'dart:math' as Math;

/**
 * Initialize a new `Image` with the given `ctx` and `path.
 *
 * @param {Evaluator} ctx
 * @param {String} path
 * @api private
 */

class Image {
  var ctx;

  var path;

  var fd;

  var length;

  var extname;

  Image(ctx, path) {
    this.ctx = ctx;
    this.path = utils.lookup(path, ctx.paths);
    if (!this.path) throw new Exception('failed to locate file ' + path);
  }


  /**
   * Open the image for reading.
   *
   * @api private
   */

  open() {
    this.fd = fs.openSync(this.path, 'r');
    this.length = fs
        .fstatSync(this.fd)
        .size;
    this.extname = slice(path.extname(this.path), 1);
  }

  /**
   * Close the file.
   *
   * @api private
   */

  close() {
    if (this.fd) fs.closeSync(this.fd);
  }

  /**
   * Return the type of image, supports:
   *
   *  - gif
   *  - png
   *  - jpeg
   *  - svg
   *
   * @return {String}
   * @api private
   */

  type() {
    var type
    ,
        buf = new Buffer(4);

    fs.readSync(this.fd, buf, 0, 4, 0);

    // GIF
    if (0x47 == buf[0] && 0x49 == buf[1] && 0x46 == buf[2]) type = 'gif';

    // PNG
    else if (0x50 == buf[1] && 0x4E == buf[2] && 0x47 == buf[3]) type = 'png';

    // JPEG
    else if (0xff == buf[0] && 0xd8 == buf[1]) type = 'jpeg';

    // SVG
    else if ('svg' == this.extname) type = this.extname;

    return type;
  }

  /**
   * Return image dimensions `[width, height]`.
   *
   * @return {Array}
   * @api private
   */

  size() {
    var type = this.type()
    ,
        width
    ,
        height
    ,
        buf
    ,
        offset
    ,
        blockSize
    ,
        parser;

    uint16(b) {
      return b[1] << 8 | b[0];
    }
    uint32(b) {
      return b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
    }

    // Determine dimensions
    switch (type) {
      case 'jpeg':
        buf = new Buffer(this.length);
        fs.readSync(this.fd, buf, 0, this.length, 0);
        offset = 4;
        blockSize = buf[offset] << 8 | buf[offset + 1];

        while (offset < this.length) {
          offset += blockSize;
          if (offset >= this.length || 0xff != buf[offset]) break;
          // SOF0 or SOF2 (progressive)
          if (0xc0 == buf[offset + 1] || 0xc2 == buf[offset + 1]) {
            height = buf[offset + 5] << 8 | buf[offset + 6];
            width = buf[offset + 7] << 8 | buf[offset + 8];
          } else {
            offset += 2;
            blockSize = buf[offset] << 8 | buf[offset + 1];
          }
        }
        break;
      case 'png':
        buf = new Buffer(8);
        // IHDR chunk width / height uint32_t big-endian
        fs.readSync(this.fd, buf, 0, 8, 16);
        width = uint32(buf);
        height = uint32(slice(buf, 4, 8));
        break;
      case 'gif':
        buf = new Buffer(4);
        // width / height uint16_t little-endian
        fs.readSync(this.fd, buf, 0, 4, 6);
        width = uint16(buf);
        height = uint16(slice(buf, 2, 4));
        break;
      case 'svg':
        offset = Math.min(this.length, 1024);
        buf = new Buffer(offset);
        fs.readSync(this.fd, buf, 0, offset, 0);
        buf = buf.toString('utf8');
        parser = sax.parser(true);
        parser.onopentag = (node) {
          if ('svg' == node.name && node.attributes.width && node.attributes.height) {
            width = int.parse(node.attributes.width, radix: 10);
            height = int.parse(node.attributes.height, radix: 10);
          }
        };
        parser.write(buf).close();
        break;
    }

    if (width is! num) throw new Exception('failed to find width of "' + this.path + '"');
    if (height is! num) throw new Exception('failed to find height of "' + this.path + '"');

    return [width, height];
  }
}