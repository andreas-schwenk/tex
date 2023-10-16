/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'package:tex/tex.dart';

void main() {
  // set the equation to render
  var src = "\\sum_{k=1}^n \\frac{1}{k(k+1)} = \\frac{n}{n+1}";
  // instantiate tex
  var tex = TeX();
  // set red color
  tex.setColor(255, 0, 0); // red, green, blue
  // set the scaling factor
  tex.scalingFactor = 2.0;
  // create SVG data
  var svgImageData = tex.tex2svg(src, displayStyle: true);
  // check for errors
  if (tex.success() == false) {
    print('Errors occurred: ${tex.error}');
  } else {
    // prints "<svg ...";
    print(svgImageData);
  }
}
