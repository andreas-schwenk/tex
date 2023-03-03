import 'package:tex/tex.dart';
//import 'dart:tex';

void main() {
  var tex = TeX();
  var svgImageData = tex.tex2svg("x^2 + y^2");
  if (svgImageData.isEmpty) {
    print('Errors occurred: ${tex.error}');
  }
  print(svgImageData);
}
