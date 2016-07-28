
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

import 'add-property.dart' show addProperty;
import 'adjust.dart' show adjust;
import 'alpha.dart' show alpha;
import 'base-convert.dart' show baseConvert;
import 'basename.dart' show basename;
import 'blend.dart' show blend;
import 'blue.dart' show blue;
import 'clone.dart' show clone;
import 'component.dart' show component;
import 'contrast.dart' show contrast;
import 'convert.dart' show convert;
import 'current-media.dart' show currentMedia;
import 'define.dart' show define;
import 'dirname.dart' show dirname;
import 'error.dart' show error;
import 'extname.dart' show extname;
import 'green.dart' show green;
import 'hsl.dart' show hsl;
import 'hsla.dart' show hsla;
import 'hue.dart' show hue;
import 'image-size.dart' show imageSize;
import 'json.dart' show json;
import 'length.dart' show length;
import 'lightness.dart' show lightness;
import 'list-separator.dart' show listSeparator;
import 'lookup.dart' show lookup;
import 'luminosity.dart' show luminosity;
import 'match.dart' show match;
import 'math.dart' show math;
import 'merge.dart' show merge;
import 'operate.dart' show operate;
import 'opposite-position.dart' show oppositePosition;
import 'p.dart' show p;
import 'pathjoin.dart' show pathjoin;
import 'pop.dart' show pop;
import 'push.dart' show push;
import 'range.dart' show range;
import 'red.dart' show red;
import 'remove.dart' show remove;
import 'replace.dart' show replace;
import 'rgb.dart' show rgb;
import 'rgba.dart' show rgba;
import 's.dart' show s;
import 'saturation.dart' show saturation;
import 'selector-exists.dart' show selectorExists;
import 'selector.dart' show selector;
import 'selectors.dart' show selectors;
import 'shift.dart' show shift;
import 'split.dart' show split;
import 'substr.dart' show substr;
import 'slice.dart' show slice;
import 'tan.dart' show tan;
import 'trace.dart' show trace;
import 'transparentify.dart' show transparentify;
import 'type.dart' show type;
import 'unit.dart' show unit;
import 'unquote.dart' show unquote;
import 'unshift.dart' show unshift;
import 'use.dart' show use;
import 'warn.dart' show warn;
import 'math-prop.dart' show mathProp;
import 'prefix-classes.dart' show prefixClasses;

var extend = merge;
var append = push;
var prepend = unshift;
var typeof = type;
var typeOf = type;

var bifs = {
  'addProperty': addProperty,
  'adjust': adjust,
  'alpha': alpha,
  'baseConvert': baseConvert,
  'basename': basename,
  'blend': blend,
  'blue': blue,
  'clone': clone,
  'component': component,
  'contrast': contrast,
  'convert': convert,
  'current-media': currentMedia,
  'define': define,
  'dirname': dirname,
  'error': error,
  'extname': extname,
  'green': green,
  'hsl': hsl,
  'hsla': hsla,
  'hue': hue,
  'imageSize': imageSize,
  'json': json,
  'length': length,
  'lightness': lightness,
  'listSeparator': listSeparator,
  'lookup': lookup,
  'luminosity': luminosity,
  'match': match,
  'math': math,
  'merge': merge,
  'operate': operate,
  'oppositePosition': oppositePosition,
  'p': p,
  'pathjoin': pathjoin,
  'pop': pop,
  'push': push,
  'range': range,
  'red': red,
  'remove': remove,
  'replace': replace,
  'rgb': rgb,
  'rgba': rgba,
  's': s,
  'saturation': saturation,
  'selectorExists': selectorExists,
  'selector': selector,
  'selectors': selectors,
  'shift': shift,
  'split': split,
  'substr': substr,
  'slice': slice,
  'tan': tan,
  'trace': trace,
  'transparentify': transparentify,
  'type': type,
  'unit': unit,
  'unquote': unquote,
  'unshift': unshift,
  'use': use,
  'warn': warn,
  'mathProp': mathProp,
  'prefixClasses': prefixClasses,

  'extend': merge,
  'append': push,
  'prepend': unshift,
  'typeof': type,
  'typeOf': type

};