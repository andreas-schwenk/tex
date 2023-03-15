/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
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
  var tex = TeX();
  tex.scalingFactor = 1.0;
  var svg = tex.tex2svg(src);
  print(svg);
  if (svg.isNotEmpty) {
    var svgBase64 = base64Encode(utf8.encode(svg));
    var img = document.createElement('img') as ImageElement;
    img.src = "data:image/svg+xml;base64,$svgBase64";
    img.style.verticalAlign = "bottom";
    var span = querySelector(spanId) as SpanElement;
    span.innerHtml = '';
    span.append(img);
  }
}
