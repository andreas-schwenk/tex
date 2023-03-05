/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

// TODO: documentation

import 'package:tex/src/node.dart';

import 'gen.dart';
import 'lex.dart';
import 'parse.dart';
import 'svg.dart';
import 'typeset.dart';

class TeX {
  final Lex _lex = Lex();

  String _lastParsed = '';
  String _error = '';

  String get lastParsed {
    return _lastParsed;
  }

  String get error {
    return _error;
  }

  String tex2svg(String src, [paintBox = false]) {
    _lex.set(src);
    try {
      var root = parseTexList(_lex, false);
      _lastParsed = root.toString();
      print(_lastParsed); // TODO: remove this
      typeset(root, 0, 0);
      var commands = gen(paintBox, root, 4);
      final int belowHeight = 275; // TODO
      int minX = 0;
      int minY = -root.height;
      int width = root.width;
      int height = root.height + belowHeight;
      var defs = '';
      Set<String> usedLetters = {};
      _getUsedLetters(usedLetters, root);
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
      var svg = '<svg style="" xmlns="http://www.w3.org/2000/svg" role="img"'
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

  void _getUsedLetters(Set<String> usedLetters, TeXNode node) {
    if (node.svgPathId.isNotEmpty) {
      usedLetters.add(node.svgPathId);
    }
    for (var item in node.items) {
      _getUsedLetters(usedLetters, item);
    }
    for (var arg in node.args) {
      _getUsedLetters(usedLetters, arg);
    }
    if (node.sub != null) {
      _getUsedLetters(usedLetters, node.sub as TeXNode);
    }
    if (node.sup != null) {
      _getUsedLetters(usedLetters, node.sup as TeXNode);
    }
  }
}
