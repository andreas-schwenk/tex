/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// This file demonstrates a short web example to integrate TeX equations as
/// inline math

import 'dart:html';
import 'dart:convert';

import 'package:tex/tex.dart';

void main() {
  setEquationToSpan("#einstein", "E=mc^2");
}

void setEquationToSpan(String spanId, String src) {
  // instantiate tex
  var tex = TeX();
  // set the scaling factor
  tex.scalingFactor = 1.0;
  // create SVG data from TeX data
  var svg = tex.tex2svg(src);
  // debug output to console
  print(svg);
  // successful?
  if (tex.success()) {
    // create an image element
    var svgBase64 = base64Encode(utf8.encode(svg));
    var img = document.createElement('img') as ImageElement;
    img.src = "data:image/svg+xml;base64,$svgBase64";
    img.style.verticalAlign = "bottom";
    // get the span element and add the image
    var span = querySelector(spanId) as SpanElement;
    span.innerHtml = '';
    span.append(img);
  }
}
