/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'package:tex/src/node.dart';

import 'gen.dart';
import 'lex.dart';
import 'parse.dart';
import 'svg.dart';
import 'typeset.dart';

/// Root class that provides TeX to SVG conversion.
class TeX {
  /// The lexer.
  final Lex _lex = Lex();

  /// Recently parsed TeX input, stringified.
  String _lastParsed = '';

  /// Error messages.
  String _error = '';

  //// Scaling factor.
  double _scalingFactor = 1.0;

  /// Gets the parsed and stringified TeX input for the last call of [tex2svg].
  String get lastParsed {
    return _lastParsed;
  }

  /// Gets the error for the last call of [tex2svg].
  String get error {
    return _error;
  }

  /// Sets the scaling factor
  set scalingFactor(double factor) {
    _scalingFactor = factor;
  }

  /// Generates an SVG String from TeX [src].
  ///
  /// A debug output can be achieved by rendering bounding boxes via [paintBox].
  String tex2svg(String src, [paintBox = false]) {
    _lex.set(src);
    try {
      var root = parseTexList(_lex, false);
      _lastParsed = root.toString();
      typeset(root, 0, 0);
      var commands = gen(paintBox, root, 4);
      var xx = _calcMinY(root);
      print('xx = $xx');
      final int belowHeight = -xx + 275; //275; // TODO
      int minX = 0;
      int minY = -root.height;
      int width = root.width;
      int height = root.height + belowHeight - xx;
      var defs = '';
      Set<String> usedLetters = {};
      _getUsedGlyphs(usedLetters, root);
      for (var id in usedLetters) {
        var d = svgData[id];
        defs += '    <path id="$id" d="$d"></path>\n';
      }
      if (width == 0) width = 100;
      String boundingBoxes = '';
      if (paintBox) {
        boundingBoxes = '    '
            '<rect x="0" y="${-belowHeight}" width="$width" height="$height"'
            ' fill="none" stroke="rgb(200,200,200)" stroke-width="50"></rect>\n'
            '    '
            '<rect x="0" y="0" width="$width" height="${height - belowHeight}"'
            ' fill="none" stroke="rgb(200,200,200)"'
            ' stroke-width="25"></rect>\n';
      }
      commands =
          '  <g stroke="currentColor" fill="currentColor" stroke-width="0"'
          ' transform="scale(1,-1)">\n$boundingBoxes$commands  </g>';
      var svg =
          '<svg width="${(width * 0.02 * _scalingFactor).round()}" style="" xmlns="http://www.w3.org/2000/svg" role="img"'
          ' focusable="false" viewBox="$minX $minY $width $height"'
          ' xmlns:xlink="http://www.w3.org/1999/xlink">\n'
          '  <defs>\n$defs  </defs>\n$commands\n'
          '</svg>\n';
      return svg;
    } catch (e) {
      _error = e.toString();
      return "";
    }
  }

  int _calcMinY(TeXNode node) {
    int minY = 0;
    for (var item in node.items) {
      int itemY = node.y + (_calcMinY(item) * item.scaling).round();
      if (itemY < minY) minY = itemY;
    }
    for (var arg in node.args) {
      int argY = node.y + (_calcMinY(arg) * arg.scaling).round();
      if (argY < minY) minY = argY;
    }
    if (node.sub != null) {
      var sub = node.sub as TeXNode;
      int subY = node.y + (_calcMinY(sub) * sub.scaling).round();
      if (subY < minY) minY = subY;
    }
    return minY;
  }

  /// Gets a set of all actually used glyphs for a [node].
  void _getUsedGlyphs(Set<String> usedLetters, TeXNode node) {
    if (node.svgPathId.isNotEmpty) {
      usedLetters.add(node.svgPathId);
    }
    for (var item in node.items) {
      _getUsedGlyphs(usedLetters, item);
    }
    for (var arg in node.args) {
      _getUsedGlyphs(usedLetters, arg);
    }
    if (node.sub != null) {
      _getUsedGlyphs(usedLetters, node.sub as TeXNode);
    }
    if (node.sup != null) {
      _getUsedGlyphs(usedLetters, node.sup as TeXNode);
    }
  }
}
