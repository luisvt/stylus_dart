
/*!
 * Stylus - Evaluator - built-in functions
 * Copyright (c) Automattic <developer.wordpress.com>
 * MIT Licensed
 */

export 'add-property.dart' show addProperty;
export 'adjust.dart' show adjust;
export 'alpha.dart' show alpha;
export 'base-convert.dart' show baseConvert;
export 'basename.dart' show basename;
export 'blend.dart' show blend;
export 'blue.dart' show blue;
export 'clone.dart' show clone;
export 'component.dart' show component;
export 'contrast.dart' show contrast;
export 'convert.dart' show convert;
export 'current-media.dart' show currentMedia;
export 'define.dart' show define;
export 'dirname.dart' show dirname;
export 'error.dart' show error;
export 'extname.dart' show extname;
export 'green.dart' show green;
export 'hsl.dart' show hsl;
export 'hsla.dart' show hsla;
export 'hue.dart' show hue;
export 'image-size.dart' show imageSize;
export 'json.dart' show json;
export 'length.dart' show length;
export 'lightness.dart' show lightness;
export 'list-separator.dart' show listSeparator;
export 'lookup.dart' show lookup;
export 'luminosity.dart' show luminosity;
export 'match.dart' show match;
export 'math.dart' show math;
export 'merge.dart' show merge;
export 'operate.dart' show operate;
export 'opposite-position.dart' show oppositePosition;
export 'p.dart' show p;
export 'pathjoin.dart' show pathjoin;
export 'pop.dart' show pop;
export 'push.dart' show push;
export 'range.dart' show range;
export 'red.dart' show red;
export 'remove.dart' show remove;
export 'replace.dart' show replace;
export 'rgb.dart' show rgb;
export 'rgba.dart' show rgba;
export 's.dart' show s;
export 'saturation.dart' show saturation;
export 'selector-exists.dart' show selectorExists;
export 'selector.dart' show selector;
export 'selectors.dart' show selectors;
export 'shift.dart' show shift;
export 'split.dart' show split;
export 'substr.dart' show substr;
export 'slice.dart' show slice;
export 'tan.dart' show tan;
export 'trace.dart' show trace;
export 'transparentify.dart' show transparentify;
export 'type.dart' show type;
export 'unit.dart' show unit;
export 'unquote.dart' show unquote;
export 'unshift.dart' show unshift;
export 'use.dart' show use;
export 'warn.dart' show warn;
export 'math-prop.dart' show mathProp;
export 'prefix-classes.dart' show prefixClasses;

import 'push.dart';
import 'merge.dart';
import 'unshift.dart';
import 'type.dart';

var extend = merge;
var append = push;
var prepend = unshift;
var typeof = type;
var typeOf = type;