/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'package:tex/tex.dart';

void main() {
  // set the equation to render
  var src = "f(x,y) = x^2 + y^2";
  // instantiate tex
  var tex = TeX();
  // set the color (from black) to red
  tex.setColor(255, 0, 0);
  // set the scaling factor
  tex.scalingFactor = 2.0;
  // create SVG data
  var svgImageData = tex.tex2svg(src);
  // check for errors
  if (svgImageData.isEmpty) {
    print('Errors occurred: ${tex.error}');
  } else {
    // prints "<svg ...";
    print(svgImageData);
  }
}
