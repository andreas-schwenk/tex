/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'config.dart';
import 'gen.dart';
import 'parse.dart';
import 'svg.dart';
import 'typeset.dart';

/// Root class that provides TeX to SVG conversion.
class TeX {
  /// The recently parsed TeX input, stringified.
  String _parsed = '';

  /// The width of the most recent parsed TeX rendering.
  int _width = 0;

  /// The height of the most recent parsed TeX rendering.
  int _height = 0;

  /// The error messages.
  String _error = '';

  //// The Scaling factor.
  double _scalingFactor = 1.0;

  /// The red color
  int _colorRed = 0;

  /// The green color
  int _colorGreen = 0;

  /// The blue color
  int _colorBlue = 0;

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

  /// Gets the height of the last rendering.
  int get height {
    return _height;
  }

  /// Sets the scaling [factor].
  set scalingFactor(double factor) {
    _scalingFactor = factor;
  }

  /// Sets the [red], [green] and [blue] (RGB) color range 0 to 255 each.
  void setColor(int red, int green, int blue) {
    _colorRed = red;
    _colorGreen = green;
    _colorBlue = blue;
  }

  /// Returns the success: true := OK, false := errors occurred.
  bool success() {
    return _error.isEmpty;
  }

  /// Generates an SVG String from TeX [src]. By default, inline math is
  /// generated. Enable display style equations via [displayStyle].
  /// Parameter [debugMode] enables rendering bounding boxes around glyphs
  /// and groups of glyphs.
  /// Parameter [deltaYOffset] is e.g. useful for inline math.
  /// It adds (or subtracts in case it is negative) vertical space to the
  /// SVG view box. E.g. in the "flutter_svg" package you can set attribute
  /// "allowDrawingOutsideViewBox: true" to allow rendering outside the Widget.
  /// This allows better embedding of equations within TextWidgets.
  String tex2svg(String src,
      {displayStyle = false, debugMode = false, deltaYOffset = 128}) {
    if (src.contains("\\displaystyle")) {
      displayStyle = true;
      src = src.replaceAll("\\displaystyle", "");
    }
    globalDisplayStyle = displayStyle;
    _error = '';
    try {
      // recursively parse input into TexNodes
      var root = parse(src);
      // stringify TexNodes for debug purposes
      _parsed = root.toString();
      // typeset, i.e. calculate relative positions and scaling
      typeset(root, 0);
      // vertically move all glyphs, s.t. y=0 is exactly where the two lines of
      // glyph "x" intersect.
      root.translate(0, globalTranslateY);
      // generate SVG data
      var svgDATA = gen(debugMode, root, 4, _colorRed, _colorGreen, _colorBlue);
      // calculate the view box of the SVG image; note that the y-axis is
      // mirrored, since glyphs data in "svg.dart" are mirrored.
      var rootMinY = root.minY;
      var rootMaxY = root.minY + root.height;
      var deltaY = -rootMinY > rootMaxY ? -rootMinY : rootMaxY;
      deltaY += deltaYOffset;
      int viewBoxX = 0;
      int viewBoxWidth = (root.minX + root.width).round();
      int viewBoxY = -deltaY.round();
      int viewBoxHeight = (deltaY * 2.0).ceil();
      // make sure, that the view box width is always positive;
      // otherwise some SVG libraries might crash..
      if (viewBoxWidth == 0) viewBoxWidth = 100;
      // set the image width and height in pixels
      _width = (viewBoxWidth * 0.02 * _scalingFactor).round();
      _height = (viewBoxHeight * 0.02 * _scalingFactor).round();
      // generate SVG paths, i.e. polygons for all actually used glyphs
      var svgPaths = '';
      Set<String> usedLetters = {};
      root.getActuallyUsedGlyphs(usedLetters);
      for (var id in usedLetters) {
        var d = svgData[id];
        if (d == null) continue;
        svgPaths += '    <path id="$id" d="$d"></path>\n';
      }
      // optionally generate bounding rectangles around glyphs for debugging
      // purposes
      String boundingBoxes = '';
      if (debugMode) {
        boundingBoxes = '<rect x="-50" y="-50"'
            ' width="100" height="100"'
            ' fill="red">'
            '</rect>\n';
        boundingBoxes += '<rect x="${viewBoxWidth - 50}" y="-50"'
            ' width="100" height="100"'
            ' fill="red">'
            '</rect>\n';
        boundingBoxes += '<rect x="-50" y="${viewBoxHeight / 2 - 10}"'
            ' width="$viewBoxWidth" height="20"'
            ' fill="red">'
            '</rect>\n';
        boundingBoxes += '<rect x="-50" y="${-viewBoxHeight / 2 - 10}"'
            ' width="$viewBoxWidth" height="20"'
            ' fill="red">'
            '</rect>\n';
      }
      // create final output
      var output = '<svg width="$_width" height="$_height"'
          ' xmlns="http://www.w3.org/2000/svg" role="img"'
          ' focusable="false"'
          ' viewBox="$viewBoxX $viewBoxY $viewBoxWidth $viewBoxHeight"'
          ' xmlns:xlink="http://www.w3.org/1999/xlink">\n'
          '  <defs>\n$svgPaths  </defs>\n'
          '$boundingBoxes'
          '  <g transform="scale(1,-1)">\n'
          '$svgDATA'
          '  </g>\n'
          '</svg>\n';
      return output;
    } catch (e, stacktrace) {
      var s = stacktrace.toString();
      print(s);
      _error = e.toString();
      return "";
    }
  }
}
