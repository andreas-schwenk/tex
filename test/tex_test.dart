/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

//import 'dart:io';
//import 'package:test/test.dart';

import 'package:tex/tex.dart';

void main() {
  print("test");
  // set the equation to render
  var src = "\\sum_{i=1}^5 i^2";
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
    //File('lib/tex/test/svg/test.svg').writeAsStringSync(output);
  }
}
