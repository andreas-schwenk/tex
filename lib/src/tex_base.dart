/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'config.dart';
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
  String _parsed = '';

  /// Width of recently parsed TeX rendering.
  int _width = 0;

  /// Error messages.
  String _error = '';

  //// Scaling factor.
  double _scalingFactor = 1.0;

  /// Gets the parsed and stringified TeX input for the last call of [tex2svg].
  String get parsed {
    return _parsed;
  }

  /// Gets the error for the last call of [tex2svg].
  String get error {
    return _error;
  }

  /// Gets the width of the last rendering.
  int get width {
    return _width;
  }

  /// Sets the scaling factor
  set scalingFactor(double factor) {
    _scalingFactor = factor;
  }

  /// Generates an SVG String from TeX [src].
  ///
  /// A debug output can be achieved by rendering bounding boxes via [paintBox].
  String tex2svg(String src, [paintBox = false]) {
    // tokenize input
    _lex.set(src);
    try {
      // recursively parse input into TexNodes
      var root = parseTexList(_lex, false);
      // stringify TexNodes for debug purposes
      _parsed = root.toString();
      // typeset, i.e. calculate relative positions and scaling
      typeset(root, 0, 0);
      // transform local coordinates into global coordinates
      root.calculateGlobalCoordinates();
      // vertically move all glyphs, s.t. y=0 is exactly where the two lines of
      // glyph "x" intersect.
      root.translate(0, globalTranslateY.toDouble());
      // generate SVG data
      var svgDATA = gen(paintBox, root, 4);
      // calculate the view box of the SVG image; note that the y-axis is
      // mirrored, since glyphs data in "svg.dart" are mirrored.
      var globalMin = root.getGlobalMinY();
      var globalMax = root.getGlobalMaxY();
      var deltaY = -globalMin > globalMax ? -globalMin : globalMax;
      int viewBoxX = 0;
      int viewBoxWidth = root.width;
      int viewBoxY = -deltaY.round();
      int viewBoxHeight = (deltaY * 2.0).ceil();
      // make sure, that the view box width is always positive;
      // otherwise some SVG libraries might crash..
      if (viewBoxWidth == 0) viewBoxWidth = 100;
      // get the image width in pixels
      _width = (viewBoxWidth * 0.02 * _scalingFactor).round();
      // generate SVG paths, i.e. polygons for all actually used glyphs
      var svgPaths = '';
      Set<String> usedLetters = {};
      root.getActuallyUsedGlyphs(usedLetters);
      for (var id in usedLetters) {
        var d = svgData[id];
        svgPaths += '    <path id="$id" d="$d"></path>\n';
      }
      // optionally generate bounding rectangles around glyphs for debugging
      // purposes
      String boundingBoxes = '';
      if (paintBox) {
        boundingBoxes = genBoundingBoxes(root);
      }
      // create final output
      var output =
          '<svg width="$_width" style="" xmlns="http://www.w3.org/2000/svg" role="img"'
          ' focusable="false" viewBox="$viewBoxX $viewBoxY $viewBoxWidth $viewBoxHeight"'
          ' xmlns:xlink="http://www.w3.org/1999/xlink">\n'
          '  <defs>\n$svgPaths  </defs>\n'
          '$boundingBoxes'
          '  <g transform="scale(1,-1)">\n'
          '$svgDATA'
          '  </g>'
          '</svg>\n';
      return output;
    } catch (e) {
      _error = e.toString();
      return "";
    }
  }
}
