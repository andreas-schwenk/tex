/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'dart:io';

import 'package:tex/tex.dart';

void main() {
  // set the equation to render

  // var src = "\\sum_{i=1}^5 i^2";

  // var src = //
  //     "\\left| \\frac12 \\right|,"
  //     "\\left( \\frac12 \\right),"
  //     "\\left[ \\frac12 \\right],"
  //     "\\left\\{ \\frac12 \\right\\},"
  //     "\\left\\{ \\frac{\\frac12}{ \\left( \\frac34 \\right) } \\right\\},"
  //     "\\left\\{ 1 \\right\\},"
  //     "\\left[ 1 \\right],"
  //     "\\left( 1 \\right),"
  //     "\\left( . \\right)";

  // var src =
  //     "1, \\frac12, \\frac{1}{\\frac23}, \\frac{1}{\\frac{2}{\\frac34}},\\frac21, \\frac{\\frac23}{1}, \\frac{x+\\frac{2}{\\frac43}}{1},\\frac{x+2}1";

  // var src = "x \\begin{bmatrix}"
  //     "\\frac12 & 2 \\\\"
  //     "3 & 4 \\\\"
  //     "\\end{bmatrix} y ~~~" //
  //     "x \\begin{bmatrix}"
  //     "a & b \\\\"
  //     "c+1 & d \\\\"
  //     "e & f \\\\"
  //     "g & h \\\\"
  //     "\\end{bmatrix} y";

  //var src = "r \\sin(x) + \\cos x";
  var src = "\\overline{abc}";

  // instantiate tex
  var tex = TeX();
  // set red color
  tex.setColor(255, 0, 0); // red, green, blue
  // set the scaling factor
  tex.scalingFactor = 2.0;
  // create SVG data
  var svgImageData = tex.tex2svg(src, //
      displayStyle: true,
      debugMode: true);
  // check for errors
  if (tex.success() == false) {
    print('Errors occurred: ${tex.error}');
  } else {
    // prints "<svg ...";
    print(svgImageData);
    File('test/tmp.svg').writeAsString(svgImageData);
  }
}
